import '../../../../core/models/api_response.dart';
import '../repositories/sync_repository.dart';
import '../entities/warehouse/warehouse_entity.dart';
import '../../../../core/di/service_locator.dart';

class SyncUserWarehouseUseCase {
  final SyncRepository repository;

  SyncUserWarehouseUseCase(this.repository);

  Future<ApiResponse<List<WarehouseEntity>>> call() async {
    try {
      // Get warehouse info from API
      final response = await repository.getUserWarehouse();

      // If successful, save warehouse and currency to database
      if (response.isSuccess &&
          response.data != null &&
          response.data!.isNotEmpty) {
        final warehouse = response.data!.first.warehouse;
        final currency = response.data!.first.currency;

        await repository.saveUserWarehouse(warehouse, currency);

        // Update warehouse in ApiService
        await updateWarehouseInApiService();
      }

      return response;
    } catch (e) {
      return ApiResponse(errorCode: '-9000', message: e.toString());
    }
  }
}
