import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../app/env.dart';
import '../../../../app/injection.dart';
import '../../../../core/config/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../auth/domain/usecases/get_current_user.dart';
import '../../../profile/domain/entities/user_role.dart';
import '../../../profile/domain/repositories/session_repository.dart';
import '../../../profile/domain/repositories/profile_repository.dart';
import '../cubit/chat_room_cubit.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatRoomPage extends StatefulWidget {
  final String conversationId;

  const ChatRoomPage({required this.conversationId, super.key});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
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
            failureMessage ?? 'Authentication required to open the chat.',
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
        final appBar = AppBar(title: const Text(AppStrings.chatRoom));

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: appBar,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final resolved = snapshot.data;

        if (resolved == null || resolved.errorMessage != null) {
          return Scaffold(
            appBar: appBar,
            body: ErrorView(
              message:
                  resolved?.errorMessage ??
                  'Unable to load this chat. Please try again.',
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
          create: (_) {
            final cubit = sl<ChatRoomCubit>();
            cubit.streamMessagesFor(widget.conversationId);
            cubit.markConversationAsRead(
              conversationId: widget.conversationId,
              userId: userId,
            );
            return cubit;
          },
          child: _ChatRoomView(
            conversationId: widget.conversationId,
            currentUserId: userId,
          ),
        );
      },
    );
  }
}

class _ChatRoomView extends StatefulWidget {
  final String conversationId;
  final String currentUserId;

  const _ChatRoomView({
    required this.conversationId,
    required this.currentUserId,
  });

  @override
  State<_ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<_ChatRoomView> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    context.read<ChatRoomCubit>().sendMessageAction(
      conversationId: widget.conversationId,
      senderId: widget.currentUserId,
      text: text,
    );

    _textController.clear();

    Future.delayed(const Duration(milliseconds: 500), _scrollToBottom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: sl<ChatRepository>().listConversations(widget.currentUserId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text(AppStrings.chatRoom);
            }

            final result = snapshot.data!;
            return result.when(
              ok: (conversations) {
                if (conversations.isEmpty) {
                  return const Text(AppStrings.chatRoom);
                }

                final conv = conversations.firstWhere(
                  (c) => c.id == widget.conversationId,
                  orElse: () => conversations.first,
                );

                final otherUserId = conv.clientId == widget.currentUserId
                    ? conv.professionalId
                    : conv.clientId;

                return FutureBuilder(
                  future: sl<ProfileRepository>().getProfileById(otherUserId),
                  builder: (context, profileSnapshot) {
                    if (!profileSnapshot.hasData) {
                      return const Text(AppStrings.chatRoom);
                    }

                    final profileResult = profileSnapshot.data!;
                    return profileResult.fold(
                      (failure) => const Text(AppStrings.chatRoom),
                      (profile) => Text(profile.fullName),
                    );
                  },
                );
              },
              err: (_) => const Text(AppStrings.chatRoom),
            );
          },
        ),
        actions: [
          FutureBuilder(
            future: sl<ChatRepository>().listConversations(
              widget.currentUserId,
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();

              final result = snapshot.data!;
              return result.when(
                ok: (conversations) {
                  final conv = conversations.firstWhere(
                    (c) => c.id == widget.conversationId,
                    orElse: () => conversations.first,
                  );

                  if (conv.clientId == widget.currentUserId) {
                    return IconButton(
                      icon: const Icon(Icons.person),
                      tooltip: 'حساب الصنايعي',
                      onPressed: () {
                        context.push('/professionals/${conv.professionalId}');
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
                err: (_) => const SizedBox.shrink(),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<ChatRoomCubit, ChatRoomState>(
        listener: (context, state) {
          if (state.toString().contains('_Error')) {
            final errorState = state as dynamic;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorState.message as String),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.toString().contains('_Loading')) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.toString().contains('_Error')) {
            final errorState = state as dynamic;
            return ErrorView(
              message: errorState.message as String,
              onRetry: () => context.read<ChatRoomCubit>().streamMessagesFor(
                widget.conversationId,
              ),
            );
          }

          if (state.toString().contains('_Loaded')) {
            final messagesState = state as dynamic;
            final messages = messagesState.messages as List<Message>;

            WidgetsBinding.instance.addPostFrameCallback(
              (_) => _scrollToBottom(),
            );

            return Column(
              children: [
                Expanded(
                  child: messages.isEmpty
                      ? Center(
                          child: Text(
                            AppStrings.noMessages,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(AppSpacing.md),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return _MessageBubble(
                              message: messages[index],
                              currentUserId: widget.currentUserId,
                            );
                          },
                        ),
                ),
                _MessageInput(
                  controller: _textController,
                  onSend: _sendMessage,
                  isSending: false,
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;
  final String currentUserId;

  const _MessageBubble({required this.message, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    final isCurrentUser = message.senderId == currentUserId;
    final dateFormat = DateFormat('HH:mm', 'ar');

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isCurrentUser
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isCurrentUser
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              dateFormat.format(message.createdAt),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isCurrentUser
                    ? Theme.of(
                        context,
                      ).colorScheme.onPrimary.withValues(alpha: 0.7)
                    : Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isSending;

  const _MessageInput({
    required this.controller,
    required this.onSend,
    required this.isSending,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: AppStrings.typeMessage,
                  filled: true,
                  fillColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            IconButton.filled(
              onPressed: isSending ? null : onSend,
              icon: isSending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResolvedChatUser {
  final String? userId;
  final String? errorMessage;

  const _ResolvedChatUser({this.userId, this.errorMessage});
}
