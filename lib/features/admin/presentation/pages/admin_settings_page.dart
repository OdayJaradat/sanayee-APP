import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/config/app_spacing.dart';
import '../widgets/admin_scaffold.dart';

/// Admin settings page showing account info
class AdminSettingsPage extends StatelessWidget {
  const AdminSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'الإعدادات',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildAccountInfoCard(context)],
        ),
      ),
    );
  }

  Widget _buildAccountInfoCard(BuildContext context) {
    final theme = Theme.of(context);
    final user = Supabase.instance.client.auth.currentUser;

    return Container(
      width: double.infinity,
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
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: const Icon(
                  Icons.admin_panel_settings_rounded,
                  color: AppColors.primaryPurple,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                'معلومات حساب المسؤول',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: AppSpacing.xl),
          _buildInfoRow(
            context,
            icon: Icons.email_rounded,
            label: 'البريد الإلكتروني',
            value: user?.email ?? '—',
            canCopy: true,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildInfoRow(
            context,
            icon: Icons.fingerprint_rounded,
            label: 'معرف المستخدم (UID)',
            value: user?.id ?? '—',
            isMonospace: true,
            canCopy: true,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildInfoRow(
            context,
            icon: Icons.badge_rounded,
            label: 'الدور',
            value: 'مسؤول (Admin)',
            valueColor: AppColors.primaryPurple,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildInfoRow(
            context,
            icon: Icons.access_time_rounded,
            label: 'آخر تسجيل دخول',
            value: _formatLastSignIn(user?.lastSignInAt),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildInfoRow(
            context,
            icon: Icons.calendar_today_rounded,
            label: 'تاريخ إنشاء الحساب',
            value: _formatDate(user?.createdAt),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool isMonospace = false,
    bool canCopy = false,
    Color? valueColor,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: SelectableText(
                      value,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontFamily: isMonospace ? 'monospace' : null,
                        color: valueColor,
                      ),
                    ),
                  ),
                  if (canCopy && value != '—')
                    IconButton(
                      icon: const Icon(Icons.copy_rounded, size: 16),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: value));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم النسخ'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      tooltip: 'نسخ',
                      style: IconButton.styleFrom(
                        foregroundColor: theme.colorScheme.primary,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatLastSignIn(String? dateStr) {
    if (dateStr == null) return '—';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year} - ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '—';
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '—';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return '—';
    }
  }
}
