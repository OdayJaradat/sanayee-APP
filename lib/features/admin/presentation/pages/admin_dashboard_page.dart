import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/config/app_spacing.dart';
import '../../admin_injection.dart';
import '../../domain/entities/admin_dashboard_stats.dart';
import '../../domain/entities/admin_report.dart';
import '../cubit/admin_dashboard_cubit.dart';
import '../widgets/admin_scaffold.dart';

/// Admin dashboard page with KPI cards
class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminInjection.createDashboardCubit()..load(),
      child: const _AdminDashboardView(),
    );
  }
}

class _AdminDashboardView extends StatelessWidget {
  const _AdminDashboardView();

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'لوحة التحكم',
      actions: [
        BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
          builder: (context, state) {
            return IconButton(
              onPressed: state.isLoading
                  ? null
                  : () => context.read<AdminDashboardCubit>().refresh(),
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
      child: BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
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

          final stats = state.dataOrNull!;
          return _buildDashboardContent(context, stats);
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
              onPressed: () => context.read<AdminDashboardCubit>().refresh(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent(
    BuildContext context,
    AdminDashboardStats stats,
  ) {
    final state = context.read<AdminDashboardCubit>().state;
    final recentActivity = state.recentActivityOrEmpty;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          _buildWelcomeSection(context),
          const SizedBox(height: AppSpacing.xl),

          // KPI Cards
          _buildKpiCards(context, stats),
          const SizedBox(height: AppSpacing.xl),

          // Quick Actions & Recent Activity
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _buildRecentActivityCard(context, recentActivity),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(child: _buildQuickActionsCard(context)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryPurple,
            AppColors.primaryPurple.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحباً بك في لوحة الإدارة 👋',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'إدارة المستخدمين والطلبات والصنايعية من مكان واحد',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: const Icon(
              Icons.analytics_rounded,
              color: Colors.white,
              size: 48,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCards(BuildContext context, AdminDashboardStats stats) {
    final kpis = [
      _KpiData(
        title: 'إجمالي المستخدمين',
        value: stats.totalUsers.toString(),
        icon: Icons.people_rounded,
        color: Colors.blue,
      ),
      _KpiData(
        title: 'العملاء',
        value: stats.totalClients.toString(),
        icon: Icons.person_rounded,
        color: Colors.green,
      ),
      _KpiData(
        title: 'الصنايعية',
        value: stats.totalProfessionals.toString(),
        icon: Icons.engineering_rounded,
        color: Colors.orange,
      ),
      _KpiData(
        title: 'الطلبات المفتوحة',
        value: stats.openRequests.toString(),
        icon: Icons.pending_actions_rounded,
        color: Colors.purple,
      ),
      _KpiData(
        title: 'الطلبات المكتملة',
        value: stats.completedRequests.toString(),
        icon: Icons.check_circle_rounded,
        color: Colors.teal,
      ),
      _KpiData(
        title: 'البلاغات المفتوحة',
        value: stats.openReports.toString(),
        icon: Icons.flag_rounded,
        color: Colors.red,
      ),
      
    ];

    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: kpis.map((kpi) => _buildKpiCard(context, kpi)).toList(),
    );
  }

  Widget _buildKpiCard(BuildContext context, _KpiData kpi) {
    final theme = Theme.of(context);

    return Container(
      width: 220,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: theme.colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: kpi.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(kpi.icon, color: kpi.color, size: 24),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            kpi.value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            kpi.title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityCard(
    BuildContext context,
    List<AdminReport> recentActivity,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history_rounded, color: theme.colorScheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'النشاط الأخير',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (recentActivity.isNotEmpty)
                TextButton(
                  onPressed: () => context.go('/admin/reports'),
                  child: const Text('عرض الكل'),
                ),
            ],
          ),
          const Divider(height: AppSpacing.xl),

          if (recentActivity.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  children: [
                    Icon(
                      Icons.inbox_rounded,
                      size: 48,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'لا توجد بلاغات حديثة',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...recentActivity.map(
              (report) => _buildActivityItem(context, report),
            ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, AdminReport report) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.go('/admin/reports/${report.id}'),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              // Icon based on target type
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: _getTargetTypeColor(
                    report.targetType,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(
                  _getTargetTypeIcon(report.targetType),
                  size: 18,
                  color: _getTargetTypeColor(report.targetType),
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'بلاغ على ${report.targetTypeLabel}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      report.reason,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),

              // Status badge
              _buildStatusBadge(report.status),
              const SizedBox(width: AppSpacing.sm),

              // Time
              Text(
                _formatRelativeTime(report.createdAt),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'resolved':
        color = Colors.green;
        break;
      case 'dismissed':
        color = Colors.grey;
        break;
      case 'open':
      default:
        color = Colors.orange;
    }

    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  IconData _getTargetTypeIcon(String targetType) {
    switch (targetType) {
      case 'request':
        return Icons.assignment_rounded;
      case 'professional':
        return Icons.engineering_rounded;
      case 'client':
        return Icons.person_rounded;
      case 'offer':
        return Icons.local_offer_rounded;
      default:
        return Icons.flag_rounded;
    }
  }

  Color _getTargetTypeColor(String targetType) {
    switch (targetType) {
      case 'request':
        return Colors.blue;
      case 'professional':
        return Colors.orange;
      case 'client':
        return Colors.green;
      case 'offer':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _formatRelativeTime(DateTime? dateTime) {
    if (dateTime == null) return '';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inHours < 1) {
      return 'منذ ${difference.inMinutes} د';
    } else if (difference.inDays < 1) {
      return 'منذ ${difference.inHours} س';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} يوم';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }

  Widget _buildQuickActionsCard(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bolt_rounded, color: theme.colorScheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'إجراءات سريعة',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: AppSpacing.xl),

          _buildQuickAction(
            context,
            icon: Icons.people_rounded,
            label: 'عرض المستخدمين',
            route: '/admin/users',
          ),
          _buildQuickAction(
            context,
            icon: Icons.assignment_rounded,
            label: 'عرض الطلبات',
            route: '/admin/requests',
          ),
          _buildQuickAction(
            context,
            icon: Icons.bar_chart_rounded,
            label: 'عرض البلاغات',
            route: '/admin/reports',
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: InkWell(
          onTap: () => context.go(route),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Icon(icon, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _KpiData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiData({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}
