import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/admin_router.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/config/app_spacing.dart';

/// Page shown when user is not authorized to access admin panel
class AdminAccessDeniedPage extends StatelessWidget {
  const AdminAccessDeniedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Access denied icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.block_rounded,
                  size: 64,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Title
              Text(
                'الوصول مرفوض',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),

              // Message
              Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Text(
                  'حسابك لا يملك صلاحيات الوصول إلى لوحة الإدارة.\n'
                  'يرجى التواصل مع مسؤول النظام إذا كنت تعتقد أن هذا خطأ.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.neutral600,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Back to login button
                  OutlinedButton.icon(
                    onPressed: () {
                      context.go('/admin/login');
                    },
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('العودة لتسجيل الدخول'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),

                  // Sign out button
                  FilledButton.icon(
                    onPressed: () async {
                      await signOutAdmin();
                      if (context.mounted) {
                        context.go('/admin/login');
                      }
                    },
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('تسجيل الخروج'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.neutral600,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // Help card
              Container(
                constraints: const BoxConstraints(maxWidth: 450),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.help_outline_rounded,
                      color: AppColors.warning,
                      size: 24,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'هل تحتاج صلاحيات الإدارة؟',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.warning,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'تواصل مع فريق الدعم الفني للحصول على المساعدة.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.neutral600,
                            ),
                          ),
                        ],
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
