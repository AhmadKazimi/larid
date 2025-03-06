import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import '../../database/prices_table.dart';
import '../../database/sales_taxes_table.dart';
import '../../database/inventory_items_table.dart';
import '../../database/inventory_units_table.dart';
import '../../database/working_session_table.dart';
import '../../database/invoice_table.dart';
import '../../features/sync/data/repositories/sync_repository_impl.dart';
import '../../features/sync/domain/repositories/sync_repository.dart';
import '../../features/sync/domain/usecases/sync_customers_usecase.dart';
import '../../features/sync/domain/usecases/sync_sales_rep_customers_usecase.dart';
import '../../features/sync/domain/usecases/sync_prices_usecase.dart';
import '../../features/sync/domain/usecases/sync_inventory_items_usecase.dart';
import '../../features/sync/domain/usecases/sync_inventory_units_usecase.dart';
import '../../features/sync/domain/usecases/sync_sales_taxes_usecase.dart';
import '../../features/sync/presentation/bloc/sync_bloc.dart';
import '../../features/map/data/repositories/working_session_repository_impl.dart';
import '../../features/map/domain/repositories/working_session_repository.dart';
import '../../features/map/domain/usecases/check_active_session_usecase.dart';
import '../../features/map/domain/usecases/start_session_usecase.dart';
import '../../features/map/domain/usecases/end_session_usecase.dart';

final getIt = GetIt.instance;



Future<void> setupServiceLocator() async {

  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Database
  final documentsDirectory = await getApplicationDocumentsDirectory();
  final databasePath = join(documentsDirectory.path, 'larid.db');

  final database = await openDatabase(
    databasePath,
    version: 2,
    onCreate: (db, version) async {
      await db.execute(UserTable.createTableQuery);
      await db.execute(CustomerTable.createTableQuery);
      await db.execute(CustomerTable.createSalesrepCustomerTableQuery);
      await db.execute(PricesTable.createTableQuery);
      await db.execute(InventoryItemsTable.createTableQuery);
      await db.execute(InventoryUnitsTable.createTableQuery);
      await db.execute(SalesTaxesTable.createTableQuery);
      await db.execute(WorkingSessionTable.createTableQuery);
      await db.execute(InvoiceTable.createTableQuery);
      await db.execute(InvoiceTable.createInvoiceItemsTableQuery);
    },
  );

  // Database tables
  final userTable = UserTable(database);
  final customerTable = CustomerTable(database);
  final pricesTable = PricesTable(database);
  final inventoryItemsTable = InventoryItemsTable(database);
  final inventoryUnitsTable = InventoryUnitsTable(database);
  final salesTaxesTable = SalesTaxesTable(database);
  final workingSessionTable = WorkingSessionTable(database);
  final invoiceTable = InvoiceTable(database);

  getIt.registerSingleton<UserTable>(userTable);
  getIt.registerSingleton<CustomerTable>(customerTable);
  getIt.registerSingleton<PricesTable>(pricesTable);
  getIt.registerSingleton<InventoryItemsTable>(inventoryItemsTable);
  getIt.registerSingleton<InventoryUnitsTable>(inventoryUnitsTable);
  getIt.registerSingleton<SalesTaxesTable>(salesTaxesTable);
  getIt.registerSingleton<WorkingSessionTable>(workingSessionTable);
  getIt.registerSingleton<InvoiceTable>(invoiceTable);

  // Get baseUrl from database
  final baseUrl = await getIt<UserTable>().getBaseUrl();

  // Initialize network components with base URL
  await _initializeNetworkComponents(baseUrl);

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      dioClient: DioClient.instance,
      sharedPreferences: getIt(),
      apiService: getIt(),
      userTable: getIt(),
    ),
  );

  getIt.registerLazySingleton<SyncRepository>(
    () => SyncRepositoryImpl(
      apiService: getIt(),
      customerTable: getIt(),
      userTable: getIt(),
      pricesTable: getIt(),
      inventoryItemsTable: getIt(),
      inventoryUnitsTable: getIt(),
      salesTaxesTable: getIt(),
    ),
  );

  // Register working session dependencies
  getIt.registerLazySingleton<WorkingSessionRepository>(
    () => WorkingSessionRepositoryImpl(
      getIt<WorkingSessionTable>(),
      getIt<UserTable>(),
    ),
  );
  getIt.registerLazySingleton(
    () => CheckActiveSessionUseCase(getIt<WorkingSessionRepository>()),
  );
  getIt.registerLazySingleton(
    () => StartSessionUseCase(getIt<WorkingSessionRepository>()),
  );

  // Use Cases
  getIt.registerFactory(() => LoginUseCase(getIt()));
  getIt.registerFactory(() => SyncCustomersUseCase(getIt()));
  getIt.registerFactory(() => SyncSalesRepCustomersUseCase(getIt()));
  getIt.registerFactory(() => SyncPricesUseCase(getIt()));
  getIt.registerFactory(() => SyncInventoryItemsUseCase(getIt()));
  getIt.registerFactory(() => SyncInventoryUnitsUseCase(getIt()));
  getIt.registerFactory(() => SyncSalesTaxesUseCase(getIt()));
  getIt.registerFactory(() => EndSessionUseCase(getIt()));

  // BLoCs
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(loginUseCase: getIt(), prefs: getIt()),
  );

  getIt.registerFactory<SyncBloc>(
    () => SyncBloc(
      syncCustomersUseCase: getIt(),
      syncSalesRepCustomersUseCase: getIt(),
      syncPricesUseCase: getIt(),
      syncInventoryItemsUseCase: getIt(),
      syncInventoryUnitsUseCase: getIt(),
      syncSalesTaxesUseCase: getIt(),
    ),
  );
}

Future<void> _initializeNetworkComponents(String? baseUrl) async {

  try {
    // Initialize DioClient singleton with base URL
    await DioClient.initialize(baseUrl);
    
    // Register the singleton instance
    if (!getIt.isRegistered<DioClient>()) {
      getIt.registerSingleton<DioClient>(DioClient.instance);
    }

    // Create and register ApiService if not already registered
    if (!getIt.isRegistered<ApiService>()) {
      final apiService = ApiService(DioClient.instance);
      getIt.registerSingleton<ApiService>(apiService);
    }

    // Verify registrations
    final registeredBaseUrl = DioClient.instance.baseUrl;
  } catch (e) {
    rethrow;
  }
}

// Function to update DioClient's baseUrl
Future<void> updateDioClientBaseUrl(String newBaseUrl) async {

  try {
    // Update the base URL in the singleton instance
    DioClient.instance.setBaseUrl(newBaseUrl);
    
    // Verify the update
    final updatedBaseUrl = DioClient.instance.baseUrl;

    if (updatedBaseUrl != newBaseUrl) {
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
        userTable: getIt(),
      ),
    );
    
  } catch (e) {
    rethrow;
  }
}
