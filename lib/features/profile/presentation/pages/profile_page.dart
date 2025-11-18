import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/env.dart';
import '../../../../app/injection.dart';
import '../../../../core/config/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../auth/domain/usecases/sign_out.dart';
import '../../../professionals/domain/repositories/professionals_repository.dart';
import '../../../professionals/presentation/widgets/ratings_breakdown_widget.dart';
import '../../../professionals/presentation/widgets/recent_jobs_widget.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../widgets/account_header.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final profileRepo = sl<ProfileRepository>();

    return Scaffold(
      appBar: AppBar(title: const Text('الملف الشخصي')),
      body: FutureBuilder(
        future: profileRepo.getMyProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return _buildErrorView(context);
          }

          return snapshot.data!.fold(
            (failure) => _buildErrorView(context),
            (profile) => _buildProfileContent(context, profile),
          );
        },
      ),
    );
  }

  Widget _buildErrorView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.grey),
          const SizedBox(height: AppSpacing.md),
          Text(
            'فشل في تحميل بيانات الملف الشخصي',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, Profile profile) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        AppCard(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: AccountHeader(
              fullName: profile.fullName,
              avatarUrl: profile.avatarUrl,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (profile.isProfessional) ...[
          _buildProfessionalStats(context, profile.id),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: RatingsBreakdownWidget(professionalId: profile.id),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: RecentJobsWidget(professionalId: profile.id),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        AppCard(
          child: Column(
            children: [
              _buildMenuItem(
                context,
                icon: Icons.person_outline,
                title: 'معلومات الحساب',
                onTap: () => context.push('/account-settings'),
              ),
              const Divider(height: 1),
              _buildMenuItem(
                context,
                icon: Icons.help_outline,
                title: 'المساعدة والدعم',
                onTap: () {},
              ),
              const Divider(height: 1),
              _buildMenuItem(
                context,
                icon: Icons.logout,
                title: 'تسجيل الخروج',
                onTap: () async {
                  if (Env.useAuth) {
                    final signOut = sl<SignOut>();
                    await signOut();
                    if (context.mounted) {
                      context.go('/login');
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تسجيل الخروج غير متاح في وضع التطوير'),
                      ),
                    );
                  }
                },
                isDestructive: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfessionalStats(BuildContext context, String professionalId) {
    final theme = Theme.of(context);
    final professionalRepo = sl<ProfessionalsRepository>();

    return FutureBuilder(
      future: professionalRepo.fetchProfessionalStats(professionalId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AppCard(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const SizedBox.shrink();
        }

        return snapshot.data!.when(
          ok: (stats) => AppCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text('الإحصائيات', style: theme.textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        context,
                        icon: Icons.star,
                        label: 'التقييم',
                        value: stats.avgRating.toStringAsFixed(1),
                        subtitle: '(${stats.ratingsCount} تقييم)',
                      ),
                      Container(
                        height: 40,
                        width: 1,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.2,
                        ),
                      ),
                      _buildStatItem(
                        context,
                        icon: Icons.check_circle,
                        label: 'الطلبات المنجزة',
                        value: stats.completedRequests.toString(),
                        subtitle: 'طلب',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          err: (failure) => const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    String? subtitle,
  }) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 24),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        if (subtitle != null)
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
    Widget? trailing,
  }) {
    final theme = Theme.of(context);
    final color = isDestructive
        ? theme.colorScheme.error
        : theme.colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(color: color),
              ),
            ),
            if (trailing != null) trailing,
            if (!isDestructive && trailing == null)
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
          ],
        ),
      ),
    );
  }
}
