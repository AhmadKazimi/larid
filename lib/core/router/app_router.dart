import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larid/features/sync/presentation/pages/sync_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/map/presentation/pages/map_page.dart';
import '../../features/api_config/presentation/pages/api_base_url_page.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/customer_search/presentation/pages/search_customer_page.dart';
import '../../features/customer_search/presentation/bloc/customer_search_bloc.dart';
import '../../features/customer_activity/presentation/pages/customer_activity_page.dart';
import '../../features/invoice/presentation/pages/invoice_page.dart';
import '../../features/photo_capture/presentation/pages/photo_capture_page.dart';
import '../../features/receipt_voucher/presentation/pages/receipt_voucher_page.dart';
import '../../features/sync/domain/entities/customer_entity.dart';
import '../../database/user_table.dart';
import '../di/service_locator.dart';
import '../storage/shared_prefs.dart';
import 'route_constants.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

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
        final isCustomerSearchPage = state.matchedLocation == RouteConstants.customerSearch;
        final isCustomerActivityPage = state.matchedLocation == RouteConstants.customerActivity;

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
            // If data is synced and not on a permitted page, go to map
            if (isSynced && !isMapPage && !isCustomerSearchPage && !isCustomerActivityPage) {
              return RouteConstants.map;
            }
            // If data is not synced and not on sync page, go to sync
            if (!isSynced && !isSyncPage) {
              return RouteConstants.sync;
            }
          }
        }

        return null;
      } catch (_, _) {
        return null;
      }
    },
    routes: [
      // API Config Route
      GoRoute(
        path: RouteConstants.apiConfig,
        name: 'api-config',
        builder: (context, state) => const ApiBaseUrlPage(),
      ),

      // Login Route
      GoRoute(
        path: RouteConstants.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      // Sync Route
      GoRoute(
        path: RouteConstants.sync,
        name: 'sync',
        builder: (context, state) => const SyncPage(),
      ),

      // Map Route
      GoRoute(
        path: RouteConstants.map,
        name: 'map',
        builder: (context, state) => const MapPage(),
      ),

      // Customer Search Route
      GoRoute(
        path: RouteConstants.customerSearch,
        name: 'customer-search',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: BlocProvider(
            create: (context) => CustomerSearchBloc(),
            child: const SearchCustomerPage(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: child,
            );
          },
        ),
      ),

      // Customer Activity Route
      GoRoute(
        path: RouteConstants.customerActivity,
        name: 'customer-activity',
        pageBuilder: (context, state) {
          final customer = state.extra as CustomerEntity;
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: CustomerActivityPage(customer: customer),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: animation.drive(
                  Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).chain(CurveTween(curve: Curves.easeInOut)),
                ),
                child: child,
              );
            },
          );
        },
      ),

      // Invoice Route
      GoRoute(
        path: RouteConstants.invoice,
        name: 'invoice',
        pageBuilder: (context, state) {
          final customer = state.extra as CustomerEntity;
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: InvoicePage(customer: customer),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: animation.drive(
                  Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).chain(CurveTween(curve: Curves.easeInOut)),
                ),
                child: child,
              );
            },
          );
        },
      ),

      // Photo Capture Route
      GoRoute(
        path: RouteConstants.photoCapture,
        name: 'photo-capture',
        pageBuilder: (context, state) {
          final customer = state.extra as CustomerEntity;
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: PhotoCapturePage(customer: customer),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: animation.drive(
                  Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).chain(CurveTween(curve: Curves.easeInOut)),
                ),
                child: child,
              );
            },
          );
        },
      ),

      // Receipt Voucher Route
      GoRoute(
        path: RouteConstants.receiptVoucher,
        name: 'receipt-voucher',
        pageBuilder: (context, state) {
          final customer = state.extra as CustomerEntity;
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: ReceiptVoucherPage(customer: customer),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: animation.drive(
                  Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).chain(CurveTween(curve: Curves.easeInOut)),
                ),
                child: child,
              );
            },
          );
        },
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Error: ${state.error}'))),
  );
}
