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
  
  // Initialize network components with base URL
  await _initializeNetworkComponents(baseUrl);

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

Future<void> _initializeNetworkComponents(String? baseUrl) async {
  _logger.info('Initializing network components with base URL: $baseUrl');
  
  // Ensure base URL is not null or empty
  if (baseUrl == null || baseUrl.isEmpty) {
    _logger.warning('Base URL is null or empty');
    baseUrl = '';
  }

  // Unregister existing instances if they exist
  if (getIt.isRegistered<DioClient>()) {
    _logger.info('Unregistering existing DioClient');
    getIt.unregister<DioClient>();
  }
  
  if (getIt.isRegistered<ApiService>()) {
    _logger.info('Unregistering existing ApiService');
    getIt.unregister<ApiService>();
  }

  try {
    // Create and register DioClient
    final dioClient = DioClient(baseUrl: baseUrl);
    getIt.registerSingleton<DioClient>(dioClient);
    _logger.info('DioClient registered with base URL: $baseUrl');

    // Create and register ApiService
    final apiService = ApiService(dioClient);
    getIt.registerSingleton<ApiService>(apiService);
    _logger.info('ApiService registered with DioClient');

    // Verify registrations
    final registeredBaseUrl = getIt<DioClient>().baseUrl;
    _logger.info('Verified DioClient base URL: $registeredBaseUrl');
  } catch (e) {
    _logger.severe('Error initializing network components: $e');
    rethrow;
  }
}

// Function to update DioClient's baseUrl
Future<void> updateDioClientBaseUrl(String newBaseUrl) async {
  _logger.info('Updating base URL to: $newBaseUrl');
  
  try {
    // Save the new baseUrl to database first
    await getIt<ApiConfigLocalDataSource>().saveBaseUrl(newBaseUrl);
    _logger.info('Base URL saved to database');
    
    // Reinitialize all network components with new base URL
    await _initializeNetworkComponents(newBaseUrl);
    
    // Verify the update
    final updatedBaseUrl = getIt<DioClient>().baseUrl;
    _logger.info('Verified updated base URL: $updatedBaseUrl');
    
    if (updatedBaseUrl != newBaseUrl) {
      _logger.severe('Base URL mismatch after update. Expected: $newBaseUrl, Got: $updatedBaseUrl');
      throw Exception('Base URL update verification failed');
    }
    
    // Unregister and re-register AuthRepository so it uses the updated network components
if (getIt.isRegistered<AuthRepository>()) {
  _logger.info('Unregistering existing AuthRepository to update dependencies');
  getIt.unregister<AuthRepository>();
}
getIt.registerSingleton<AuthRepository>(
  AuthRepositoryImpl(
    dioClient: getIt<DioClient>(),
    sharedPreferences: getIt<SharedPreferences>(),
    apiService: getIt<ApiService>(),
  ),
);
    _logger.info('Successfully updated base URL and reinitialized network components');
  } catch (e) {
    _logger.severe('Error updating base URL: $e');
    rethrow;
  }
}
