import 'dart:convert';
import 'dart:developer' as dev;
import 'package:larid/core/network/api_service.dart';
import 'package:larid/database/customer_table.dart';
import 'package:larid/database/inventory_items_table.dart';
import 'package:larid/database/inventory_units_table.dart';
import 'package:larid/database/prices_table.dart';
import 'package:larid/database/user_table.dart';
import 'package:larid/features/auth/domain/entities/user_entity.dart';
import 'package:larid/features/sync/domain/entities/customer_entity.dart';
import 'package:larid/features/sync/domain/entities/inventory/inventory_item_entity.dart';
import 'package:larid/features/sync/domain/entities/inventory/inventory_unit_entity.dart';
import 'package:larid/features/sync/domain/entities/prices/prices_entity.dart';
import 'package:larid/core/models/api_response.dart';
import '../../../sync/domain/repositories/sync_repository.dart';

class SyncRepositoryImpl implements SyncRepository {
  final ApiService _apiService;
  final CustomerTable _customerTable;
  final UserTable _userTable;
  final PricesTable _pricesTable;
  final InventoryItemsTable _inventoryItemsTable;
  final InventoryUnitsTable _inventoryUnitsTable;
  UserEntity? _user;
  Future<void>? _initUserFuture;

  SyncRepositoryImpl({
    required ApiService apiService,
    required CustomerTable customerTable,
    required UserTable userTable,
    required PricesTable pricesTable,
    required InventoryItemsTable inventoryItemsTable,
    required InventoryUnitsTable inventoryUnitsTable,
  }) : _apiService = apiService,
       _customerTable = customerTable,
       _userTable = userTable,
       _pricesTable = pricesTable,
       _inventoryItemsTable = inventoryItemsTable,
       _inventoryUnitsTable = inventoryUnitsTable {
    _initUserFuture = _initUser();
  }

  Future<void> _initUser() async {
    try {
      _user = await _userTable.getCurrentUser();
    } catch (e) {
      dev.log('Error initializing user: $e');
    }

    await _ensureUserInitialized();
  }

  Future<void> _ensureUserInitialized() async {
    if (_initUserFuture != null) {
      await _initUserFuture;
      _initUserFuture = null;
    }
  }

  @override
  Future<ApiResponse<List<CustomerEntity>>> getCustomers() async {
    try {
      if (_user == null) {
        return ApiResponse(errorCode: '-1', message: 'User not found');
      }

      final customersData = await _apiService.getCustomers(
        userid: _user!.userid,
        workspace: _user!.workspace,
        password: _user!.password,
      );

      // Check if the response contains an error code
      if (customersData.isNotEmpty && customersData[0] is Map) {
        final firstItem = customersData[0];
        if (firstItem.containsKey('ERROR')) {
          return ApiResponse(
            errorCode: firstItem['ERROR']?.toString(),
            message: 'Error occurred during sync',
          );
        }
      }

      final customers =
          customersData.map((json) => CustomerEntity.fromJson(json)).toList();

      return ApiResponse(data: customers);
    } catch (e) {
      return ApiResponse(errorCode: '-1', message: e.toString());
    }
  }

  @override
  Future<void> saveCustomers(List<CustomerEntity> customers) async {
    await _customerTable.createOrUpdateCustomers(customers);
  }

  @override
  Future<ApiResponse<List<CustomerEntity>>> getSalesrepRouteCustomers() async {
    try {
      if (_user == null) {
        return ApiResponse(errorCode: '-1', message: 'User not found');
      }

      final customersData = await _apiService.getSalesrepRouteCustomers(
        userid: _user!.userid,
        workspace: _user!.workspace,
        password: _user!.password,
      );

      // Check if the response contains an error code
      if (customersData.isNotEmpty && customersData[0] is Map) {
        final firstItem = customersData[0];
        if (firstItem.containsKey('ERROR')) {
          return ApiResponse(
            errorCode: firstItem['ERROR']?.toString(),
            message: 'Error occurred during sync',
          );
        }
      }

      final customers =
          customersData.map((json) => CustomerEntity.fromJson(json)).toList();

      return ApiResponse(data: customers);
    } catch (e) {
      return ApiResponse(errorCode: '-1', message: e.toString());
    }
  }

  @override
  Future<void> saveSalesrepRouteCustomers(
    List<CustomerEntity> customers,
  ) async {
    await _customerTable.createOrUpdateSalesRepCustomers(customers);
  }

  @override
  Future<ApiResponse<List<PriceEntity>>> getPrices() async {
    try {
      if (_user == null) {
        return ApiResponse(errorCode: '-1', message: 'User not found');
      }

      final customersData = await _apiService.getCustomersPriceList(
        userid: _user!.userid,
        workspace: _user!.workspace,
        password: _user!.password,
      );

      // Check if the response contains an error code
      if (customersData.isNotEmpty && customersData[0] is Map) {
        final firstItem = customersData[0];
        if (firstItem.containsKey('ERROR')) {
          return ApiResponse(
            errorCode: firstItem['ERROR']?.toString(),
            message: 'Error occurred during sync',
          );
        }
      }

      final prices =
          customersData.map((json) => PriceEntity.fromJson(json)).toList();

      return ApiResponse(data: prices);
    } catch (e) {
      return ApiResponse(errorCode: '-1', message: e.toString());
    }
  }

  @override
  Future<void> savePrices(List<PriceEntity> prices) async {
    await _pricesTable.createOrUpdatePrices(prices);
  }

  @override
  Future<ApiResponse<List<InventoryItemEntity>>> getInventoryItems() async {
    try {
      if (_user == null) {
        return ApiResponse(errorCode: '-1', message: 'User not found');
      }

      final customersData = await _apiService.getInventoryItems(
        userid: _user!.userid,
        workspace: _user!.workspace,
        password: _user!.password,
      );

      // Check if the response contains an error code
      if (customersData.isNotEmpty && customersData[0] is Map) {
        final firstItem = customersData[0];
        if (firstItem.containsKey('ERROR')) {
          return ApiResponse(
            errorCode: firstItem['ERROR']?.toString(),
            message: 'Error occurred during sync',
          );
        }
      }

      final items =
          customersData
              .map((json) => InventoryItemEntity.fromJson(json))
              .toList();

      return ApiResponse(data: items);
    } catch (e) {
      return ApiResponse(errorCode: '-1', message: e.toString());
    }
  }

  @override
  Future<void> saveInventoryItems(List<InventoryItemEntity> items) async {
    await _inventoryItemsTable.createOrUpdateItems(items);
  }

  @override
  Future<ApiResponse<List<InventoryUnitEntity>>> getInventoryUnits() async {
    if (_user == null) {
      return ApiResponse(errorCode: '-1', message: 'User not found');
    }

    try {
      final response = await _apiService.getInventoryUnits(
        userid: _user!.userid,
        workspace: _user!.workspace,
        password: _user!.password,
      );

      // Check if the response contains an error code
      if (response.isNotEmpty && response[0] is Map) {
        final firstItem = response[0];
        if (firstItem.containsKey('ERROR')) {
          return ApiResponse(
            errorCode: firstItem['ERROR']?.toString(),
            message: 'Error occurred during sync',
          );
        }
      }

      final units =
          response.map((json) => InventoryUnitEntity.fromJson(json)).toList();

      return ApiResponse(data: units);
    } catch (e) {
      return ApiResponse(errorCode: '-1', message: e.toString());
    }
  }

  @override
  Future<void> saveInventoryUnits(List<InventoryUnitEntity> units) async {
    await _inventoryUnitsTable.createOrUpdateUnits(units);
  }
}
