import '../entities/customer_entity.dart';
import '../repositories/sync_repository.dart';

class SyncCustomersUseCase {
  final SyncRepository _repository;

  SyncCustomersUseCase(this._repository);

  Future<List<CustomerEntity>> call() async {
    final customers = await _repository.getCustomers();
    
    await _repository.saveCustomers(customers);
    return customers;
  }
}
