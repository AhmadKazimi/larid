
import '../../../../core/models/api_response.dart';
import '../entities/prices/prices_entity.dart';
import '../repositories/sync_repository.dart';

class SyncPricesUseCase {
  final SyncRepository _repository;

  SyncPricesUseCase(this._repository);

  Future<ApiResponse<List<PriceEntity>>> call() async {
   
    // Get prices from API
    final response = await _repository.getPrices();

    // If successful, save prices to local database
    if (response.isSuccess && response.data != null) {
      await _repository.savePrices(response.data!);
    }
    
    return response;
  }
}
