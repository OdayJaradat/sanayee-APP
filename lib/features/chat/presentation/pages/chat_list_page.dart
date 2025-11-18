import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../app/env.dart';
import '../../../../app/injection.dart';
import '../../../../core/config/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import '../../../auth/domain/usecases/get_current_user.dart';
import '../../../profile/domain/entities/user_role.dart';
import '../../../profile/domain/repositories/session_repository.dart';
import '../cubit/chat_list_cubit.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  late Future<_ResolvedChatUser> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _loadUser();
  }

  Future<_ResolvedChatUser> _loadUser() async {
    if (!Env.useAuth) {
      final sessionRepo = sl<SessionRepository>();
      final role = sessionRepo.getCurrentRoleSync();
      final fallbackId = role == UserRole.professional ? 'pro-1' : 'client-1';
      return _ResolvedChatUser(userId: fallbackId);
    }

    final result = await sl<GetCurrentUser>()();
    String? failureMessage;
    final user = result.fold((failure) {
      failureMessage = failure.message;
      return null;
    }, (user) => user);

    if (user == null) {
      return _ResolvedChatUser(
        errorMessage:
            failureMessage ?? 'Authentication required to view your chats.',
      );
    }

    return _ResolvedChatUser(userId: user.id);
  }

  void _retry() {
    setState(() {
      _userFuture = _loadUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_ResolvedChatUser>(
      future: _userFuture,
      builder: (context, snapshot) {
        final appBar = AppBar(title: const Text(AppStrings.chats));

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: appBar,
            body: const ShimmerList(itemCount: 5),
          );
        }

        final resolved = snapshot.data;

        if (resolved == null || resolved.errorMessage != null) {
          return Scaffold(
            appBar: appBar,
            body: ErrorView(
              message:
                  resolved?.errorMessage ??
                  'Unable to load chats. Please try again.',
              onRetry: _retry,
            ),
          );
        }

        if (resolved.userId == null) {
          return Scaffold(
            appBar: appBar,
            body: ErrorView(
              message: 'Unable to resolve current user. Please try again.',
              onRetry: _retry,
            ),
          );
        }

        final userId = resolved.userId!;

        return BlocProvider(
          create: (_) => sl<ChatListCubit>()..streamConversations(),
          child: _ChatListView(currentUserId: userId),
        );
      },
    );
  }
}

class _ResolvedChatUser {
  final String? userId;
  final String? errorMessage;

  const _ResolvedChatUser({this.userId, this.errorMessage});
}

class _ChatListView extends StatelessWidget {
  final String currentUserId;

  const _ChatListView({required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.chats)),
      body: BlocConsumer<ChatListCubit, ChatListState>(
        listener: (context, state) {
          if (state.toString().contains('_Error')) {
            final errorState = state as dynamic;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorState.message as String),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.toString().contains('_Loading')) {
            return const ShimmerList(itemCount: 5);
          }

          if (state.toString().contains('_Error')) {
            final errorState = state as dynamic;
            return ErrorView(
              message: errorState.message as String,
              onRetry: () => context
                  .read<ChatListCubit>()
                  .streamConversationsFor(currentUserId),
            );
          }

          if (state.toString().contains('_Loaded')) {
            final loadedState = state as dynamic;
            final conversations =
                loadedState.conversations as List<ConversationWithTitle>;

            if (conversations.isEmpty) {
              return const EmptyState(
                icon: Icons.chat_bubble_outline,
                title: AppStrings.noChats,
                message: AppStrings.noChatsMessage,
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.sm),
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final convWithTitle = conversations[index];
                return Slidable(
                  key: ValueKey('slidable_${convWithTitle.conversation.id}'),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (_) {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('حذف المحادثة'),
                              content: const Text(
                                'هل أنت متأكد من حذف هذه المحادثة؟',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  child: const Text('إلغاء'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                    context
                                        .read<ChatListCubit>()
                                        .deleteConversation(
                                          conversationId:
                                              convWithTitle.conversation.id,
                                          userId: currentUserId,
                                        );
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  child: const Text('حذف'),
                                ),
                              ],
                            ),
                          );
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'حذف',
                      ),
                    ],
                  ),
                  child: _ConversationCard(
                    currentUserId: currentUserId,
                    conversationWithTitle: convWithTitle,
                    onTap: () =>
                        context.push('/chats/${convWithTitle.conversation.id}'),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ConversationCard extends StatelessWidget {
  final ConversationWithTitle conversationWithTitle;
  final VoidCallback onTap;
  final String currentUserId;

  const _ConversationCard({
    required this.conversationWithTitle,
    required this.onTap,
    required this.currentUserId,
  });

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm', 'ar').format(dateTime);
    } else if (difference.inDays == 1) {
      return 'أمس';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE', 'ar').format(dateTime);
    } else {
      return DateFormat('dd/MM', 'ar').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final conversation = conversationWithTitle.conversation;
    final unreadCount = conversation.getUnreadCountFor(currentUserId);
    final hasUnread = unreadCount > 0;

    final firstLetter = conversationWithTitle.requestTitle.isNotEmpty
        ? conversationWithTitle.requestTitle[0]
        : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: hasUnread
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.1)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        border: Border.all(
          color: hasUnread
              ? theme.colorScheme.primary.withValues(alpha: 0.3)
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: hasUnread ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.primaryContainer,
                          theme.colorScheme.primaryContainer.withValues(
                            alpha: 0.7,
                          ),
                        ],
                      ),
                      boxShadow: hasUnread
                          ? [
                              BoxShadow(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.3,
                                ),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        firstLetter,
                        style: TextStyle(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  if (hasUnread)
                    Positioned(
                      left: -4,
                      top: -4,
                      child: Container(
                        key: const ValueKey('chat_unread_badge'),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.error,
                              theme.colorScheme.error.withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.error.withValues(
                                alpha: 0.4,
                              ),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          unreadCount > 99 ? '99+' : unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            conversationWithTitle.requestTitle,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: hasUnread
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                              color: hasUnread
                                  ? theme.colorScheme.onSurface
                                  : null,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (conversation.lastMessageAt != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: hasUnread
                                  ? theme.colorScheme.primary.withValues(
                                      alpha: 0.15,
                                    )
                                  : theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _formatDate(conversation.lastMessageAt!),
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: hasUnread
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: hasUnread
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface.withValues(
                                        alpha: 0.6,
                                      ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.topic_outlined,
                          size: 14,
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.7,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            conversationWithTitle.requestSubtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.8,
                              ),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 14,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            conversation.lastMessageText ??
                                AppStrings.noMessages,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: hasUnread
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                              color: conversation.lastMessageText != null
                                  ? theme.colorScheme.onSurface.withValues(
                                      alpha: hasUnread ? 0.9 : 0.7,
                                    )
                                  : theme.colorScheme.onSurface.withValues(
                                      alpha: 0.4,
                                    ),
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: hasUnread
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
