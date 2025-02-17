import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';
import '../network/dio_client.dart';
import '../network/api_service.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/api_config/data/datasources/local_datasource.dart';

final getIt = GetIt.instance;
final _logger = Logger('ServiceLocator');

Future<void> setupServiceLocator() async {
  _logger.info('Setting up service locator');
  
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  
  // ApiConfig
  getIt.registerSingleton<ApiConfigLocalDataSource>(
    ApiConfigLocalDataSource(),
  );

  // Get baseUrl from database
  final baseUrl = await getIt<ApiConfigLocalDataSource>().getBaseUrl();
  _logger.info('Initial base URL from database: $baseUrl');
  
  // Initialize DioClient with base URL
  await _initializeDioClient(baseUrl);

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
      prefs: getIt(),
    ),
  );
}

Future<void> _initializeDioClient(String? baseUrl) async {
  _logger.info('Initializing DioClient with base URL: $baseUrl');
  
  // Unregister existing instances if they exist
  if (getIt.isRegistered<DioClient>()) {
    _logger.info('Unregistering existing DioClient');
    getIt.unregister<DioClient>();
  }
  
  if (getIt.isRegistered<ApiService>()) {
    _logger.info('Unregistering existing ApiService');
    getIt.unregister<ApiService>();
  }
  
  // Register new DioClient with updated base URL
  getIt.registerSingleton<DioClient>(
    DioClient(baseUrl: baseUrl ?? ''),
  );
  
  _logger.info('DioClient initialized with base URL: ${baseUrl ?? ''}');
}

// Function to update DioClient's baseUrl
Future<void> updateDioClientBaseUrl(String newBaseUrl) async {
  _logger.info('Updating base URL to: $newBaseUrl');
  
  try {
    // Save the new baseUrl to database first
    await getIt<ApiConfigLocalDataSource>().saveBaseUrl(newBaseUrl);
    _logger.info('Base URL saved to database');
    
    // Reinitialize DioClient with new base URL
    await _initializeDioClient(newBaseUrl);
    
    _logger.info('Successfully updated base URL and reinitialized DioClient');
  } catch (e) {
    _logger.severe('Error updating base URL: $e');
    rethrow;
  }
}
