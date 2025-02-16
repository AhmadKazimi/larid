import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/dio_client.dart';
import '../network/api_service.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/api_config/data/datasources/local_datasource.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  
  // ApiConfig
  getIt.registerSingleton<ApiConfigLocalDataSource>(
    ApiConfigLocalDataSource.instance,
  );

  // Get baseUrl from database or use default
  final baseUrl = await getIt<ApiConfigLocalDataSource>().getBaseUrl() ?? 'https://api.example.com/';
  
  getIt.registerSingleton<DioClient>(
    DioClient(baseUrl: baseUrl),
  );

  // API Service
  getIt.registerSingleton<ApiService>(
    ApiService(getIt()),
  );

  // Repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      dioClient: getIt(),
      sharedPreferences: getIt(),
      apiService: getIt(),
    ),
  );

  // Use Cases
  getIt.registerFactory(() => LoginUseCase(getIt()));

  // BLoCs
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUseCase: getIt(),
    ),
  );
}

// Function to update DioClient's baseUrl
Future<void> updateDioClientBaseUrl(String newBaseUrl) async {
  final dioClient = getIt<DioClient>();
  dioClient.setBaseUrl(newBaseUrl);
  
  // Save the new baseUrl to database
  await getIt<ApiConfigLocalDataSource>().saveBaseUrl(newBaseUrl);
}
