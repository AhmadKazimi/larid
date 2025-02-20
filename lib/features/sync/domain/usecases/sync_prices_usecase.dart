import '../../../../core/models/api_response.dart';
import '../entities/prices/prices_entity.dart';
import '../repositories/sync_repository.dart';

class SyncPricesUseCase {
  final SyncRepository _repository;

  SyncPricesUseCase(this._repository);

  Future<ApiResponse<List<PriceEntity>>> call() async {
    final prices = await _repository.getPrices();
    if (prices.isSuccess && prices.data != null) {
      await _repository.savePrices(prices.data!);
    }
    return prices;
  }
}
