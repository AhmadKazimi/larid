import 'dart:developer' as dev;
import 'package:larid/core/network/api_service.dart';
import 'package:larid/database/customer_table.dart';
import 'package:larid/database/inventory_items_table.dart';
import 'package:larid/database/inventory_units_table.dart';
import 'package:larid/database/prices_table.dart';
import 'package:larid/database/sales_taxes_table.dart';
import 'package:larid/database/user_table.dart';

import 'package:larid/features/auth/domain/entities/user_entity.dart';
import 'package:larid/features/sync/domain/entities/customer_entity.dart';
import 'package:larid/features/sync/domain/entities/inventory/inventory_item_entity.dart';
import 'package:larid/features/sync/domain/entities/inventory/inventory_unit_entity.dart';
import 'package:larid/features/sync/domain/entities/prices/prices_entity.dart';
import 'package:larid/features/sync/domain/entities/sales_tax_entity.dart';

import 'package:larid/core/models/api_response.dart';
import '../../../sync/domain/repositories/sync_repository.dart';

class SyncRepositoryImpl implements SyncRepository {
  final ApiService _apiService;
  final CustomerTable _customerTable;
  final UserTable _userTable;
  final PricesTable _pricesTable;
  final InventoryItemsTable _inventoryItemsTable;
  final InventoryUnitsTable _inventoryUnitsTable;
  final SalesTaxesTable _salesTaxesTable;
  UserEntity? _user;

  SyncRepositoryImpl({
    required ApiService apiService,
    required CustomerTable customerTable,
    required UserTable userTable,
    required PricesTable pricesTable,
    required InventoryItemsTable inventoryItemsTable,
    required InventoryUnitsTable inventoryUnitsTable,
    required SalesTaxesTable salesTaxesTable,
  }) : _apiService = apiService,
       _customerTable = customerTable,
       _userTable = userTable,
       _pricesTable = pricesTable,
       _inventoryItemsTable = inventoryItemsTable,
       _inventoryUnitsTable = inventoryUnitsTable,
       _salesTaxesTable = salesTaxesTable {
    // Initialize user when repository is created
    _initUser().then((_) {
      if (_user != null) {
        dev.log('User initialized on repository creation: ${_user!.userid}');
      } else {
        dev.log('Failed to initialize user on repository creation');
      }
    });
  }

  Future<void> _initUser() async {
    try {
      if (_user != null) {
        dev.log('User already initialized: ${_user!.userid}');
        return;
      }
      
      _user = await _userTable.getCurrentUser();
      if (_user == null) {
        dev.log('No user found in database during initialization');
      } else {
        dev.log('Successfully initialized user: ${_user!.userid}');
      }
    } catch (e) {
      dev.log('Error initializing user: $e');
      _user = null;
    }
  }


  @override
  Future<ApiResponse<List<CustomerEntity>>> getCustomers() async {
    try {
      if (_user == null) {
        dev.log('User not found in database - cannot sync customers');
        return ApiResponse(errorCode: '-1', message: 'Please login again to sync customers');
      }

      final customersData = await _apiService.getCustomers(
        userid: _user!.userid,
        workspace: _user!.workspace,
        password: _user!.password,
      );

      // Check if the response contains an error code
      if (customersData.isNotEmpty) {
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
        dev.log('User not found in database - cannot sync sales rep customers');
        return ApiResponse(errorCode: '-1', message: 'Please login again to sync sales rep customers');
      }

      final customersData = await _apiService.getSalesrepRouteCustomers(
        userid: _user!.userid,
        workspace: _user!.workspace,
        password: _user!.password,
      );

      // Check if the response contains an error code
      if (customersData.isNotEmpty) {
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
        dev.log('User not found in database - cannot sync prices');
        return ApiResponse(errorCode: '-1', message: 'Please login again to sync prices');
      }

      final customersData = await _apiService.getCustomersPriceList(
        userid: _user!.userid,
        workspace: _user!.workspace,
        password: _user!.password,
      );

      // Check if the response contains an error code
      if (customersData.isNotEmpty) {
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
        dev.log('User not found in database - cannot sync inventory items');
        return ApiResponse(errorCode: '-1', message: 'Please login again to sync inventory items');
      }

      final customersData = await _apiService.getInventoryItems(
        userid: _user!.userid,
        workspace: _user!.workspace,
        password: _user!.password,
      );

      // Check if the response contains an error code
      if (customersData.isNotEmpty) {
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
      if (response.isNotEmpty) {
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

  @override
  Future<ApiResponse<List<SalesTaxEntity>>> getSalesTaxes() async {
    try {
      if (_user == null) {
        dev.log('User not found in database - cannot sync sales taxes');
        return ApiResponse(errorCode: '-1', message: 'Please login again to sync sales taxes');
      }

      dev.log('Getting sales taxes for user: ${_user!.userid}');
      final response = await _apiService.getSalesTaxes(
        userid: _user!.userid,
        workspace: _user!.workspace,
        password: _user!.password,
      );

      if (response.isEmpty) {
        dev.log('No sales taxes returned from API');
        return ApiResponse(data: []);
      }

      // Check if the response contains an error code
      final firstItem = response[0];
      if (firstItem.containsKey('ERROR')) {
        final errorMsg = firstItem['ERROR']?.toString() ?? 'Unknown error';
        dev.log('API returned error: $errorMsg');
        return ApiResponse(
          errorCode: '-1',
          message: 'Failed to get sales taxes: $errorMsg',
        );
      }
    
      dev.log('Raw API response: $response');
      final taxes = response.map((json) {
        try {
          return SalesTaxEntity.fromJson(json);
        } catch (e) {
          dev.log('Error parsing sales tax item: $e, JSON: $json');
          return null;
        }
      })
      .whereType<SalesTaxEntity>() // Filter out null items
      .toList();

      dev.log('Successfully parsed ${taxes.length} sales taxes from API');
      
      if (taxes.isEmpty) {
        return ApiResponse(
          errorCode: '-1',
          message: 'No valid sales taxes data received from API',
        );
      }

      try {
        await _salesTaxesTable.createOrUpdateTaxes(taxes);
        dev.log('Successfully saved sales taxes to database');
      } catch (dbError) {
        dev.log('Error saving sales taxes to database: $dbError');
        // Continue even if save fails - at least return the API data
      }

      return ApiResponse(data: taxes);
    } catch (e, stackTrace) {
      dev.log('Error in getSalesTaxes: $e\n$stackTrace');
      return ApiResponse(
        errorCode: '-1',
        message: 'Failed to sync sales taxes: $e',
      );
    }
  }

  @override
  Future<void> saveSalesTaxes(List<SalesTaxEntity> taxes) async {
    await _salesTaxesTable.createOrUpdateTaxes(taxes);
  }
}
