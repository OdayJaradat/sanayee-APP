import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/config/app_spacing.dart';

/// Admin sidebar navigation widget
class AdminSidebar extends StatelessWidget {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentLocation = GoRouterState.of(context).uri.toString();

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Logo Header
          _buildHeader(context),
          const Divider(height: 1),
          
          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              children: [
                _buildNavSection(context, 'الرئيسية', [
                  _NavItem(
                    icon: Icons.dashboard_rounded,
                    label: 'لوحة التحكم',
                    route: '/admin/dashboard',
                    isActive: currentLocation.startsWith('/admin/dashboard'),
                  ),
                ]),
                const SizedBox(height: AppSpacing.md),
                _buildNavSection(context, 'الإدارة', [
                  _NavItem(
                    icon: Icons.people_rounded,
                    label: 'المستخدمين',
                    route: '/admin/users',
                    isActive: currentLocation.startsWith('/admin/users'),
                  ),
                  _NavItem(
                    icon: Icons.assignment_rounded,
                    label: 'الطلبات',
                    route: '/admin/requests',
                    isActive: currentLocation.startsWith('/admin/requests'),
                  ),
                  _NavItem(
                    icon: Icons.engineering_rounded,
                    label: 'الصنايعية',
                    route: '/admin/professionals',
                    isActive: currentLocation.startsWith('/admin/professionals'),
                  ),
                  _NavItem(
                    icon: Icons.flag_rounded,
                    label: 'البلاغات',
                    route: '/admin/reports',
                    isActive: currentLocation.startsWith('/admin/reports'),
                  ),
                ]),
              ],
            ),
          ),
          
          // Footer
          const Divider(height: 1),
          _buildFooter(context, currentLocation),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryPurple,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.admin_panel_settings_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'صنايعي',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryPurple,
                  ),
                ),
                Text(
                  'لوحة الإدارة',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavSection(BuildContext context, String title, List<_NavItem> items) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xs,
          ),
          child: Text(
            title,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        ...items.map((item) => _buildNavItem(context, item)),
      ],
    );
  }

  Widget _buildNavItem(BuildContext context, _NavItem item) {
    final theme = Theme.of(context);
    
    final bgColor = item.isActive
        ? AppColors.primaryPurple.withValues(alpha: 0.1)
        : Colors.transparent;
    final fgColor = item.isActive
        ? AppColors.primaryPurple
        : theme.colorScheme.onSurface.withValues(alpha: 0.7);
    final fontWeight = item.isActive ? FontWeight.w600 : FontWeight.normal;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: InkWell(
          onTap: () => context.go(item.route),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm + 2,
            ),
            child: Row(
              children: [
                Icon(item.icon, color: fgColor, size: 20),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    item.label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: fgColor,
                      fontWeight: fontWeight,
                    ),
                  ),
                ),
                if (item.isActive)
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, String currentLocation) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: _buildNavItem(
        context,
        _NavItem(
          icon: Icons.settings_rounded,
          label: 'الإعدادات',
          route: '/admin/settings',
          isActive: currentLocation.startsWith('/admin/settings'),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final String route;
  final bool isActive;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.isActive,
  });
}
