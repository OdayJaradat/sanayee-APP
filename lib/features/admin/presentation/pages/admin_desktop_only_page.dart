import 'package:flutter/material.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/config/app_spacing.dart';

/// Page shown when admin panel is accessed on non-desktop screen
class AdminDesktopOnlyPage extends StatelessWidget {
  final String message;

  const AdminDesktopOnlyPage({
    super.key,
    this.message = 'Admin panel requires a desktop screen.',
  });

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
              // Admin icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.admin_panel_settings_rounded,
                  size: 64,
                  color: AppColors.primaryPurple,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Title
              Text(
                'لوحة الإدارة',
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
                  message,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.neutral600,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Hint card
              Container(
                constraints: const BoxConstraints(maxWidth: 450),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(
                    color: AppColors.info.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lightbulb_outline_rounded,
                      color: AppColors.info,
                      size: 24,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'نصيحة: افتح هذه الصفحة باستخدام متصفح Chrome أو Edge على جهاز كمبيوتر مكتبي.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.info,
                        ),
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
