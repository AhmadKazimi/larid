import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:larid/core/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larid/features/api_config/data/datasources/local_datasource.dart';
import 'package:larid/features/api_config/data/repositories/api_config_repository_impl.dart';
import 'package:larid/features/api_config/presentation/bloc/api_config_bloc.dart';
import 'package:larid/features/api_config/presentation/pages/api_base_url_page.dart';
import 'package:larid/features/auth/presentation/pages/login_page.dart';
import 'core/di/service_locator.dart';
import 'core/l10n/l10n.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => getIt<AuthBloc>(),
        ),
        BlocProvider<ApiConfigBloc>(
          create: (context) => ApiConfigBloc(
            repository: ApiConfigRepositoryImpl(
              localDataSource: ApiConfigLocalDataSource.instance,
            ),
          )..add(const ApiConfigEvent.checkBaseUrl()),
        ),
      ],
      child: MaterialApp(
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
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
        home: BlocBuilder<ApiConfigBloc, ApiConfigState>(
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              exists: (_) => const LoginPage(),
              saved: () => const LoginPage(),
              orElse: () => const ApiBaseUrlPage(),
            );
          },
        ),
      ),
    );
  }
}
