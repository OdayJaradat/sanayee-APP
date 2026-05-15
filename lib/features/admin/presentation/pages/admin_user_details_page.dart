import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_spacing.dart';
import '../../admin_injection.dart';
import '../../domain/entities/admin_user_details.dart';
import '../cubit/admin_user_details_cubit.dart';
import '../widgets/admin_scaffold.dart';

/// Admin user details page
class AdminUserDetailsPage extends StatelessWidget {
  final String userId;

  const AdminUserDetailsPage({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminInjection.createUserDetailsCubit()..load(userId),
      child: _AdminUserDetailsView(userId: userId),
    );
  }
}

class _AdminUserDetailsView extends StatelessWidget {
  final String userId;

  const _AdminUserDetailsView({required this.userId});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'تفاصيل المستخدم',
      actions: [
        BlocBuilder<AdminUserDetailsCubit, AdminUserDetailsState>(
          builder: (context, state) {
            return IconButton(
              onPressed: state.isLoading
                  ? null
                  : () => context.read<AdminUserDetailsCubit>().refresh(userId),
              icon: state.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh_rounded),
              tooltip: 'تحديث',
            );
          },
        ),
      ],
      child: BlocBuilder<AdminUserDetailsCubit, AdminUserDetailsState>(
        builder: (context, state) {
          if (state.isLoading || state.isInitial) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state.hasError) {
            return _buildErrorView(context, state.errorMessage!);
          }

          final details = state.dataOrNull!;
          return _buildContent(context, details);
        },
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'حدث خطأ',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: () => context.read<AdminUserDetailsCubit>().refresh(userId),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AdminUserDetails details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Breadcrumb / Back button
        _buildBreadcrumb(context),
        const SizedBox(height: AppSpacing.lg),

        // Profile Card
        _buildProfileCard(context, details),
        const SizedBox(height: AppSpacing.lg),

        // Stats Cards
        _buildStatsCards(context, details),
      ],
    );
  }

  Widget _buildBreadcrumb(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        TextButton.icon(
          onPressed: () => context.go('/admin/users'),
          icon: const Icon(Icons.arrow_back_rounded, size: 18),
          label: const Text('العودة للمستخدمين'),
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(BuildContext context, AdminUserDetails details) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 48,
            backgroundColor: _getRoleColor(details.role).withValues(alpha: 0.2),
            backgroundImage: details.avatarUrl != null
                ? NetworkImage(details.avatarUrl!)
                : null,
            child: details.avatarUrl == null
                ? Text(
                    details.fullName.isNotEmpty ? details.fullName[0] : '?',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: _getRoleColor(details.role),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: AppSpacing.lg),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      details.fullName.isEmpty ? 'بدون اسم' : details.fullName,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _buildRoleBadge(details.role),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Details Grid
                Wrap(
                  spacing: AppSpacing.xl,
                  runSpacing: AppSpacing.md,
                  children: [
                    if (details.email != null)
                      _buildDetailItem(context, Icons.email_outlined, details.email!),
                    if (details.phone != null)
                      _buildDetailItem(context, Icons.phone_outlined, details.phone!),
                    if (details.city != null)
                      _buildDetailItem(context, Icons.location_city_outlined, details.city!),
                    if (details.governorate != null)
                      _buildDetailItem(context, Icons.map_outlined, details.governorate!),
                    if (details.specialization != null)
                      _buildDetailItem(context, Icons.work_outlined, details.specialization!),
                    if (details.yearsExperience > 0)
                      _buildDetailItem(
                        context,
                        Icons.history_outlined,
                        '${details.yearsExperience} سنة خبرة',
                      ),
                    _buildDetailItem(
                      context,
                      Icons.calendar_today_outlined,
                      'انضم في ${_formatDate(details.createdAt)}',
                    ),
                  ],
                ),

                if (details.bio != null && details.bio!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    details.bio!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 18,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleBadge(String role) {
    final color = _getRoleColor(role);
    final label = _getRoleLabel(role);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context, AdminUserDetails details) {
    if (details.isClient) {
      return Row(
        children: [
          _buildStatCard(
            context,
            icon: Icons.assignment_rounded,
            label: 'الطلبات المُنشأة',
            value: details.requestsCount.toString(),
            color: Colors.blue,
          ),
        ],
      );
    } else if (details.isProfessional) {
      return Row(
        children: [
          _buildStatCard(
            context,
            icon: Icons.check_circle_rounded,
            label: 'المهام المكتملة',
            value: details.completedJobsCount.toString(),
            color: Colors.green,
          ),
          const SizedBox(width: AppSpacing.md),
          _buildStatCard(
            context,
            icon: Icons.star_rounded,
            label: 'متوسط التقييم',
            value: details.formattedAvgRating,
            color: Colors.amber,
            subtitle: '${details.ratingsCount} تقييم',
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    String? subtitle,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: AppSpacing.lg),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return Colors.purple;
      case 'professional':
        return Colors.orange;
      case 'client':
      default:
        return Colors.green;
    }
  }

  String _getRoleLabel(String role) {
    switch (role) {
      case 'admin':
        return 'مسؤول';
      case 'professional':
        return 'صنايعي';
      case 'client':
      default:
        return 'عميل';
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    return '${date.day}/${date.month}/${date.year}';
  }
}
