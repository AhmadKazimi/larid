import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:larid/features/sync/presentation/pages/sync_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/map/presentation/pages/map_page.dart';
import '../../features/api_config/presentation/pages/api_base_url_page.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../database/user_db.dart';
import '../di/service_locator.dart';
import 'route_constants.dart';

class AppRouter {
  static final _logger = Logger('AppRouter');
  static final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  static final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

  static GoRouter get router => _router;

 

  static final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteConstants.login,
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      try {
        _logger.info('Starting redirect for location: ${state.matchedLocation}');
        
        final userDB = getIt<UserDB>();
        final baseUrl = await userDB.getBaseUrl();
        _logger.info('Got base URL: $baseUrl');

        final isApiConfigPage = state.matchedLocation == RouteConstants.apiConfig;
        final isLoginPage = state.matchedLocation == RouteConstants.login;
        final isSyncPage = state.matchedLocation == RouteConstants.sync;

        // If base URL is not set, redirect to API config page
        if ((baseUrl == null || baseUrl.isEmpty) && !isApiConfigPage) {
          _logger.info('Redirecting to API config page - no base URL');
          return RouteConstants.apiConfig;
        }



        // Only proceed with auth checks if base URL is configured
        if (baseUrl != null && baseUrl.isNotEmpty) {
          final authRepository = getIt<AuthRepository>();
          final isLoggedIn = authRepository.isLoggedIn();
          _logger.info('Auth check - isLoggedIn: $isLoggedIn, current page: ${state.matchedLocation}');

          // If logged in, redirect to sync unless already there
          if (isLoggedIn && !isSyncPage) {
            _logger.info('User is logged in, redirecting to sync page');
            return RouteConstants.sync;
          }

          // If not logged in and trying to access protected page, redirect to login
          if (!isLoggedIn && !isLoginPage && !isApiConfigPage) {
            _logger.info('User not logged in, redirecting to login');
            return RouteConstants.login;
          }
        }

        _logger.info('No redirect needed for ${state.matchedLocation}');
        return null;
      } catch (e, stackTrace) {
        _logger.severe('Error in redirect: $e\n$stackTrace');
        return null;
      }
    },
    routes: [
      // Login Route
      GoRoute(
        path: RouteConstants.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      // API Config Route
      GoRoute(
        path: RouteConstants.apiConfig,
        name: 'api-config',
        builder: (context, state) => const ApiBaseUrlPage(),
      ),

      // Home Route
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

      // Sync Route
      GoRoute(
        path: RouteConstants.sync,
        name: 'sync',
        builder: (context, state) => const SyncPage(),
      ),
    ],
    errorBuilder:
        (context, state) =>
            Scaffold(body: Center(child: Text('Error: ${state.error}'))),
  );
}
