import '../../../../core/models/api_response.dart';
import '../repositories/sync_repository.dart';
import '../entities/customer_entity.dart';

class SyncCustomersUseCase {
  final SyncRepository repository;

  SyncCustomersUseCase(this.repository);

  Future<ApiResponse<List<CustomerEntity>>> call() async {
    try {
      // Get customers from API
      final response = await repository.getCustomers();
      
      // If successful, save customers to local database
      if (response.isSuccess && response.data != null) {
        await repository.saveCustomers(response.data!);
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
