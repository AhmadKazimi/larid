import '../../../../core/models/api_response.dart';
import '../entities/inventory/inventory_item_entity.dart';
import '../repositories/sync_repository.dart';

class SyncInventoryItemsUseCase {
  final SyncRepository _repository;

  SyncInventoryItemsUseCase(this._repository);

  Future<ApiResponse<List<InventoryItemEntity>>> call() async {
    // Get inventory items from API
    final response = await _repository.getInventoryItems();

    // If successful, save inventory items to local database
    if (response.isSuccess && response.data != null) {
      await _repository.saveInventoryItems(response.data!);
    }
  
    return response;
  }
}
