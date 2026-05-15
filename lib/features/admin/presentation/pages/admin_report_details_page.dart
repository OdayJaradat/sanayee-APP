import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/config/app_spacing.dart';
import '../../admin_injection.dart';
import '../../domain/entities/admin_report.dart';
import '../cubit/admin_report_details_cubit.dart';
import '../widgets/admin_scaffold.dart';

/// Admin report details page with status update capability
class AdminReportDetailsPage extends StatelessWidget {
  final String reportId;

  const AdminReportDetailsPage({
    super.key,
    required this.reportId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminInjection.createReportDetailsCubit()..load(reportId),
      child: _AdminReportDetailsView(reportId: reportId),
    );
  }
}

class _AdminReportDetailsView extends StatefulWidget {
  final String reportId;

  const _AdminReportDetailsView({required this.reportId});

  @override
  State<_AdminReportDetailsView> createState() =>
      _AdminReportDetailsViewState();
}

class _AdminReportDetailsViewState extends State<_AdminReportDetailsView> {
  final _adminNotesController = TextEditingController();
  String? _selectedStatus;

  @override
  void dispose() {
    _adminNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'تفاصيل البلاغ',
      actions: [
        BlocBuilder<AdminReportDetailsCubit, AdminReportDetailsState>(
          builder: (context, state) {
            return IconButton(
              onPressed: state.isLoading
                  ? null
                  : () => context
                      .read<AdminReportDetailsCubit>()
                      .refresh(widget.reportId),
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
      child: BlocConsumer<AdminReportDetailsCubit, AdminReportDetailsState>(
        listener: (context, state) {
          if (state.hasData) {
            final report = state.dataOrNull!;
            _selectedStatus ??= report.status;
            _adminNotesController.text = report.adminNotes ?? '';
          }
        },
        builder: (context, state) {
          if (state.isLoading || state.isInitial) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state.isUpdating) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: AppSpacing.md),
                  Text('جاري التحديث...'),
                ],
              ),
            );
          }

          if (state.hasError) {
            return _buildErrorView(context, state.errorMessage!);
          }

          final report = state.dataOrNull!;
          return _buildContent(context, report);
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
              onPressed: () => context
                  .read<AdminReportDetailsCubit>()
                  .refresh(widget.reportId),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AdminReport report) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Breadcrumb
        _buildBreadcrumb(context),
        const SizedBox(height: AppSpacing.lg),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Report Details
            Expanded(
              flex: 2,
              child: _buildReportCard(context, report),
            ),
            const SizedBox(width: AppSpacing.lg),

            // Right: Admin Actions
            Expanded(
              child: _buildAdminActionsCard(context, report),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBreadcrumb(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        TextButton.icon(
          onPressed: () => context.go('/admin/reports'),
          icon: const Icon(Icons.arrow_back_rounded, size: 18),
          label: const Text('العودة للبلاغات'),
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildReportCard(BuildContext context, AdminReport report) {
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
          // Header
          Row(
            children: [
              Icon(Icons.flag_rounded, color: theme.colorScheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'تفاصيل البلاغ',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              _buildStatusBadge(report.status),
            ],
          ),
          const Divider(height: AppSpacing.xl),

          // Details
          _buildDetailRow(context, 'رقم البلاغ', report.shortId),
          _buildDetailRow(context, 'النوع', report.targetTypeLabel),
          _buildDetailRow(context, 'رقم الهدف', report.shortTargetId),
          _buildDetailRow(context, 'المُبلِّغ', report.creatorName ?? '—'),
          _buildDetailRow(
              context, 'تاريخ الإنشاء', _formatDateTime(report.createdAt)),
          const SizedBox(height: AppSpacing.lg),

          // Reason
          Text(
            'السبب',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Text(
              report.reason.isEmpty ? 'لا يوجد سبب' : report.reason,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Details
          if (report.details != null && report.details!.isNotEmpty) ...[
            Text(
              'التفاصيل',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Text(
                report.details!,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],

          // View related target button
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton.icon(
            onPressed: () => _navigateToTarget(context, report),
            icon: const Icon(Icons.open_in_new_rounded, size: 18),
            label: Text('عرض ${report.targetTypeLabel} المُبلَّغ عنه'),
          ),
        ],
      ),
    );
  }

  void _navigateToTarget(BuildContext context, AdminReport report) {
    switch (report.targetType) {
      case 'request':
        context.go('/admin/requests/${report.targetId}');
        break;
      case 'professional':
      case 'client':
        context.go('/admin/users/${report.targetId}');
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('غير قادر على عرض هذا الهدف')),
        );
    }
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Text(
            '$label:',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminActionsCard(BuildContext context, AdminReport report) {
    final theme = Theme.of(context);
    final cubit = context.read<AdminReportDetailsCubit>();

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
              Icon(Icons.admin_panel_settings_rounded,
                  color: theme.colorScheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'إجراءات المسؤول',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: AppSpacing.xl),

          // Status Dropdown
          Text(
            'تحديث الحالة',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              isDense: true,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedStatus ?? report.status,
                isDense: true,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'open', child: Text('مفتوح')),
                  DropdownMenuItem(value: 'resolved', child: Text('تم الحل')),
                  DropdownMenuItem(value: 'dismissed', child: Text('مرفوض')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedStatus = value);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Admin Notes
          Text(
            'ملاحظات المسؤول',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _adminNotesController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'أضف ملاحظاتك هنا...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              contentPadding: const EdgeInsets.all(AppSpacing.md),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                cubit.updateStatus(
                  reportId: widget.reportId,
                  status: _selectedStatus ?? report.status,
                  adminNotes: _adminNotesController.text.isEmpty
                      ? null
                      : _adminNotesController.text,
                );
              },
              icon: const Icon(Icons.save_rounded),
              label: const Text('حفظ التغييرات'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;

    switch (status) {
      case 'resolved':
        color = Colors.green;
        label = 'تم الحل';
        break;
      case 'dismissed':
        color = Colors.grey;
        label = 'مرفوض';
        break;
      case 'open':
      default:
        color = Colors.orange;
        label = 'مفتوح';
    }

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

  String _formatDateTime(DateTime? date) {
    if (date == null) return '—';
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
