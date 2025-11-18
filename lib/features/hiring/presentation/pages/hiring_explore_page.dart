import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/injection.dart';
import '../../../../core/config/app_spacing.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../auth/domain/usecases/get_current_user.dart';
import '../../domain/usecases/ensure_conversation_for_hiring.dart';
import '../cubit/hiring_posts_cubit.dart';
import '../cubit/hiring_posts_state.dart';

class HiringExplorePage extends StatelessWidget {
  const HiringExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HiringPostsCubit>()..loadOpenPosts(),
      child: const _HiringExploreView(),
    );
  }
}

class _HiringExploreView extends StatefulWidget {
  const _HiringExploreView();

  @override
  State<_HiringExploreView> createState() => _HiringExploreViewState();
}

class _HiringExploreViewState extends State<_HiringExploreView> {
  void _contactPoster(String postId, String posterProfessionalId) async {
    if (!mounted) return;

    final getCurrentUser = sl<GetCurrentUser>();
    final userResult = await getCurrentUser();

    final user = userResult.fold((failure) => null, (user) => user);

    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يجب تسجيل الدخول أولاً'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final ensureConversation = sl<EnsureConversationForHiring>();
      final result = await ensureConversation(
        postId: postId,
        ownerId: posterProfessionalId,
        applicantId: user.id,
      );

      if (!mounted) return;
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      if (!mounted) return;

      result.when(
        ok: (conversationId) {
          context.push('/chats/$conversationId');
        },
        err: (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failure.message),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('فرص التوظيف')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            color: Colors.blue[50],
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'يمكنك استعراض إعلانات التوظيف والتواصل مع أصحابها',
                    style: TextStyle(color: Colors.blue[900], fontSize: 13),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: BlocBuilder<HiringPostsCubit, HiringPostsState>(
              builder: (context, state) {
                if (state is HiringPostsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is HiringPostsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.message),
                        const SizedBox(height: AppSpacing.md),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<HiringPostsCubit>().loadOpenPosts(),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is HiringPostsLoaded) {
                  if (state.posts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.work_outline,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'لا توجد فرص توظيف حالياً',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async =>
                        context.read<HiringPostsCubit>().loadOpenPosts(),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      itemCount: state.posts.length,
                      itemBuilder: (context, index) {
                        final post = state.posts[index];
                        return _ModernHiringCard(
                          post: post,
                          onTap: () => _showPostDetails(context, post),
                          onContact: () =>
                              _contactPoster(post.id, post.professionalId),
                        );
                      },
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showPostDetails(BuildContext context, post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Text(
                post.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  post.jobType.displayName,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              Text(
                'الوصف',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                post.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.lg),

              Text(
                'التفاصيل',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.sm),

              if (post.category != null) ...[
                _DetailRow(
                  icon: Icons.category,
                  label: 'التصنيف',
                  value: post.category!.displayName,
                ),
                const SizedBox(height: AppSpacing.sm),
              ],

              if (post.governorate != null) ...[
                _DetailRow(
                  icon: Icons.location_on,
                  label: 'المحافظة',
                  value: post.governorate!,
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              if (post.locality != null) ...[
                _DetailRow(
                  icon: Icons.location_city,
                  label: 'البلدة/المدينة',
                  value: post.locality!,
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              if (post.address != null) ...[
                _DetailRow(
                  icon: Icons.place,
                  label: 'العنوان',
                  value: post.address!,
                ),
                const SizedBox(height: AppSpacing.sm),
              ],

              if (post.payType != null) ...[
                _DetailRow(
                  icon: Icons.payments,
                  label: 'نوع الدفع',
                  value: post.payType!.displayName,
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              if (post.fixedAmount != null) ...[
                _DetailRow(
                  icon: Icons.attach_money,
                  label: 'المبلغ',
                  value: '${post.fixedAmount!.toStringAsFixed(0)} ₪',
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              if (post.rangeMin != null && post.rangeMax != null) ...[
                _DetailRow(
                  icon: Icons.trending_up,
                  label: 'نطاق السعر',
                  value:
                      '${post.rangeMin!.toStringAsFixed(0)} - ${post.rangeMax!.toStringAsFixed(0)} ₪',
                ),
                const SizedBox(height: AppSpacing.sm),
              ],

              if (post.durationText != null) ...[
                _DetailRow(
                  icon: Icons.schedule,
                  label: 'المدة',
                  value: post.durationText!,
                ),
                const SizedBox(height: AppSpacing.sm),
              ],

              if (post.salaryAmount != null) ...[
                _DetailRow(
                  icon: Icons.attach_money,
                  label: 'الراتب',
                  value: '${post.salaryAmount} شيكل',
                ),
                const SizedBox(height: AppSpacing.sm),
              ],

              _DetailRow(
                icon: Icons.access_time,
                label: 'نشر',
                value: DateFormatter.timeAgo(post.createdAt),
              ),
              const SizedBox(height: AppSpacing.xl),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _contactPoster(post.id, post.professionalId);
                  },
                  icon: const Icon(Icons.chat),
                  label: const Text('تواصل مع الناشر'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModernHiringCard extends StatelessWidget {
  final dynamic post;
  final VoidCallback onTap;
  final VoidCallback onContact;

  const _ModernHiringCard({
    required this.post,
    required this.onTap,
    required this.onContact,
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
            theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primaryContainer,
                      theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.3,
                            ),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.work,
                        color: theme.colorScheme.onPrimary,
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
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
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

                        if (post.durationText != null)
                          _InfoChip(
                            icon: Icons.schedule,
                            label: post.durationText!,
                            color: theme.colorScheme.outline,
                          ),

                        if (post.salaryAmount != null)
                          _InfoChip(
                            icon: Icons.attach_money,
                            label: '${post.salaryAmount} شيكل',
                            color: Colors.amber[700]!,
                          ),

                        _InfoChip(
                          icon: Icons.access_time,
                          label: DateFormatter.timeAgo(post.createdAt),
                          color: theme.colorScheme.outline,
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: onContact,
                        icon: const Icon(Icons.chat, size: 18),
                        label: const Text('تواصل الآن'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        const SizedBox(width: AppSpacing.sm),
        Text(
          '$label: ',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
  }
}
