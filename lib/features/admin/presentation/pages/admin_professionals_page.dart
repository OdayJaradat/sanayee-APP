import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_spacing.dart';
import '../../admin_injection.dart';
import '../../domain/entities/admin_professional_row.dart' as entities;
import '../cubit/admin_professionals_cubit.dart';
import '../widgets/admin_scaffold.dart';

/// Admin professionals management page
class AdminProfessionalsPage extends StatelessWidget {
  const AdminProfessionalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminInjection.createProfessionalsCubit()..load(),
      child: const _AdminProfessionalsView(),
    );
  }
}

class _AdminProfessionalsView extends StatefulWidget {
  const _AdminProfessionalsView();

  @override
  State<_AdminProfessionalsView> createState() =>
      _AdminProfessionalsViewState();
}

class _AdminProfessionalsViewState extends State<_AdminProfessionalsView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'إدارة الصنايعية',
      actions: [
        BlocBuilder<AdminProfessionalsCubit, AdminProfessionalsState>(
          builder: (context, state) {
            return IconButton(
              onPressed: state.isLoading
                  ? null
                  : () => context.read<AdminProfessionalsCubit>().refresh(),
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
      child: BlocBuilder<AdminProfessionalsCubit, AdminProfessionalsState>(
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

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Row
              _buildSearchRow(context, state),
              const SizedBox(height: AppSpacing.lg),

              // Stats Cards
              if (state.hasData) _buildStatsRow(context, state.pageOrNull!),
              const SizedBox(height: AppSpacing.lg),

              // Professionals Table
              if (state.hasData)
                Expanded(
                    child: _buildProfessionalsTable(context, state.pageOrNull!))
              else if (state.isLoading)
                const Expanded(child: Center(child: CircularProgressIndicator())),
            ],
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
              onPressed: () =>
                  context.read<AdminProfessionalsCubit>().refresh(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchRow(
      BuildContext context, AdminProfessionalsState state) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          // Search Field
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'البحث عن صنايعي (الاسم أو الهاتف)...',
                prefixIcon: const Icon(Icons.search_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                isDense: true,
              ),
              onSubmitted: (value) {
                context.read<AdminProfessionalsCubit>().search(value);
              },
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Search Button
          IconButton(
            onPressed: () {
              context
                  .read<AdminProfessionalsCubit>()
                  .search(_searchController.text);
            },
            icon: const Icon(Icons.search),
            tooltip: 'بحث',
          ),

          // Clear Filters
          if (_searchController.text.isNotEmpty) ...[
            const SizedBox(width: AppSpacing.md),
            TextButton.icon(
              onPressed: () {
                _searchController.clear();
                context.read<AdminProfessionalsCubit>().search('');
              },
              icon: const Icon(Icons.clear_rounded, size: 18),
              label: const Text('مسح'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsRow(
      BuildContext context, entities.AdminProfessionalsPage page) {
    return Row(
      children: [
        _buildStatCard(
          context,
          label: 'إجمالي الصنايعية',
          value: page.totalCount.toString(),
          icon: Icons.engineering_rounded,
          color: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalsTable(
      BuildContext context, entities.AdminProfessionalsPage page) {
    final theme = Theme.of(context);
    final cubit = context.read<AdminProfessionalsCubit>();

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Icon(
                  Icons.table_chart_rounded,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'قائمة الصنايعية',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${page.totalCount} صنايعي',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // DataTable
          if (page.rows.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Center(
                child: Text(
                  'لا يوجد صنايعية',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(
                    theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.5),
                  ),
                  columns: const [
                    DataColumn(label: Text('الاسم')),
                    DataColumn(label: Text('الهاتف')),
                    DataColumn(label: Text('المدينة')),
                    DataColumn(label: Text('التقييم')),
                    DataColumn(label: Text('الأعمال المنجزة')),
                    DataColumn(label: Text('تاريخ التسجيل')),
                    DataColumn(label: Text('الإجراءات')),
                  ],
                  rows: page.rows
                      .map((pro) => _buildProfessionalRow(context, pro))
                      .toList(),
                ),
              ),
            ),

          // Pagination
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed:
                      page.hasPreviousPage ? () => cubit.previousPage() : null,
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
      ),
    );
  }

  DataRow _buildProfessionalRow(
      BuildContext context, entities.AdminProfessionalRow pro) {
    final theme = Theme.of(context);
    
    return DataRow(
      color: pro.isBlocked 
          ? WidgetStateProperty.all(Colors.red.withValues(alpha: 0.05))
          : null,
      cells: [
        DataCell(
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: pro.isBlocked 
                        ? Colors.red.withValues(alpha: 0.2)
                        : Colors.orange.withValues(alpha: 0.2),
                    child: Text(
                      pro.fullName.isNotEmpty ? pro.fullName[0] : '?',
                      style: TextStyle(
                        color: pro.isBlocked ? Colors.red : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (pro.isBlocked)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: theme.colorScheme.surface, width: 1.5),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(pro.fullName.isEmpty ? '—' : pro.fullName),
                  if (pro.isBlocked)
                    Text(
                      'محظور',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        DataCell(Text(pro.phone ?? '—')),
        DataCell(Text(pro.city ?? '—')),
        DataCell(_buildRatingBadge(pro.avgRating)),
        DataCell(
          Text(
            pro.completedJobs.toString(),
            style: TextStyle(
              fontWeight:
                  pro.completedJobs > 0 ? FontWeight.w600 : FontWeight.normal,
              color: pro.completedJobs > 0 ? Colors.green : null,
            ),
          ),
        ),
        DataCell(Text(_formatDate(pro.createdAt))),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // View Profile
              IconButton(
                icon: const Icon(Icons.visibility_rounded, size: 18),
                onPressed: () => context.go('/admin/users/${pro.id}'),
                tooltip: 'عرض الملف',
                style: IconButton.styleFrom(foregroundColor: Colors.blue),
              ),
              // View Reports
              IconButton(
                icon: const Icon(Icons.flag_rounded, size: 18),
                onPressed: () => context.go(
                  '/admin/reports?targetType=professional&targetId=${pro.id}',
                ),
                tooltip: 'عرض البلاغات',
                style: IconButton.styleFrom(foregroundColor: Colors.orange),
              ),
              // View Requests
              IconButton(
                icon: const Icon(Icons.assignment_rounded, size: 18),
                onPressed: () => context.go(
                  '/admin/requests?professionalId=${pro.id}',
                ),
                tooltip: 'عرض الطلبات',
                style: IconButton.styleFrom(foregroundColor: Colors.purple),
              ),
              // Block/Unblock
              IconButton(
                icon: Icon(
                  pro.isBlocked ? Icons.lock_open_rounded : Icons.block_rounded,
                  size: 18,
                ),
                onPressed: () => _showBlockConfirmDialog(context, pro),
                tooltip: pro.isBlocked ? 'إلغاء الحظر' : 'حظر',
                style: IconButton.styleFrom(
                  foregroundColor: pro.isBlocked ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showBlockConfirmDialog(BuildContext context, entities.AdminProfessionalRow pro) {
    final isBlocked = pro.isBlocked;
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(isBlocked ? 'إلغاء حظر الصنايعي' : 'حظر الصنايعي'),
        content: Text(
          isBlocked
              ? 'هل أنت متأكد من إلغاء حظر "${pro.fullName}"؟\nسيتمكن من استخدام التطبيق مجدداً.'
              : 'هل أنت متأكد من حظر "${pro.fullName}"؟\nلن يتمكن من استخدام التطبيق.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AdminProfessionalsCubit>().toggleBlocked(pro.id, pro.isBlocked);
            },
            style: FilledButton.styleFrom(
              backgroundColor: isBlocked ? Colors.green : Colors.red,
            ),
            child: Text(isBlocked ? 'إلغاء الحظر' : 'حظر'),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBadge(double? rating) {
    if (rating == null) {
      return Text(
        '—',
        style: TextStyle(
          color: Colors.grey.shade500,
        ),
      );
    }

    final color = rating >= 4.0
        ? Colors.green
        : rating >= 3.0
            ? Colors.orange
            : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    return '${date.day}/${date.month}/${date.year}';
  }
}
