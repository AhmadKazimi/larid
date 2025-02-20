import 'dart:convert';
import 'package:larid/core/network/api_service.dart';
import 'package:larid/database/customer_table.dart';
import 'package:larid/database/user_table.dart';
import '../../../../core/models/api_response.dart';
import '../../domain/entities/customer_entity.dart';
import '../../domain/repositories/sync_repository.dart';

class SyncRepositoryImpl implements SyncRepository {
  final ApiService _apiService;
  final CustomerTable _customerDB;
  final UserTable _userDB;

  SyncRepositoryImpl({
    required ApiService apiService,
    required CustomerTable customerDB,
    required UserTable userDB,
  })  : _apiService = apiService,
        _customerDB = customerDB,
        _userDB = userDB;

  @override
  Future<ApiResponse<List<CustomerEntity>>> getCustomers() async {
    try {
      final user = await _userDB.getCurrentUser();
      if (user == null) {
        return ApiResponse(
          errorCode: '-1',
          message: 'User not found',
        );
      }

      final customersData = await _apiService.getCustomers(
        userid: user.userid,
        workspace: user.workspace,
        password: user.password,
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
        errorCode: '-9000',
        message: e.toString(),
      );
    }
  }

  @override
  Future<void> saveCustomers(List<CustomerEntity> customers) async {
    await _customerDB.createOrUpdateCustomers(customers);
  }
  
  @override
  Future<ApiResponse<List<CustomerEntity>>> getSalesrepRouteCustomers() async {
    try {
      final user = await _userDB.getCurrentUser();
      if (user == null) {
        return ApiResponse(
          errorCode: '-1',
          message: 'User not found',
        );
      }

      final salesrepRouteCustomersData = await _apiService.getSalesrepRouteCustomers(
        userid: user.userid,
        workspace: user.workspace,
        password: user.password,
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
        errorCode: '-9000',
        message: e.toString(),
      );
    }
  }
  
  @override
  Future<void> saveSalesrepRouteCustomers(List<CustomerEntity> customers) async {
    await _customerDB.createOrUpdateSalesRepCustomers(customers);
  }
}
