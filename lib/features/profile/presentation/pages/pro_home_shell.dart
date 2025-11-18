import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';



class ProHomeShell extends StatelessWidget {
  final Widget child;

  const ProHomeShell({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.work_outline),
            selectedIcon: Icon(Icons.work),
            label: AppStrings.jobs,
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: AppStrings.chats,
          ),
          NavigationDestination(
            icon: Icon(Icons.badge_outlined),
            selectedIcon: Icon(Icons.badge),
            label: 'التوظيف',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: AppStrings.profile,
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/pro/jobs') ||
        location.startsWith('/professionals')) {
      return 0;
    }
    if (location.startsWith('/pro/chats') || location.startsWith('/chats')) {
      return 1;
    }
    if (location.startsWith('/pro/hiring') || location.startsWith('/hiring')) {
      return 2;
    }
    if (location.startsWith('/pro/profile') ||
        location.startsWith('/profile')) {
      return 3;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/pro/jobs');
        break;
      case 1:
        context.go('/pro/chats');
        break;
      case 2:
        context.go('/pro/hiring');
        break;
      case 3:
        context.go('/pro/profile');
        break;
    }
  }
}
