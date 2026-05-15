import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_spacing.dart';
import '../../admin_injection.dart';
import '../../domain/entities/admin_user_row.dart' as entities;
import '../cubit/admin_users_cubit.dart';
import '../widgets/admin_scaffold.dart';

/// Admin users management page with DataTable
class AdminUsersPage extends StatelessWidget {
  const AdminUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminInjection.createUsersCubit()..load(),
      child: const _AdminUsersView(),
    );
  }
}

class _AdminUsersView extends StatefulWidget {
  const _AdminUsersView();

  @override
  State<_AdminUsersView> createState() => _AdminUsersViewState();
}

class _AdminUsersViewState extends State<_AdminUsersView> {
  final _searchController = TextEditingController();
  String _selectedRole = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'إدارة المستخدمين',
      actions: [
        BlocBuilder<AdminUsersCubit, AdminUsersState>(
          builder: (context, state) {
            return IconButton(
              onPressed: state.isLoading
                  ? null
                  : () => context.read<AdminUsersCubit>().refresh(),
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
      child: BlocBuilder<AdminUsersCubit, AdminUsersState>(
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
              // Filters Row
              _buildFiltersRow(context, state),
              const SizedBox(height: AppSpacing.lg),

              // Stats Cards
              if (state.hasData) _buildStatsRow(context, state.pageOrNull!),
              const SizedBox(height: AppSpacing.lg),

              // Users Table
              if (state.hasData)
                Expanded(child: _buildUsersTable(context, state.pageOrNull!))
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
              onPressed: () => context.read<AdminUsersCubit>().refresh(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersRow(BuildContext context, AdminUsersState state) {
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
                hintText: 'البحث عن مستخدم (الاسم أو الهاتف)...',
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
                context.read<AdminUsersCubit>().search(value);
              },
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Search Button
          IconButton(
            onPressed: () {
              context.read<AdminUsersCubit>().search(_searchController.text);
            },
            icon: const Icon(Icons.search),
            tooltip: 'بحث',
          ),
          const SizedBox(width: AppSpacing.md),

          // Role Filter
          Expanded(
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'الدور',
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
                  value: _selectedRole,
                  isDense: true,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('الكل')),
                    DropdownMenuItem(value: 'client', child: Text('عميل')),
                    DropdownMenuItem(value: 'professional', child: Text('صنايعي')),
                    DropdownMenuItem(value: 'admin', child: Text('مسؤول')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedRole = value);
                      context.read<AdminUsersCubit>().filterByRole(value);
                    }
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Clear Filters
          if (_searchController.text.isNotEmpty || _selectedRole != 'all')
            TextButton.icon(
              onPressed: () {
                _searchController.clear();
                setState(() => _selectedRole = 'all');
                context.read<AdminUsersCubit>().search('');
                context.read<AdminUsersCubit>().filterByRole('all');
              },
              icon: const Icon(Icons.clear_rounded, size: 18),
              label: const Text('مسح'),
            ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, entities.AdminUsersPage page) {
    return Row(
      children: [
        _buildStatCard(
          context,
          label: 'إجمالي المستخدمين',
          value: page.totalCount.toString(),
          icon: Icons.people_rounded,
          color: Colors.blue,
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

  Widget _buildUsersTable(BuildContext context, entities.AdminUsersPage page) {
    final theme = Theme.of(context);
    final cubit = context.read<AdminUsersCubit>();

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
                  'قائمة المستخدمين',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${page.totalCount} مستخدم',
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
            Expanded(
              child: Center(
                child: Text(
                  'لا يوجد مستخدمين',
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
                    theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.5,
                    ),
                  ),
                  columns: const [
                    DataColumn(label: Text('الاسم')),
                    DataColumn(label: Text('البريد الإلكتروني')),
                    DataColumn(label: Text('الهاتف')),
                    DataColumn(label: Text('الدور')),
                    DataColumn(label: Text('المدينة')),
                    DataColumn(label: Text('تاريخ الإنشاء')),
                    DataColumn(label: Text('الحظر')),
                    DataColumn(label: Text('الإجراءات')),
                  ],
                  rows: page.rows
                      .map((user) => _buildUserRow(context, user))
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
      ),
    );
  }

  DataRow _buildUserRow(BuildContext context, entities.AdminUserRow user) {
    return DataRow(
      color: user.isBlocked
          ? WidgetStateProperty.all(Colors.red.withValues(alpha: 0.05))
          : null,
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: _getRoleColor(
                  user.role,
                ).withValues(alpha: 0.2),
                child: Text(
                  user.fullName.isNotEmpty ? user.fullName[0] : '?',
                  style: TextStyle(
                    color: _getRoleColor(user.role),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(user.fullName.isEmpty ? '—' : user.fullName),
              if (user.isBlocked) ...[
                const SizedBox(width: AppSpacing.xs),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
        DataCell(Text(user.email ?? '—')),
        DataCell(Text(user.phone ?? '—')),
        DataCell(_buildRoleBadge(user.role)),
        DataCell(Text(user.city ?? '—')),
        DataCell(Text(_formatDate(user.createdAt))),
        DataCell(_buildBlockButton(context, user)),
        DataCell(
          IconButton(
            icon: const Icon(Icons.visibility_rounded, size: 18),
            onPressed: () => context.go('/admin/users/${user.id}'),
            tooltip: 'عرض التفاصيل',
            style: IconButton.styleFrom(foregroundColor: Colors.blue),
          ),
        ),
      ],
    );
  }

  Widget _buildBlockButton(BuildContext context, entities.AdminUserRow user) {
    final isBlocked = user.isBlocked;

    return TextButton.icon(
      onPressed: () => _showBlockConfirmDialog(context, user),
      icon: Icon(
        isBlocked ? Icons.lock_open_rounded : Icons.block_rounded,
        size: 16,
      ),
      label: Text(isBlocked ? 'إلغاء الحظر' : 'حظر'),
      style: TextButton.styleFrom(
        foregroundColor: isBlocked ? Colors.green : Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
    );
  }

  void _showBlockConfirmDialog(
    BuildContext context,
    entities.AdminUserRow user,
  ) {
    final isBlocked = user.isBlocked;
    final action = isBlocked ? 'إلغاء حظر' : 'حظر';
    final roleLabel = _getRoleLabel(user.role);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('$action المستخدم'),
        content: Text(
          'هل أنت متأكد من $action ${user.fullName.isNotEmpty ? user.fullName : 'هذا المستخدم'} ($roleLabel)؟'
          '${!isBlocked ? '\n\nلن يتمكن المستخدم من الوصول إلى التطبيق بعد الحظر.' : ''}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final cubit = context.read<AdminUsersCubit>();
              final success = await cubit.toggleBlocked(user.id, isBlocked);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'تم ${isBlocked ? 'إلغاء حظر' : 'حظر'} المستخدم بنجاح'
                          : 'فشل في تحديث حالة الحظر',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: isBlocked ? Colors.green : Colors.red,
            ),
            child: Text(action),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleBadge(String role) {
    final color = _getRoleColor(role);
    final label = _getRoleLabel(role);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
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
