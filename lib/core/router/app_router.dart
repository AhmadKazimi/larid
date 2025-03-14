import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larid/features/sync/presentation/pages/sync_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/map/presentation/pages/map_page.dart';
import '../../features/api_config/presentation/pages/api_base_url_page.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/customer_search/presentation/pages/search_customer_page.dart';
import '../../features/customer_search/presentation/bloc/customer_search_bloc.dart';
import '../../features/customer_activity/presentation/pages/customer_activity_page.dart';
import '../../features/invoice/presentation/pages/invoice_page.dart';
import '../../features/invoice/presentation/pages/items_page.dart';
import '../../features/invoice/presentation/pages/print_page.dart';
import '../../features/invoice/presentation/bloc/items_bloc.dart';
import '../../features/photo_capture/presentation/pages/photo_capture_page.dart';
import '../../features/receipt_voucher/presentation/pages/receipt_voucher_page.dart';
import '../../features/sync/domain/entities/customer_entity.dart';
import '../../database/user_table.dart';
import '../di/service_locator.dart';
import '../storage/shared_prefs.dart';
import 'route_constants.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'root',
  );

  static GoRouter get router => _router;

  // Helper method to create a standard slide transition
  static CustomTransitionPage<void> _buildSlideTransition({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
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
  }

  static final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteConstants.login,
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      try {
        final userDB = getIt<UserTable>();
        final baseUrl = await userDB.getBaseUrl();

        final isApiConfigPage =
            state.matchedLocation == RouteConstants.apiConfig;
        final isLoginPage = state.matchedLocation == RouteConstants.login;
        final isSyncPage = state.matchedLocation == RouteConstants.sync;
        final isMapPage = state.matchedLocation == RouteConstants.map;
        final isCustomerSearchPage =
            state.matchedLocation == RouteConstants.customerSearch;
        final isCustomerActivityPage =
            state.matchedLocation == RouteConstants.customerActivity;
        final isInvoicePage = state.matchedLocation == RouteConstants.invoice;
        final isItemsPage = state.matchedLocation == RouteConstants.items;
        final isPhotoCaptureePage =
            state.matchedLocation == RouteConstants.photoCapture;
        final isReceiptVoucherPage =
            state.matchedLocation == RouteConstants.receiptVoucher;

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
            if (isSynced &&
                !isMapPage &&
                !isCustomerSearchPage &&
                !isCustomerActivityPage &&
                !isInvoicePage &&
                !isItemsPage &&
                !isPhotoCaptureePage &&
                !isReceiptVoucherPage &&
                state.matchedLocation != RouteConstants.printInvoice) {
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
        pageBuilder:
            (context, state) => _buildSlideTransition(
              context: context,
              state: state,
              child: const ApiBaseUrlPage(),
            ),
      ),

      // Login Route
      GoRoute(
        path: RouteConstants.login,
        name: 'login',
        pageBuilder:
            (context, state) => _buildSlideTransition(
              context: context,
              state: state,
              child: const LoginPage(),
            ),
      ),

      // Sync Route
      GoRoute(
        path: RouteConstants.sync,
        name: 'sync',
        pageBuilder:
            (context, state) => _buildSlideTransition(
              context: context,
              state: state,
              child: const SyncPage(),
            ),
      ),

      // Map Route
      GoRoute(
        path: RouteConstants.map,
        name: 'map',
        pageBuilder:
            (context, state) => _buildSlideTransition(
              context: context,
              state: state,
              child: const MapPage(),
            ),
      ),

      // Customer Search Route
      GoRoute(
        path: RouteConstants.customerSearch,
        name: 'customer-search',
        pageBuilder:
            (context, state) => _buildSlideTransition(
              context: context,
              state: state,
              child: BlocProvider(
                create: (context) => CustomerSearchBloc(),
                child: const SearchCustomerPage(),
              ),
            ),
      ),

      // Customer Activity Route
      GoRoute(
        path: RouteConstants.customerActivity,
        name: 'customer-activity',
        pageBuilder: (context, state) {
          final customer = state.extra as CustomerEntity;
          return _buildSlideTransition(
            context: context,
            state: state,
            child: CustomerActivityPage(customer: customer),
          );
        },
      ),

      // Invoice Route
      GoRoute(
        path: RouteConstants.invoice,
        name: 'invoice',
        pageBuilder: (context, state) {
          // Handle both direct CustomerEntity and Map with isReturn flag
          CustomerEntity customer;
          bool isReturn = false;

          if (state.extra is Map) {
            final extraMap = state.extra as Map;
            customer = extraMap['customer'] as CustomerEntity;
            isReturn = extraMap['isReturn'] as bool? ?? false;
          } else {
            customer = state.extra as CustomerEntity;
          }

          return _buildSlideTransition(
            context: context,
            state: state,
            child: InvoicePage(customer: customer, isReturn: isReturn),
          );
        },
      ),

      // Items Route
      GoRoute(
        path: RouteConstants.items,
        name: 'items',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final isReturn = extra?['isReturn'] as bool? ?? false;
          final preselectedItems =
              extra?['preselectedItems'] as Map<String, int>?;

          return _buildSlideTransition(
            context: context,
            state: state,
            child: BlocProvider(
              create: (context) => ItemsBloc(),
              child: ItemsPage(
                isReturn: isReturn,
                preselectedItems: preselectedItems,
              ),
            ),
          );
        },
      ),

      // Photo Capture Route
      GoRoute(
        path: RouteConstants.photoCapture,
        name: 'photo-capture',
        pageBuilder: (context, state) {
          final customer = state.extra as CustomerEntity;
          return _buildSlideTransition(
            context: context,
            state: state,
            child: PhotoCapturePage(
              customerName: customer.customerName,
              customerCode: customer.customerCode,
            ),
          );
        },
      ),

      // Receipt Voucher Route
      GoRoute(
        path: RouteConstants.receiptVoucher,
        name: 'receipt-voucher',
        pageBuilder: (context, state) {
          final customer = state.extra as CustomerEntity;
          return _buildSlideTransition(
            context: context,
            state: state,
            child: ReceiptVoucherPage(customer: customer),
          );
        },
      ),

      // Print Invoice Route
      GoRoute(
        path: RouteConstants.printInvoice,
        name: 'print-invoice',
        pageBuilder: (context, state) {
          final extraData = state.extra as Map<String, dynamic>;
          final invoice = extraData['invoice'];
          final customer = extraData['customer'] as CustomerEntity;
          final isReturn = extraData['isReturn'] as bool? ?? false;

          return _buildSlideTransition(
            context: context,
            state: state,
            child: PrintPage(
              invoice: invoice,
              customer: customer,
              isReturn: isReturn,
            ),
          );
        },
      ),
    ],
    errorBuilder:
        (context, state) =>
            Scaffold(body: Center(child: Text('Error: ${state.error}'))),
  );
}
