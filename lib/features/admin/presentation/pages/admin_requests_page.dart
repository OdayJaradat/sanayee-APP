import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_spacing.dart';
import '../../admin_injection.dart';
import '../../domain/entities/admin_request_row.dart' as entities;
import '../cubit/admin_requests_cubit.dart';
import '../widgets/admin_scaffold.dart';

/// Admin requests management page with responsive layout
class AdminRequestsPage extends StatelessWidget {
  final String? initialProfessionalId;
  final String? initialClientId;
  final String? initialStatus;

  const AdminRequestsPage({
    super.key,
    this.initialProfessionalId,
    this.initialClientId,
    this.initialStatus,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = AdminInjection.createRequestsCubit();
        // Apply initial filters if provided
        if (initialProfessionalId != null) {
          cubit.filterByProfessionalId(initialProfessionalId);
        } else if (initialStatus != null) {
          cubit.filterByStatus(initialStatus);
        }
        cubit.load();
        return cubit;
      },
      child: _AdminRequestsView(
        initialProfessionalId: initialProfessionalId,
        initialStatus: initialStatus,
      ),
    );
  }
}

class _AdminRequestsView extends StatefulWidget {
  final String? initialProfessionalId;
  final String? initialStatus;

  const _AdminRequestsView({
    this.initialProfessionalId,
    this.initialStatus,
  });

  @override
  State<_AdminRequestsView> createState() => _AdminRequestsViewState();
}

class _AdminRequestsViewState extends State<_AdminRequestsView> {
  late String _selectedStatus;
  final _cityController = TextEditingController();
  DateTimeRange? _dateRange;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.initialStatus ?? 'all';
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'الطلبات',
      actions: [
        BlocBuilder<AdminRequestsCubit, AdminRequestsState>(
          builder: (context, state) {
            return IconButton(
              onPressed: state.isLoading
                  ? null
                  : () => context.read<AdminRequestsCubit>().refresh(),
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
      child: BlocBuilder<AdminRequestsCubit, AdminRequestsState>(
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

                    // Stats Row (compact, aligned right)
                    if (state.hasData) ...[
                      _buildStatsRow(context, state.pageOrNull!),
                      const SizedBox(height: AppSpacing.md),
                    ],

                    // Requests Table Card (takes remaining space)
                    Expanded(
                      child: _buildRequestsTableCard(context, state),
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
              onPressed: () => context.read<AdminRequestsCubit>().refresh(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersCard(BuildContext context, AdminRequestsState state) {
    final theme = Theme.of(context);
    final cubit = context.read<AdminRequestsCubit>();
    final hasFilters = _selectedStatus != 'all' ||
        _cityController.text.isNotEmpty ||
        _dateRange != null;

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
              width: 200,
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
                  DropdownMenuItem(value: 'assigned', child: Text('قيد التنفيذ')),
                  DropdownMenuItem(value: 'pending_review', child: Text('بانتظار المراجعة')),
                  DropdownMenuItem(value: 'completed', child: Text('مكتمل')),
                  DropdownMenuItem(value: 'closed', child: Text('مغلق')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedStatus = value);
                    cubit.filterByStatus(value == 'all' ? null : value);
                  }
                },
              ),
            ),

            // City Filter
            SizedBox(
              width: 220,
              child: TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: 'المدينة',
                  hintText: 'ابحث عن مدينة...',
                  prefixIcon: const Icon(Icons.location_city_rounded, size: 20),
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
                      cubit.filterByCity(
                        _cityController.text.isEmpty
                            ? null
                            : _cityController.text,
                      );
                    },
                    tooltip: 'بحث',
                  ),
                ),
                onSubmitted: (value) {
                  cubit.filterByCity(value.isEmpty ? null : value);
                },
              ),
            ),

            // Date Range Button
            SizedBox(
              width: 200,
              child: OutlinedButton.icon(
                onPressed: () => _selectDateRange(context),
                icon: const Icon(Icons.date_range_rounded, size: 18),
                label: Text(
                  _dateRange == null
                      ? 'الفترة الزمنية'
                      : '${_formatDate(_dateRange!.start)} - ${_formatDate(_dateRange!.end)}',
                  overflow: TextOverflow.ellipsis,
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: 14,
                  ),
                ),
              ),
            ),

            // Clear Filters
            if (hasFilters)
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedStatus = 'all';
                    _cityController.clear();
                    _dateRange = null;
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

  Future<void> _selectDateRange(BuildContext context) async {
    final cubit = context.read<AdminRequestsCubit>();

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
      locale: const Locale('ar'),
    );

    if (picked != null) {
      setState(() => _dateRange = picked);
      cubit.filterByDateRange(picked.start, picked.end);
    }
  }

  Widget _buildStatsRow(BuildContext context, entities.AdminRequestsPage page) {
    final theme = Theme.of(context);
    final cubit = context.read<AdminRequestsCubit>();

    return Row(
      children: [
        const Expanded(child: SizedBox()),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${page.totalCount}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'طلب',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Icon(
                  Icons.assignment_rounded,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.md),
                IconButton(
                  tooltip: 'تحديث',
                  onPressed: () => cubit.refresh(),
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRequestsTableCard(
      BuildContext context, AdminRequestsState state) {
    final theme = Theme.of(context);
    final cubit = context.read<AdminRequestsCubit>();
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
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.3),
            ),
            child: Row(
              children: [
                Icon(Icons.table_chart_rounded,
                    color: theme.colorScheme.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'قائمة الطلبات',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (page != null)
                  Text(
                    '${page.totalCount} طلب',
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

          // Pagination Footer
          if (page != null && page.totalCount > 0) ...[
            const Divider(height: 1),
            Container(
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
                    onPressed:
                        page.hasNextPage ? () => cubit.nextPage() : null,
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
    AdminRequestsState state,
    entities.AdminRequestsPage? page,
  ) {
    final theme = Theme.of(context);

    // Loading state
    if (state.isLoading) {
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
                'لا توجد طلبات حالياً',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'سيظهر هنا الطلبات المقدمة من العملاء',
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

    // Data table with horizontal scrolling only
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: SingleChildScrollView(
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.3),
                ),
                columnSpacing: AppSpacing.lg,
                horizontalMargin: AppSpacing.md,
                columns: const [
                  DataColumn(label: Text('رقم الطلب')),
                  DataColumn(label: Text('العنوان')),
                  DataColumn(label: Text('الحالة')),
                  DataColumn(label: Text('العميل')),
                  DataColumn(label: Text('الصنايعي')),
                  DataColumn(label: Text('المدينة')),
                  DataColumn(label: Text('التاريخ')),
                  DataColumn(label: Text('الإجراءات')),
                ],
                rows: page.rows
                    .map((request) => _buildRequestRow(context, request))
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  DataRow _buildRequestRow(
      BuildContext context, entities.AdminRequestRow request) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            request.shortId,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'monospace',
            ),
          ),
        ),
        DataCell(
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 150),
            child: Text(
              request.title.isEmpty ? '—' : request.title,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(_buildStatusBadge(request.status)),
        DataCell(Text(request.clientName ?? '—')),
        DataCell(Text(request.professionalName ?? '—')),
        DataCell(Text(request.city ?? '—')),
        DataCell(Text(_formatDate(request.createdAt))),
        DataCell(
          IconButton(
            icon: const Icon(Icons.visibility_rounded, size: 18),
            onPressed: () => context.go('/admin/requests/${request.id}'),
            tooltip: 'عرض التفاصيل',
            style: IconButton.styleFrom(foregroundColor: Colors.blue),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = _getStatusColor(status);
    final label = _getStatusLabel(status);

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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'open':
        return Colors.blue;
      case 'assigned':
        return Colors.purple;
      case 'pending_review':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'open':
        return 'مفتوح';
      case 'assigned':
        return 'قيد التنفيذ';
      case 'pending_review':
        return 'بانتظار المراجعة';
      case 'completed':
        return 'مكتمل';
      case 'closed':
        return 'مغلق';
      default:
        return status;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    return '${date.day}/${date.month}/${date.year}';
  }
}
