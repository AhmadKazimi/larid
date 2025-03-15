import 'package:larid/features/summary/domain/entities/summary_item_entity.dart';
import 'package:larid/features/summary/domain/repositories/summary_repository.dart';

class GetInvoicesUseCase {
  final SummaryRepository repository;

  GetInvoicesUseCase({required this.repository});

  Future<List<SummaryItemEntity>> call({bool returnInvoices = false}) {
    return repository.getInvoices(returnInvoices: returnInvoices);
  }
}
