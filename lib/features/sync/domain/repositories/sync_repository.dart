import '../entities/customer_entity.dart';
import '../../../../core/models/api_response.dart';

abstract class SyncRepository {
  Future<ApiResponse<List<CustomerEntity>>> getCustomers();
  
  Future<void> saveCustomers(List<CustomerEntity> customers);

  Future<ApiResponse<List<CustomerEntity>>> getSalesrepRouteCustomers();
  
  Future<void> saveSalesrepRouteCustomers(List<CustomerEntity> customers);
}
