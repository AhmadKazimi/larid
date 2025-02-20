import '../../../../core/models/api_response.dart';
import '../entities/inventory/inventory_unit_entity.dart';
import '../repositories/sync_repository.dart';

class SyncInventoryUnitsUseCase {
  final SyncRepository _repository;

  SyncInventoryUnitsUseCase(this._repository);


  Future<ApiResponse<List<InventoryUnitEntity>>> call() async {

  /// Get inventory units from API and save them to local database
    var response = await _repository.getInventoryUnits();

     // If successful, save Units to local database
    if (response.isSuccess && response.data != null) {
      await _repository.saveInventoryUnits(response.data!);
    }
    return response;
  }
}
