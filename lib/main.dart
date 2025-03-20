import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:larid/core/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larid/core/router/app_router.dart';
import 'package:larid/core/storage/shared_prefs.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:larid/features/api_config/data/repositories/api_config_repository_impl.dart';
import 'package:larid/features/api_config/presentation/bloc/api_config_bloc.dart';
import 'package:larid/features/sync/domain/usecases/sync_customers_usecase.dart';
import 'package:larid/features/sync/domain/usecases/sync_sales_rep_customers_usecase.dart';
import 'package:larid/features/sync/domain/usecases/sync_inventory_items_usecase.dart';
import 'package:larid/features/sync/domain/usecases/sync_inventory_units_usecase.dart';
import 'package:larid/features/sync/domain/usecases/sync_sales_taxes_usecase.dart';
import 'package:larid/features/sync/domain/usecases/sync_prices_usecase.dart';
import 'package:larid/features/sync/presentation/bloc/sync_bloc.dart';
import 'package:larid/features/sync/domain/usecases/sync_user_warehouse_usecase.dart';
import 'core/di/service_locator.dart';
import 'core/l10n/l10n.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'database/user_table.dart';
import 'features/sync/domain/usecases/sync_company_info_usecase.dart';

// This is a singleton that handles app restart
class AppRestartController {
  static final AppRestartController _instance = AppRestartController._internal();
  
  factory AppRestartController() => _instance;
  
  AppRestartController._internal();
  
  final restartNotifier = ValueNotifier<bool>(false);
  
  void restartApp() {
    restartNotifier.value = !restartNotifier.value;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  await SharedPrefs.init();

  // Initialize permission handler
  await Permission.camera.status;

  runApp(RestartWidget(child: const AppRoot()));
}

// Widget that can restart the app
class RestartWidget extends StatefulWidget {
  final Widget child;
  
  const RestartWidget({Key? key, required this.child}) : super(key: key);

  @override
  RestartWidgetState createState() => RestartWidgetState();
  
  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<RestartWidgetState>()?.restartApp();
  }
}

class RestartWidgetState extends State<RestartWidget> {
  Key _childKey = UniqueKey();

  void restartApp() {
    setState(() {
      _childKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _childKey,
      child: widget.child,
    );
  }
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    // Get saved language from SharedPrefs
    final String languageCode = SharedPrefs.getLanguage() ?? 'ar';
    final Locale locale = Locale(languageCode);
    
    // Determine text direction based on language
    final TextDirection textDirection = languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;
    
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => getIt<AuthBloc>()),
        BlocProvider<ApiConfigBloc>(
          create:
              (context) => ApiConfigBloc(
                repository: ApiConfigRepositoryImpl(userDB: getIt<UserTable>()),
              )..add(const ApiConfigEvent.checkBaseUrl()),
        ),
        BlocProvider<SyncBloc>(
          create:
              (context) => SyncBloc(
                syncCustomersUseCase: getIt<SyncCustomersUseCase>(),
                syncSalesRepCustomersUseCase:
                    getIt<SyncSalesRepCustomersUseCase>(),
                syncPricesUseCase: getIt<SyncPricesUseCase>(),
                syncInventoryItemsUseCase: getIt<SyncInventoryItemsUseCase>(),
                syncInventoryUnitsUseCase: getIt<SyncInventoryUnitsUseCase>(),
                syncSalesTaxesUseCase: getIt<SyncSalesTaxesUseCase>(),
                syncUserWarehouseUseCase: getIt<SyncUserWarehouseUseCase>(),
                syncCompanyInfoUseCase: getIt<SyncCompanyInfoUseCase>(),
              ),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Larid',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.lightTheme,
        locale: locale,
        supportedLocales: L10n.all,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routerConfig: AppRouter.router,
        builder: (context, child) {
          return Directionality(
            textDirection: textDirection,
            child: child!,
          );
        },
      ),
    );
  }
}
