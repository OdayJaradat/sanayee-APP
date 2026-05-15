import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_spacing.dart';
import '../../admin_injection.dart';
import '../../domain/entities/admin_report.dart' as entities;
import '../cubit/admin_reports_cubit.dart';
import '../widgets/admin_scaffold.dart';

/// Admin reports management page with responsive layout
class AdminReportsPage extends StatelessWidget {
  final String? initialTargetType;
  final String? initialTargetId;
  final String? initialStatus;

  const AdminReportsPage({
    super.key,
    this.initialTargetType,
    this.initialTargetId,
    this.initialStatus,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = AdminInjection.createReportsCubit();
        // Apply initial filters if provided
        if (initialTargetType != null || initialTargetId != null || initialStatus != null) {
          cubit.setInitialFilters(
            targetType: initialTargetType,
            targetId: initialTargetId,
            status: initialStatus,
          );
        }
        cubit.load();
        return cubit;
      },
      child: _AdminReportsView(
        initialTargetType: initialTargetType,
        initialTargetId: initialTargetId,
        initialStatus: initialStatus,
      ),
    );
  }
}

class _AdminReportsView extends StatefulWidget {
  final String? initialTargetType;
  final String? initialTargetId;
  final String? initialStatus;

  const _AdminReportsView({
    this.initialTargetType,
    this.initialTargetId,
    this.initialStatus,
  });

  @override
  State<_AdminReportsView> createState() => _AdminReportsViewState();
}

class _AdminReportsViewState extends State<_AdminReportsView> {
  late String _selectedStatus;
  late String _selectedTargetType;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.initialStatus ?? 'all';
    _selectedTargetType = widget.initialTargetType ?? 'all';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'البلاغات',
      actions: [
        BlocBuilder<AdminReportsCubit, AdminReportsState>(
          builder: (context, state) {
            return IconButton(
              onPressed: state.isLoading
                  ? null
                  : () => context.read<AdminReportsCubit>().refresh(),
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
      child: BlocBuilder<AdminReportsCubit, AdminReportsState>(
        builder: (context, state) {
          if (state.isLoading && state.isInitial) {
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

          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Filters Card
                    _buildFiltersCard(context, state),
                    const SizedBox(height: AppSpacing.md),

                    // Stats Row
                    if (state.hasData) ...[
                      _buildStatsRow(context, state.pageOrNull!),
                      const SizedBox(height: AppSpacing.md),
                    ],

                    // Reports Table Card
                    Expanded(
                      child: _buildReportsTableCard(context, state),
                    ),
                  ],
                ),
              ),
            ),
          );
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
              onPressed: () => context.read<AdminReportsCubit>().refresh(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersCard(BuildContext context, AdminReportsState state) {
    final theme = Theme.of(context);
    final cubit = context.read<AdminReportsCubit>();
    final hasFilters = _selectedStatus != 'all' ||
        _selectedTargetType != 'all' ||
        _searchController.text.isNotEmpty;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // Status Filter
            SizedBox(
              width: 180,
              child: DropdownButtonFormField<String>(
                initialValue: _selectedStatus,
                decoration: InputDecoration(
                  labelText: 'الحالة',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  isDense: true,
                ),
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('الكل')),
                  DropdownMenuItem(value: 'open', child: Text('مفتوح')),
                  DropdownMenuItem(value: 'resolved', child: Text('تم الحل')),
                  DropdownMenuItem(value: 'dismissed', child: Text('مرفوض')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedStatus = value);
                    cubit.filterByStatus(value == 'all' ? null : value);
                  }
                },
              ),
            ),

            // Target Type Filter
            SizedBox(
              width: 180,
              child: DropdownButtonFormField<String>(
                initialValue: _selectedTargetType,
                decoration: InputDecoration(
                  labelText: 'النوع',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  isDense: true,
                ),
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('الكل')),
                  DropdownMenuItem(value: 'request', child: Text('طلب')),
                  DropdownMenuItem(value: 'professional', child: Text('صنايعي')),
                  DropdownMenuItem(value: 'client', child: Text('عميل')),
                  DropdownMenuItem(value: 'offer', child: Text('عرض')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedTargetType = value);
                    cubit.filterByTargetType(value == 'all' ? null : value);
                  }
                },
              ),
            ),

            // Search Field (UUID only)
            SizedBox(
              width: 320,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'بحث برقم الهدف (UUID)',
                  hintText: 'أدخل UUID كامل للبحث...',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  isDense: true,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search, size: 20),
                    onPressed: () {
                      cubit.search(
                        _searchController.text.isEmpty
                            ? null
                            : _searchController.text.trim(),
                      );
                    },
                    tooltip: 'بحث',
                  ),
                ),
                onSubmitted: (value) {
                  cubit.search(value.isEmpty ? null : value.trim());
                },
              ),
            ),

            // Clear Filters Button
            if (hasFilters)
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedStatus = 'all';
                    _selectedTargetType = 'all';
                    _searchController.clear();
                  });
                  cubit.clearFilters();
                },
                icon: const Icon(Icons.clear_rounded, size: 18),
                label: const Text('مسح الفلاتر'),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, entities.AdminReportsPage page) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: const Icon(Icons.flag_rounded, color: Colors.red, size: 24),
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  page.totalCount.toString(),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'إجمالي البلاغات',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsTableCard(BuildContext context, AdminReportsState state) {
    final theme = Theme.of(context);
    final cubit = context.read<AdminReportsCubit>();
    final page = state.pageOrNull;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            ),
            child: Row(
              children: [
                Icon(Icons.table_chart_rounded, color: theme.colorScheme.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'قائمة البلاغات',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (page != null)
                  Text(
                    '${page.totalCount} بلاغ',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Table Content
          Expanded(
            child: _buildTableContent(context, state, page),
          ),

          // Pagination
          if (page != null && page.totalCount > 0) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: page.hasPreviousPage
                        ? () => cubit.previousPage()
                        : null,
                    icon: const Icon(Icons.chevron_left_rounded),
                    tooltip: 'السابق',
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    'صفحة ${page.pageIndex + 1} من ${page.totalPages == 0 ? 1 : page.totalPages}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  IconButton(
                    onPressed: page.hasNextPage ? () => cubit.nextPage() : null,
                    icon: const Icon(Icons.chevron_right_rounded),
                    tooltip: 'التالي',
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTableContent(
    BuildContext context,
    AdminReportsState state,
    entities.AdminReportsPage? page,
  ) {
    final theme = Theme.of(context);

    // Loading state
    if (state.isLoading && page == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Empty state
    if (page == null || page.rows.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inbox_rounded,
                size: 64,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'لا توجد بلاغات حالياً',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'سيظهر هنا أي بلاغ يتم تقديمه من المستخدمين',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Data table with horizontal scrolling
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              ),
              columnSpacing: AppSpacing.lg,
              horizontalMargin: AppSpacing.md,
              columns: const [
                DataColumn(label: Text('الحالة')),
                DataColumn(label: Text('النوع')),
                DataColumn(label: Text('رقم الهدف')),
                DataColumn(label: Text('المُبلِّغ')),
                DataColumn(label: Text('السبب')),
                DataColumn(label: Text('التاريخ')),
                DataColumn(label: Text('الإجراءات')),
              ],
              rows: page.rows.map((r) => _buildReportRow(context, r)).toList(),
            ),
          ),
        );
      },
    );
  }

  DataRow _buildReportRow(BuildContext context, entities.AdminReport report) {
    return DataRow(
      cells: [
        // الحالة (Status)
        DataCell(_buildStatusBadge(report.status)),
        // النوع (Target Type)
        DataCell(_buildTargetTypeBadge(report.targetType)),
        // رقم الهدف (Target ID - short)
        DataCell(
          Text(
            report.shortTargetId,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
        // المُبلِّغ (Reporter Name)
        DataCell(
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 150),
            child: Text(
              report.creatorName ?? '—',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        // السبب (Reason)
        DataCell(
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: Text(
              report.reason,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        // التاريخ (Date)
        DataCell(Text(_formatDate(report.createdAt))),
        // الإجراءات (Actions)
        DataCell(
          IconButton(
            icon: const Icon(Icons.visibility_rounded, size: 18),
            onPressed: () => context.go('/admin/reports/${report.id}'),
            tooltip: 'عرض التفاصيل',
            style: IconButton.styleFrom(foregroundColor: Colors.blue),
          ),
        ),
      ],
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTargetTypeBadge(String targetType) {
    Color color;
    String label;

    switch (targetType) {
      case 'request':
        color = Colors.blue;
        label = 'طلب';
        break;
      case 'professional':
        color = Colors.purple;
        label = 'صنايعي';
        break;
      case 'client':
        color = Colors.teal;
        label = 'عميل';
        break;
      case 'offer':
        color = Colors.indigo;
        label = 'عرض';
        break;
      default:
        color = Colors.grey;
        label = targetType;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    return '${date.day}/${date.month}/${date.year}';
  }
}
