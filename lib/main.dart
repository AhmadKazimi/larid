import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:larid/core/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larid/core/router/app_router.dart';
import 'package:larid/core/storage/shared_prefs.dart';
import 'package:larid/features/api_config/data/repositories/api_config_repository_impl.dart';
import 'package:larid/features/api_config/presentation/bloc/api_config_bloc.dart';
import 'package:larid/features/sync/domain/usecases/sync_customers_usecase.dart';
import 'package:larid/features/sync/presentation/bloc/sync_bloc.dart';
import 'core/di/service_locator.dart';
import 'core/l10n/l10n.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'database/user_db.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  await SharedPrefs.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => getIt<AuthBloc>()),
        BlocProvider<ApiConfigBloc>(
          create:
              (context) => ApiConfigBloc(
                repository: ApiConfigRepositoryImpl(
                  userDB: getIt<UserDB>(),
                ),
              )..add(const ApiConfigEvent.checkBaseUrl()),
        ),
        BlocProvider<SyncBloc>(
          create: (context) => SyncBloc(
            syncCustomersUseCase: getIt<SyncCustomersUseCase>(),
          ),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Larid',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.lightTheme,
        locale: L10n.defaultLocale,
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
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
      ),
    );
  }
}
