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
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/home/presentation/pages/home_page.dart';

class CustomTransitionPage<T> extends Page<T> {
  final Widget child;
  final Widget Function(
    BuildContext,
    Animation<double>,
    Animation<double>,
    Widget,
  )
  transitionsBuilder;

  const CustomTransitionPage({
    required this.child,
    required this.transitionsBuilder,
    super.key,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return transitionsBuilder(
          context,
          animation,
          secondaryAnimation,
          child,
        );
      },
    );
  }
}

CustomTransitionPage<void> _buildSlideTransition({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'root',
  );

  static GoRouter get router => _router;

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
        final isSettingsPage = state.matchedLocation == RouteConstants.settings;

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
                !isSettingsPage &&
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
      GoRoute(
        path: RouteConstants.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteConstants.apiConfig,
        builder: (context, state) => const ApiBaseUrlPage(),
      ),
      GoRoute(
        path: RouteConstants.sync,
        name: 'sync',
        builder: (context, state) => const SyncPage(),
      ),
      GoRoute(
        path: RouteConstants.map,
        name: 'map',
        pageBuilder:
            (context, state) => _buildSlideTransition(
              context: context,
              state: state,
              child: const HomePage(),
            ),
      ),
      GoRoute(
        path: RouteConstants.customerActivity,
        name: 'customerActivity',
        pageBuilder: (context, state) {
          final customer = state.extra as CustomerEntity;
          return _buildSlideTransition(
            context: context,
            state: state,
            child: CustomerActivityPage(customer: customer),
          );
        },
      ),
      GoRoute(
        path: RouteConstants.invoice,
        name: 'invoice',
        pageBuilder: (context, state) {
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
      GoRoute(
        path: RouteConstants.receiptVoucher,
        name: 'receiptVoucher',
        pageBuilder: (context, state) {
          final customer = state.extra as CustomerEntity;
          return _buildSlideTransition(
            context: context,
            state: state,
            child: ReceiptVoucherPage(customer: customer),
          );
        },
      ),
      GoRoute(
        path: RouteConstants.photoCapture,
        name: 'photoCapture',
        pageBuilder: (context, state) {
          final customer = state.extra as CustomerEntity;
          return _buildSlideTransition(
            context: context,
            state: state,
            child: PhotoCapturePage(
              customerName: customer.customerName,
              customerCode: customer.customerCode,
              customerAddress: customer.address,
            ),
          );
        },
      ),
      GoRoute(
        path: RouteConstants.settings,
        name: 'settings',
        pageBuilder:
            (context, state) => _buildSlideTransition(
              context: context,
              state: state,
              child: const SettingsPage(),
            ),
      ),
      GoRoute(
        path: RouteConstants.customerSearch,
        name: 'customerSearch',
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
      GoRoute(
        path: RouteConstants.printInvoice,
        name: 'printInvoice',
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
