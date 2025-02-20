import 'dart:convert';
import 'dart:developer' as dev;
import 'package:larid/core/network/api_service.dart';
import 'package:larid/database/customer_table.dart';
import 'package:larid/database/prices_table.dart';
import 'package:larid/database/user_table.dart';
import 'package:larid/features/auth/domain/entities/user_entity.dart';
import 'package:larid/features/sync/domain/entities/customer_entity.dart';
import 'package:larid/features/sync/domain/entities/prices/prices_entity.dart';
import 'package:larid/core/models/api_response.dart';
import '../../../sync/domain/repositories/sync_repository.dart';

class SyncRepositoryImpl implements SyncRepository {
  final ApiService _apiService;
  final CustomerTable _customerTable;
  final UserTable _userTable;
  final PricesTable _pricesTable;
  UserEntity? _user;
  Future<void>? _initUserFuture;

  SyncRepositoryImpl({
    required ApiService apiService,
    required CustomerTable customerTable,
    required UserTable userTable,
    required PricesTable pricesTable,
  })  : _apiService = apiService,
        _customerTable = customerTable,
        _userTable = userTable,
        _pricesTable = pricesTable {
    // Initialize user immediately and store the future
    _initUserFuture = _initUser();
  }

  Future<void> _initUser() async {
    try {
      _user = await _userTable.getCurrentUser();
      dev.log('Initialized user: ${_user?.userid}');
    } catch (e) {
      dev.log('Error initializing user: $e');
    }
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
      await _ensureUserInitialized();
      if (_user == null) {
        return ApiResponse(
          errorCode: '-1',
          message: 'User not found',
        );
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
      
      final customers = customersData
          .map((json) => CustomerEntity.fromJson(json))
          .toList();
      
      return ApiResponse(data: customers);
    } catch (e) {
      return ApiResponse(
        errorCode: '-1',
        message: e.toString(),
      );
    }
  }

  @override
  Future<void> saveCustomers(List<CustomerEntity> customers) async {
    await _customerTable.createOrUpdateCustomers(customers);
  }
  
  @override
  Future<ApiResponse<List<CustomerEntity>>> getSalesrepRouteCustomers() async {
    try {
      await _ensureUserInitialized();
      if (_user == null) {
        return ApiResponse(
          errorCode: '-1',
          message: 'User not found',
        );
      }

      final salesrepRouteCustomersData = await _apiService.getSalesrepRouteCustomers(
        userid: _user!.userid,
        workspace: _user!.workspace,
        password: _user!.password,
      );

      // Check if the response contains an error code
      if (salesrepRouteCustomersData.isNotEmpty && salesrepRouteCustomersData[0] is Map) {
        final firstItem = salesrepRouteCustomersData[0];
        if (firstItem.containsKey('ERROR')) {
          return ApiResponse(
            errorCode: firstItem['ERROR']?.toString(),
            message: 'Error occurred during sync',
          );
        }
      }
      
      final customers = salesrepRouteCustomersData
          .map((json) => CustomerEntity.fromJson(json))
          .toList();
      
      return ApiResponse(data: customers);
    } catch (e) {
      return ApiResponse(
        errorCode: '-1',
        message: e.toString(),
      );
    }
  }
  
  @override
  Future<void> saveSalesrepRouteCustomers(List<CustomerEntity> customers) async {
    await _customerTable.createOrUpdateSalesRepCustomers(customers);
  }

  @override
  Future<ApiResponse<List<PriceEntity>>> getPrices() async {
    try {
      await _ensureUserInitialized();
      if (_user == null) {
        return ApiResponse(
          errorCode: '-1',
          message: 'User not found',
        );
      }

      final pricesData = await _apiService.getCustomersPriceList(
        userid: _user!.userid,
        workspace: _user!.workspace,
        password: _user!.password,
      );

      // Check if the response contains an error code
      if (pricesData.isNotEmpty && pricesData[0] is Map) {
        final firstItem = pricesData[0];
        if (firstItem.containsKey('ERROR')) {
          return ApiResponse(
            errorCode: firstItem['ERROR']?.toString(),
            message: 'Error occurred during sync',
          );
        }
      }
      
      final prices = pricesData
          .map((json) => PriceEntity.fromJson(json))
          .toList();

      return ApiResponse(
        data: prices,
      );
    } catch (e) {
      return ApiResponse(
        errorCode: '-1',
        message: e.toString(),
      );
    }
  }

  @override
  Future<void> savePrices(List<PriceEntity> prices) async {
    await _pricesTable.createOrUpdatePrices(prices);
  }
}
