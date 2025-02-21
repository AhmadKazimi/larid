import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:larid/features/sync/presentation/pages/sync_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/map/presentation/pages/map_page.dart';
import '../../features/api_config/presentation/pages/api_base_url_page.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../database/user_table.dart';
import '../di/service_locator.dart';
import '../storage/shared_prefs.dart';
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
        final userDB = getIt<UserTable>();
        final baseUrl = await userDB.getBaseUrl();

        final isApiConfigPage = state.matchedLocation == RouteConstants.apiConfig;
        final isLoginPage = state.matchedLocation == RouteConstants.login;
        final isSyncPage = state.matchedLocation == RouteConstants.sync;
        final isMapPage = state.matchedLocation == RouteConstants.map;

        // If base URL is not set, redirect to API config page
        if ((baseUrl == null || baseUrl.isEmpty) && !isApiConfigPage) {
          return RouteConstants.apiConfig;
        }

        // Only proceed with auth checks if base URL is configured
        if (baseUrl != null && baseUrl.isNotEmpty) {
          final authRepository = getIt<AuthRepository>();
          final isLoggedIn = authRepository.isLoggedIn();
          final isSynced = SharedPrefs.isSynced();

          // If not logged in and trying to access protected page, redirect to login
          if (!isLoggedIn && !isLoginPage && !isApiConfigPage) {
            return RouteConstants.login;
          }

          // If logged in but not on a protected page
          if (isLoggedIn) {
            // If data is synced and not on map page, go to map
            if (isSynced && !isMapPage) {
              return RouteConstants.map;
            }
            // If data is not synced and not on sync page, go to sync
            if (!isSynced && !isSyncPage) {
              return RouteConstants.sync;
            }
          }
        }

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
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Error: ${state.error}'))),
  );
}
