import 'package:flutter/material.dart';
import '../../../../core/config/app_spacing.dart';
import 'admin_sidebar.dart';
import 'admin_topbar.dart';

/// Main admin scaffold that wraps admin pages with sidebar and topbar
class AdminScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;

  const AdminScaffold({
    super.key,
    required this.title,
    required this.child,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      body: Row(
        children: [
          // Sidebar
          const AdminSidebar(),
          
          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top Bar
                AdminTopbar(
                  title: title,
                  actions: actions,
                ),
                
                // Page Content
                Expanded(
                  child: Container(
                    color: theme.colorScheme.surfaceContainerLowest,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1400),
                        child: child,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
