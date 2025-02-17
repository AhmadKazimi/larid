import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:larid/features/sync/presentation/pages/sync_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/map/presentation/pages/map_page.dart';
import '../../features/api_config/presentation/pages/api_base_url_page.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../database/user_db.dart';
import '../../features/sync/presentation/pages/sync_page.dart';
import '../di/service_locator.dart';
import 'route_constants.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'shell',
);

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');
  static String? _cachedBaseUrl;
  static DateTime? _lastRedirectTime;

  static GoRouter get router => _router;
  
  // Public method to clear the cached base URL
  static void clearCachedBaseUrl() {
    _cachedBaseUrl = null;
  }

  static final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteConstants.login,
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      // Implement debouncing
      final now = DateTime.now();
      if (_lastRedirectTime != null && 
          now.difference(_lastRedirectTime!) < const Duration(milliseconds: 300)) {
        return null;
      }
      _lastRedirectTime = now;

      // Use cached baseUrl if available and not in API config page
      // First check if base URL is configured
      final userDB = getIt<UserDB>();
      final baseUrl = await userDB.getBaseUrl();

      final isApiConfigPage = state.matchedLocation == RouteConstants.apiConfig;

      // If base URL is not set, redirect to API config page
      if ((baseUrl == null || baseUrl.isEmpty) && !isApiConfigPage) {
        return RouteConstants.apiConfig;
      }

      // Only proceed with auth checks if base URL is configured
      if (baseUrl != null && baseUrl.isNotEmpty) {
        final authRepository = getIt<AuthRepository>();
        final isLoggedIn = authRepository.isLoggedIn();
        final isLoggingIn = state.matchedLocation == RouteConstants.login;

        // If user is logged in and not on protected pages, go to map
        if (isLoggedIn) {
          return RouteConstants.map;
        }

        // If user is not logged in and trying to access protected pages,
        // redirect to login page
        if (!isLoggingIn) {
          return RouteConstants.login;
        }
      }

      return null;
    },
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return Scaffold(body: child);
        },
        routes: [
          // API Config Route
          GoRoute(
            path: RouteConstants.apiConfig,
            name: 'apiConfig',
            builder: (context, state) => const ApiBaseUrlPage(),
          ),
          // Auth Routes
          GoRoute(
            path: RouteConstants.login,
            name: 'login',
            builder: (context, state) => const LoginPage(),
          ),
        ],
      ),
      // Home Routes
      GoRoute(
        path: RouteConstants.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      // Map Route
      GoRoute(
        path: RouteConstants.map,
        name: 'map',
        builder: (context, state) => const MapPage(),
      ),

      //   GoRoute(
      //   path: RouteConstants.sync,
      //   name: 'sync',
      //   builder: (context, state) => const SyncPage(),
      // ),
    ],
    errorBuilder:
        (context, state) =>
            Scaffold(body: Center(child: Text('Error: ${state.error}'))),
  );
}
