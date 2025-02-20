import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../network/api_client.dart';
import '../network/api_service.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../database/user_table.dart';
import '../../database/customer_table.dart';
import '../../features/sync/data/repositories/sync_repository_impl.dart';
import '../../features/sync/domain/repositories/sync_repository.dart';
import '../../features/sync/domain/usecases/sync_customers_usecase.dart';
import '../../features/sync/presentation/bloc/sync_bloc.dart';
import '../../features/sync/domain/usecases/sync_sales_rep_customers_usecase.dart';

final getIt = GetIt.instance;
final _logger = Logger('ServiceLocator');

// Setup logger once
void _setupLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
}

Future<void> setupServiceLocator() async {
  _setupLogger();
  _logger.info('Setting up service locator');

  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Database
  final documentsDirectory = await getApplicationDocumentsDirectory();
  final databasePath = join(documentsDirectory.path, 'larid.db');
  _logger.info('Initializing database at path: $databasePath');

  final database = await openDatabase(
    databasePath,
    version: 1,
    onCreate: (db, version) async {
      _logger.info('Creating database tables for version $version');
      await db.execute(UserTable.createTableQuery);
      await db.execute(CustomerTable.createTableQuery);
      await db.execute(CustomerTable.createSalesrepCustomerTableQuery);

    },
  );

  getIt.registerSingleton<Database>(database);
  getIt.registerSingleton<UserTable>(UserTable(database));
  getIt.registerSingleton<CustomerTable>(CustomerTable(getIt()));

  // Get baseUrl from database
  final baseUrl = await getIt<UserTable>().getBaseUrl();
  _logger.info('Initial base URL from database: $baseUrl');

  // Initialize network components with base URL
  await _initializeNetworkComponents(baseUrl);

  // Repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      dioClient: DioClient.instance,
      sharedPreferences: getIt(),
      apiService: getIt(),
      userDB: getIt(),
    ),
  );

  // Use Cases
  getIt.registerFactory(() => LoginUseCase(getIt()));
  getIt.registerFactory(() => SyncCustomersUseCase(getIt()));
  getIt.registerFactory(() => SyncSalesRepCustomersUseCase(getIt()));

  // Repositories
  getIt.registerSingleton<SyncRepository>(
    SyncRepositoryImpl(
      apiService: getIt(),
      customerDB: getIt(),
      userDB: getIt(),
    ),
  );

  // BLoCs
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(loginUseCase: getIt(), prefs: getIt()),
  );

  getIt.registerFactory<SyncBloc>(
    () => SyncBloc(syncCustomersUseCase: getIt(), syncSalesRepCustomersUseCase: getIt()),
  );
}

Future<void> _initializeNetworkComponents(String? baseUrl) async {
  _logger.info('Initializing network components with base URL: $baseUrl');

  try {
    // Initialize DioClient singleton with base URL
    await DioClient.initialize(baseUrl);
    
    // Register the singleton instance
    if (!getIt.isRegistered<DioClient>()) {
      getIt.registerSingleton<DioClient>(DioClient.instance);
      _logger.info('DioClient registered');
    }

    // Create and register ApiService if not already registered
    if (!getIt.isRegistered<ApiService>()) {
      final apiService = ApiService(DioClient.instance);
      getIt.registerSingleton<ApiService>(apiService);
      _logger.info('ApiService registered with DioClient');
    }

    // Verify registrations
    final registeredBaseUrl = DioClient.instance.baseUrl;
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
    // Update the base URL in the singleton instance
    DioClient.instance.setBaseUrl(newBaseUrl);
    
    // Verify the update
    final updatedBaseUrl = DioClient.instance.baseUrl;
    _logger.info('Verified updated base URL: $updatedBaseUrl');

    if (updatedBaseUrl != newBaseUrl) {
      _logger.severe(
        'Base URL mismatch after update. Expected: $newBaseUrl, Got: $updatedBaseUrl',
      );
      throw Exception('Base URL update verification failed');
    }

    // Create new ApiService instance with updated DioClient
    getIt.unregister<ApiService>();
    getIt.registerSingleton<ApiService>(ApiService(DioClient.instance));

    // Update AuthRepository with new dependencies
    getIt.unregister<AuthRepository>();
    getIt.registerSingleton<AuthRepository>(
      AuthRepositoryImpl(
        dioClient: DioClient.instance,
        sharedPreferences: getIt(),
        apiService: getIt(),
        userDB: getIt(),
      ),
    );
    
    _logger.info('Successfully updated base URL and reinitialized network components');
  } catch (e) {
    _logger.severe('Error updating base URL: $e');
    rethrow;
  }
}
