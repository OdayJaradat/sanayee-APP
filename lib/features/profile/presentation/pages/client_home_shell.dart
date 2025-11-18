import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';



class ClientHomeShell extends StatelessWidget {
  final Widget child;

  const ClientHomeShell({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: AppStrings.myRequests,
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: AppStrings.chats,
          ),
          NavigationDestination(
            icon: Icon(Icons.work_outline),
            selectedIcon: Icon(Icons.work),
            label: AppStrings.hiring,
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
    if (location.startsWith('/client/requests') ||
        location.startsWith('/requests')) {
      return 0;
    }
    if (location.startsWith('/client/chats') || location.startsWith('/chats')) {
      return 1;
    }
    if (location.startsWith('/client/hiring') ||
        location.startsWith('/hiring')) {
      return 2;
    }
    if (location.startsWith('/client/profile') ||
        location.startsWith('/profile')) {
      return 3;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/client/requests');
        break;
      case 1:
        context.go('/client/chats');
        break;
      case 2:
        context.go('/client/hiring');
        break;
      case 3:
        context.go('/client/profile');
        break;
    }
  }
}
