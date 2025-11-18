import 'package:flutter/material.dart';
import '../../../../app/injection.dart';
import '../../../../core/config/app_spacing.dart';
import '../../../auth/data/datasources/supabase_auth_datasource.dart';


class AccountHeader extends StatelessWidget {
  final String? avatarUrl;
  final String fullName;

  const AccountHeader({required this.fullName, this.avatarUrl, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authEmail = sl<SupabaseAuthDataSource>().getCurrentUserEmail();

    return Row(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
          child: avatarUrl == null
              ? Icon(Icons.person, size: 32, color: theme.colorScheme.primary)
              : null,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fullName,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                authEmail,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
