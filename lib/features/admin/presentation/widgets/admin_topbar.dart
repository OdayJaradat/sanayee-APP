import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../app/admin_router.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/config/app_spacing.dart';

/// Admin top bar widget with title and actions
class AdminTopbar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;

  const AdminTopbar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = Supabase.instance.client.auth.currentUser;

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Page Title
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const Spacer(),
          
          // Custom Actions (including page-specific refresh buttons)
          if (actions != null) ...actions!,
          
          const SizedBox(width: AppSpacing.md),
          
          // User Info Chip
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryPurple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primaryPurple.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.admin_panel_settings_rounded,
                  size: 18,
                  color: AppColors.primaryPurple,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  user?.email ?? 'Admin',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.primaryPurple,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: AppSpacing.md),
          
          // Logout Button
          FilledButton.icon(
            onPressed: () => _handleLogout(context),
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: const Text('خروج'),
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error.withValues(alpha: 0.1),
              foregroundColor: theme.colorScheme.error,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('خروج'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await signOutAdmin();
      if (context.mounted) {
        context.go('/admin/login');
      }
    }
  }
}
