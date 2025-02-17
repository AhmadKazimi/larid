import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/map/presentation/pages/map_page.dart';
import '../../features/api_config/presentation/pages/api_base_url_page.dart';
import '../../features/api_config/data/datasources/local_datasource.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../di/service_locator.dart';
import 'route_constants.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteConstants.login,
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      // First check if base URL is configured
      final apiConfigDataSource = getIt<ApiConfigLocalDataSource>();
      final baseUrl = await apiConfigDataSource.getBaseUrl();
      
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
        if (isLoggedIn && !isLoggingIn) {
          return RouteConstants.map;
        }

        // If user is not logged in and trying to access protected pages,
        // redirect to login page
        if (!isLoggedIn && !isLoggingIn) {
          return RouteConstants.login;
        }
      }

      return null;
    },
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return Scaffold(
            body: child,
          );
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
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );
}
