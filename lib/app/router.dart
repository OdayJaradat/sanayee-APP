import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'env.dart';
import 'injection.dart';
import '../features/auth/domain/repositories/user_repository.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/requests/presentation/pages/requests_list_page.dart';
import '../features/requests/presentation/pages/create_request_page.dart';
import '../features/requests/presentation/pages/request_details_page.dart';
import '../features/requests/presentation/pages/quick_request_page.dart';
import '../features/requests/presentation/cubit/requests_cubit.dart';
import '../features/chat/presentation/pages/chat_list_page.dart';
import '../features/chat/presentation/pages/chat_room_page.dart';
import '../features/professionals/presentation/pages/pros_jobs_page.dart';
import '../features/professionals/presentation/pages/pro_profile_page.dart';
import '../features/professionals/presentation/cubit/pros_jobs_cubit.dart';
import '../features/professionals/presentation/cubit/my_offers_cubit.dart';
import '../features/professionals/presentation/cubit/active_jobs_cubit.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/profile/presentation/pages/account_settings_page.dart';
import '../features/profile/presentation/pages/client_home_shell.dart';
import '../features/profile/presentation/pages/pro_home_shell.dart';
import '../features/profile/domain/repositories/session_repository.dart';
import '../features/ratings/presentation/pages/professional_ratings_page.dart';
import '../features/hiring/presentation/pages/pros_hiring_list_page.dart';
import '../features/hiring/presentation/pages/pros_hiring_create_page.dart';
import '../features/hiring/presentation/pages/hiring_explore_page.dart';

// navigator keys for navigation
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _clientShellNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _proShellNavigatorKey =
    GlobalKey<NavigatorState>();

// main router configuration using go_router
final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  // handles authentication redirects and role-based routing
  redirect: (context, state) async {
    final location = state.uri.toString();

    final useAuth = Env.useAuth;

    final publicRoutes = ['/login', '/register'];
    final isPublicRoute = publicRoutes.any(
      (route) => location.startsWith(route),
    );

    if (useAuth) {
      final userRepository = sl<UserRepository>();
      final result = await userRepository.getCurrentUser();
      final isAuthenticated = result.fold((l) => false, (user) => user != null);

      if (!isAuthenticated && !isPublicRoute) {
        return '/login';
      }

      if (isAuthenticated && isPublicRoute) {
        final roleResult = await userRepository.getCurrentUserRole();
        final role = roleResult.fold((l) => null, (r) => r);
        return role?.isClient == true ? '/client/requests' : '/pro/jobs';
      }

      if (location == '/') {
        if (isAuthenticated) {
          final roleResult = await userRepository.getCurrentUserRole();
          final role = roleResult.fold((l) => null, (r) => r);
          return role?.isClient == true ? '/client/requests' : '/pro/jobs';
        } else {
          return '/login';
        }
      }
    } else {
      if (location == '/') {
        final role = sl<SessionRepository>().getCurrentRoleSync();
        return role.isClient ? '/client/requests' : '/pro/jobs';
      }
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => BlocProvider(
        create: (_) => sl<AuthCubit>(),
        child: const RegisterPage(),
      ),
    ),
    ShellRoute(
      navigatorKey: _clientShellNavigatorKey,
      builder: (context, state, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<AuthCubit>()..checkAuthStatus()),
            BlocProvider(create: (_) => sl<RequestsCubit>()),
          ],
          child: ClientHomeShell(child: child),
        );
      },
      routes: [
        GoRoute(
          path: '/client/requests',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const RequestsListPage(),
          ),
        ),
        GoRoute(
          path: '/client/chats',
          pageBuilder: (context, state) =>
              NoTransitionPage(key: state.pageKey, child: const ChatListPage()),
        ),
        GoRoute(
          path: '/client/hiring',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const HiringExplorePage(),
          ),
        ),
        GoRoute(
          path: '/client/profile',
          pageBuilder: (context, state) =>
              NoTransitionPage(key: state.pageKey, child: const ProfilePage()),
        ),
      ],
    ),

    ShellRoute(
      navigatorKey: _proShellNavigatorKey,
      builder: (context, state, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<AuthCubit>()..checkAuthStatus()),
            BlocProvider(create: (_) => sl<ProsJobsCubit>()),
            BlocProvider(create: (_) => sl<MyOffersCubit>()),
            BlocProvider(create: (_) => sl<ActiveJobsCubit>()),
          ],
          child: ProHomeShell(child: child),
        );
      },
      routes: [
        GoRoute(
          path: '/pro/jobs',
          pageBuilder: (context, state) =>
              NoTransitionPage(key: state.pageKey, child: const ProsJobsPage()),
        ),
        GoRoute(
          path: '/pro/chats',
          pageBuilder: (context, state) =>
              NoTransitionPage(key: state.pageKey, child: const ChatListPage()),
        ),
        GoRoute(
          path: '/pro/hiring',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const ProsHiringListPage(),
          ),
        ),
        GoRoute(
          path: '/pro/profile',
          pageBuilder: (context, state) =>
              NoTransitionPage(key: state.pageKey, child: const ProfilePage()),
        ),
      ],
    ),

    GoRoute(
      path: '/account-settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AccountSettingsPage(),
    ),
    GoRoute(
      path: '/quick-request',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const QuickRequestPage(),
    ),
    GoRoute(
      path: '/requests/create',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CreateRequestPage(),
    ),
    GoRoute(
      path: '/requests/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final extra = state.extra as Map<String, dynamic>?;
        final isClientView = extra?['isClientView'] as bool? ?? true;
        return RequestDetailsPage(requestId: id, isClientView: isClientView);
      },
    ),
    GoRoute(
      path: '/chats/:conversationId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final conversationId = state.pathParameters['conversationId']!;
        return ChatRoomPage(conversationId: conversationId);
      },
    ),
    GoRoute(
      path: '/pro/hiring/create',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ProsHiringCreatePage(),
    ),
    GoRoute(
      path: '/professionals/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProProfilePage(professionalId: id);
      },
    ),
    GoRoute(
      path: '/professionals/:id/ratings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final name = state.extra as String? ?? '';
        return ProfessionalRatingsPage(
          professionalId: id,
          professionalName: name,
        );
      },
    ),
  ],
);
