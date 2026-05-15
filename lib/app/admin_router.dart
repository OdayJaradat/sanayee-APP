import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../features/admin/presentation/pages/admin_access_denied_page.dart';
import '../features/admin/presentation/pages/admin_dashboard_page.dart';
import '../features/admin/presentation/pages/admin_desktop_only_page.dart';
import '../features/admin/presentation/pages/admin_login_page.dart';
import '../features/admin/presentation/pages/admin_requests_page.dart';
import '../features/admin/presentation/pages/admin_users_page.dart';
import '../features/admin/presentation/pages/admin_user_details_page.dart';
import '../features/admin/presentation/pages/admin_request_details_page.dart';
import '../features/admin/presentation/pages/admin_reports_page.dart';
import '../features/admin/presentation/pages/admin_report_details_page.dart';
import '../features/admin/presentation/pages/admin_professionals_page.dart';
import '../features/admin/presentation/pages/admin_settings_page.dart';

/// Admin panel router configuration with authentication and role guards
final adminRouter = GoRouter(
  initialLocation: '/admin/dashboard',
  redirect: _adminRedirect,
  routes: [
    // ========================================
    // PUBLIC ROUTES (no shell, standalone pages)
    // ========================================
    
    // Login page
    GoRoute(
      path: '/admin/login',
      builder: (context, state) => const AdminLoginPage(),
    ),

    // Access denied page
    GoRoute(
      path: '/admin/access-denied',
      builder: (context, state) => const AdminAccessDeniedPage(),
    ),

    // Desktop-only fallback page
    GoRoute(
      path: '/admin/desktop-only',
      builder: (context, state) {
        final message = state.extra as String? ??
            'لوحة الإدارة تتطلب شاشة سطح المكتب.';
        return AdminDesktopOnlyPage(message: message);
      },
    ),

    // ========================================
    // PROTECTED ROUTES (with AdminScaffold shell)
    // ========================================
    
    // Main admin dashboard
    GoRoute(
      path: '/admin/dashboard',
      builder: (context, state) => const AdminDashboardPage(),
    ),

    // Users management
    GoRoute(
      path: '/admin/users',
      builder: (context, state) => const AdminUsersPage(),
    ),

    // User details
    GoRoute(
      path: '/admin/users/:userId',
      builder: (context, state) {
        final userId = state.pathParameters['userId']!;
        return AdminUserDetailsPage(userId: userId);
      },
    ),

    // Requests management
    GoRoute(
      path: '/admin/requests',
      builder: (context, state) {
        // Parse query params for filtering
        final professionalId = state.uri.queryParameters['professionalId'];
        final clientId = state.uri.queryParameters['clientId'];
        final status = state.uri.queryParameters['status'];
        return AdminRequestsPage(
          initialProfessionalId: professionalId,
          initialClientId: clientId,
          initialStatus: status,
        );
      },
    ),

    // Request details
    GoRoute(
      path: '/admin/requests/:requestId',
      builder: (context, state) {
        final requestId = state.pathParameters['requestId']!;
        return AdminRequestDetailsPage(requestId: requestId);
      },
    ),

    // Professionals management
    GoRoute(
      path: '/admin/professionals',
      builder: (context, state) => const AdminProfessionalsPage(),
    ),

    // Reports management
    GoRoute(
      path: '/admin/reports',
      builder: (context, state) {
        // Parse query params for filtering
        final targetType = state.uri.queryParameters['targetType'];
        final targetId = state.uri.queryParameters['targetId'];
        final status = state.uri.queryParameters['status'];
        return AdminReportsPage(
          initialTargetType: targetType,
          initialTargetId: targetId,
          initialStatus: status,
        );
      },
    ),

    // Report details
    GoRoute(
      path: '/admin/reports/:reportId',
      builder: (context, state) {
        final reportId = state.pathParameters['reportId']!;
        return AdminReportDetailsPage(reportId: reportId);
      },
    ),

    // Settings
    GoRoute(
      path: '/admin/settings',
      builder: (context, state) => const AdminSettingsPage(),
    ),
  ],
);

/// Admin redirect logic implementing all guards
/// Uses state.uri.path for robust route matching (ignores query strings)
Future<String?> _adminRedirect(
  BuildContext context,
  GoRouterState state,
) async {
  // Use path only (not full URI) to avoid query string issues
  final path = state.uri.path;

  // Helper to check if current path is a public route
  bool isPublicRoute() {
    return path == '/admin/login' ||
        path == '/admin/desktop-only' ||
        path == '/admin/access-denied';
  }

  // GUARD 1: Web-only check (non-web platforms go to desktop-only page)
  if (!kIsWeb) {
    // Already on desktop-only? Don't redirect again
    if (path == '/admin/desktop-only') return null;
    return '/admin/desktop-only';
  }

  // GUARD 2: Check authentication
  final supabase = Supabase.instance.client;
  final currentUser = supabase.auth.currentUser;
  final isLoggedIn = currentUser != null;

  // If not logged in
  if (!isLoggedIn) {
    // Already on login or other public route? Stay there
    if (isPublicRoute()) return null;
    // Redirect to login
    return '/admin/login';
  }

  // User is logged in - check role
  // GUARD 3: Role check (admin only)
  String? role = AdminRoleCache.role;

  // Fetch role if cache is empty or expired
  if (role == null || AdminRoleCache.isExpired) {
    try {
      final response = await supabase
          .from('profiles')
          .select('role')
          .eq('id', currentUser.id);

      if (response.isEmpty) {
        AdminRoleCache.clear();
        // No profile found - redirect to login unless already there
        if (path == '/admin/login') return null;
        return '/admin/login';
      }

      role = response.first['role'] as String?;
      AdminRoleCache.role = role;
    } catch (e) {
      // If we can't fetch role, clear cache and redirect to login
      AdminRoleCache.clear();
      if (path == '/admin/login') return null;
      return '/admin/login';
    }
  }

  // Check if user is admin
  final isAdmin = role == 'admin';

  if (!isAdmin) {
    // User is logged in but not admin - send to access-denied
    // Avoid redirect loop: if already on access-denied or login, stay
    if (path == '/admin/access-denied' || path == '/admin/login') return null;
    return '/admin/access-denied';
  }

  // User is admin
  // If admin is on login page, redirect to dashboard
  if (path == '/admin/login') {
    return '/admin/dashboard';
  }

  // Allow access to all admin routes
  return null;
}

// ============================================================================
// ADMIN ROLE CACHE (from admin_login_page.dart - re-exported here for access)
// ============================================================================

/// Simple in-memory cache for admin role to avoid hitting Supabase on every redirect
class AdminRoleCache {
  static String? _role;
  static DateTime? _loadedAt;
  static const _cacheDuration = Duration(seconds: 60);

  static String? get role {
    if (_role == null || _loadedAt == null) return null;
    if (DateTime.now().difference(_loadedAt!) > _cacheDuration) {
      clear();
      return null;
    }
    return _role;
  }

  static set role(String? value) {
    _role = value;
    _loadedAt = DateTime.now();
  }

  static void clear() {
    _role = null;
    _loadedAt = null;
  }

  static bool get isExpired {
    if (_loadedAt == null) return true;
    return DateTime.now().difference(_loadedAt!) > _cacheDuration;
  }
}

/// Helper function to sign out admin user
Future<void> signOutAdmin() async {
  await Supabase.instance.client.auth.signOut();
  AdminRoleCache.clear();
}
