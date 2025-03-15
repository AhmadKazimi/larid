import 'package:larid/features/summary/domain/entities/summary_item_entity.dart';
import 'package:larid/features/summary/domain/repositories/summary_repository.dart';

class GetReceiptVouchersUseCase {
  final SummaryRepository repository;

  GetReceiptVouchersUseCase({required this.repository});

  Future<List<SummaryItemEntity>> call() {
    return repository.getReceiptVouchers();
  }
}
