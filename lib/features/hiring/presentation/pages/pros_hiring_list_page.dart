import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/injection.dart';
import '../../../../core/config/app_spacing.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../domain/entities/hiring_post.dart';
import '../cubit/hiring_posts_cubit.dart';
import '../cubit/hiring_posts_state.dart';

class ProsHiringListPage extends StatelessWidget {
  const ProsHiringListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HiringPostsCubit>(),
      child: const _ProsHiringListView(),
    );
  }
}

class _ProsHiringListView extends StatefulWidget {
  const _ProsHiringListView();

  @override
  State<_ProsHiringListView> createState() => _ProsHiringListViewState();
}

class _ProsHiringListViewState extends State<_ProsHiringListView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (_isInitialized && !_tabController.indexIsChanging) {
        _loadPosts();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      _loadPosts();
    }
  }

  void _loadPosts() {
    try {
      final authCubit = context.read<AuthCubit>();
      final authState = authCubit.state;
      authState.maybeWhen(
        authenticated: (user) {
          if (user.role.isProfessional) {
            context.read<HiringPostsCubit>().loadMyPosts(user.id);
          } else {
            context.read<HiringPostsCubit>().loadOpenPosts();
          }
        },
        orElse: () {},
      );
    } catch (e) {
      context.read<HiringPostsCubit>().loadOpenPosts();
    }
  }

  void _closePost(String postId) async {
    final cubit = context.read<HiringPostsCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('إغلاق الإعلان'),
        content: const Text('هل أنت متأكد من إغلاق هذا الإعلان؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      cubit.closePost(postId);
    }
  }

  void _reopenPost(String postId) async {
    final cubit = context.read<HiringPostsCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('إعادة تفعيل الإعلان'),
        content: const Text(
          'هل تريد إعادة تفعيل هذا الإعلان ونقله للإعلانات المفتوحة؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.green[700]!),
            child: const Text('إعادة تفعيل'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      cubit.reopenPost(postId);
    }
  }

  void _deletePost(String postId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('حذف الإعلان نهائياً'),
        content: const Text(
          'هل أنت متأكد من حذف هذا الإعلان نهائياً؟\nلا يمكن التراجع عن هذا الإجراء.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red[700]!),
            child: const Text('حذف نهائياً'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      context.read<HiringPostsCubit>().deletePost(postId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bool isProfessional = false;

    try {
      final authState = context.watch<AuthCubit>().state;
      authState.maybeWhen(
        authenticated: (user) {
          isProfessional = user.role.isProfessional;
        },
        orElse: () {},
      );
    } catch (e) {
      isProfessional = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('إعلانات التوظيف'),
        actions: [
          if (isProfessional)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadPosts,
              tooltip: 'تحديث',
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'الإعلانات المفتوحة', icon: Icon(Icons.work, size: 20)),
            Tab(text: 'الإعلانات المغلقة', icon: Icon(Icons.archive, size: 20)),
          ],
        ),
      ),
      floatingActionButton: isProfessional
          ? FloatingActionButton.extended(
              onPressed: () async {
                final result = await context.push('/pro/hiring/create');
                if (result == true && mounted) {
                  _loadPosts();
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('نشر إعلان'),
            )
          : null,
      body: BlocConsumer<HiringPostsCubit, HiringPostsState>(
        listener: (context, state) {
          if (state is HiringPostOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
            if (state.message.contains('إغلاق')) {
              _tabController.animateTo(1);
            }
            if (state.message.contains('إعادة تفعيل')) {
              _tabController.animateTo(0);
            }
          } else if (state is HiringPostOperationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is HiringPostsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HiringPostsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton.icon(
                    onPressed: _loadPosts,
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          if (state is HiringPostsLoaded) {
            final openPosts = state.posts.where((p) => p.isOpen).toList();
            final closedPosts = state.posts.where((p) => p.isClosed).toList();

            return TabBarView(
              controller: _tabController,
              children: [
                _buildPostsList(context, openPosts, true, isProfessional),
                _buildPostsList(context, closedPosts, false, isProfessional),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildPostsList(
    BuildContext context,
    List<HiringPost> posts,
    bool isOpenTab,
    bool isProfessional,
  ) {
    if (posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isOpenTab ? Icons.work_outline : Icons.archive_outlined,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              isOpenTab ? 'لا توجد إعلانات مفتوحة' : 'لا توجد إعلانات مغلقة',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              isOpenTab
                  ? 'قم بنشر إعلان جديد لتوظيف عامل مناسب'
                  : 'الإعلانات المغلقة ستظهر هنا',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[400]),
              textAlign: TextAlign.center,
            ),
            if (isOpenTab && isProfessional) ...[
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await context.push('/pro/hiring/create');
                  if (result == true && mounted) {
                    _loadPosts();
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('نشر إعلان جديد'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _loadPosts(),
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];

          if (!isOpenTab && isProfessional) {
            return Slidable(
              key: ValueKey(post.id),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (_) => _reopenPost(post.id),
                    backgroundColor: Colors.green[700]!,
                    foregroundColor: Colors.white,
                    icon: Icons.restart_alt,
                    label: 'إعادة تفعيل',
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(16),
                    ),
                  ),
                  SlidableAction(
                    onPressed: (_) => _deletePost(post.id),
                    backgroundColor: Colors.red[700]!,
                    foregroundColor: Colors.white,
                    icon: Icons.delete_forever,
                    label: 'حذف',
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(16),
                    ),
                  ),
                ],
              ),
              child: _ModernHiringCard(
                post: post,
                isOpen: false,
                onClose: null,
              ),
            );
          }

          return _ModernHiringCard(
            post: post,
            isOpen: isOpenTab,
            onClose: isOpenTab && isProfessional
                ? () => _closePost(post.id)
                : null,
          );
        },
      ),
    );
  }
}

class _ModernHiringCard extends StatelessWidget {
  final HiringPost post;
  final bool isOpen;
  final VoidCallback? onClose;

  const _ModernHiringCard({
    required this.post,
    required this.isOpen,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOpen
              ? theme.colorScheme.primary.withValues(alpha: 0.3)
              : theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isOpen
                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isOpen
                      ? [
                          theme.colorScheme.primaryContainer,
                          theme.colorScheme.primaryContainer.withValues(
                            alpha: 0.5,
                          ),
                        ]
                      : [
                          theme.colorScheme.surfaceContainerHighest,
                          theme.colorScheme.surfaceContainerHigh,
                        ],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isOpen
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color:
                              (isOpen
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.outline)
                                  .withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.work,
                      color: isOpen
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          post.jobType.displayName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isOpen
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isOpen ? Colors.green : Colors.grey[600],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isOpen ? Icons.check_circle : Icons.archive,
                          size: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isOpen ? 'مفتوح' : 'مغلق',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (post.category != null)
                        _InfoChip(
                          icon: Icons.category,
                          label: post.category!.displayName,
                          color: theme.colorScheme.tertiary,
                        ),
                      if (post.governorate != null)
                        _InfoChip(
                          icon: Icons.location_on,
                          label: post.governorate!,
                          color: theme.colorScheme.secondary,
                        ),
                      if (post.locality != null)
                        _InfoChip(
                          icon: Icons.location_city,
                          label: post.locality!,
                          color: theme.colorScheme.secondary,
                        ),
                      if (post.payType != null)
                        _InfoChip(
                          icon: Icons.payments,
                          label: post.payType!.displayName,
                          color: Colors.green,
                        ),
                      if (post.fixedAmount != null)
                        _InfoChip(
                          icon: Icons.attach_money,
                          label: '${post.fixedAmount!.toStringAsFixed(0)} ₪',
                          color: Colors.amber[700]!,
                        ),
                      if (post.rangeMin != null && post.rangeMax != null)
                        _InfoChip(
                          icon: Icons.trending_up,
                          label:
                              '${post.rangeMin!.toStringAsFixed(0)}-${post.rangeMax!.toStringAsFixed(0)} ₪',
                          color: Colors.amber[700]!,
                        ),
                      _InfoChip(
                        icon: Icons.access_time,
                        label: DateFormatter.timeAgo(post.createdAt),
                        color: theme.colorScheme.outline,
                      ),
                    ],
                  ),

                  if (onClose != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: onClose,
                        icon: const Icon(Icons.close, size: 18),
                        label: const Text('إغلاق الإعلان'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: BorderSide(
                            color: Colors.red.withValues(alpha: 0.5),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
