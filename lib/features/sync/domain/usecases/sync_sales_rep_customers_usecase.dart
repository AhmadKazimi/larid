import '../../../../core/models/api_response.dart';
import '../repositories/sync_repository.dart';
import '../entities/customer_entity.dart';

class SyncSalesRepCustomersUseCase {
  final SyncRepository repository;

  SyncSalesRepCustomersUseCase(this.repository);

  Future<ApiResponse<List<CustomerEntity>>> call() async {
    try {
      // Get sales rep customers from API
      final response = await repository.getSalesrepRouteCustomers();
      
      // If successful, save customers to local database
      if (response.isSuccess && response.data != null) {
        await repository.saveSalesrepRouteCustomers(response.data!);
      }
      
      return response;
    } catch (e) {
      return ApiResponse(
        errorCode: '-9000',
        message: e.toString(),
      );
    }
  }
}
