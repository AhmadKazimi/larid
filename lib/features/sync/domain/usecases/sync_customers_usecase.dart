import '../entities/customer_entity.dart';
import '../repositories/sync_repository.dart';

class SyncCustomersUseCase {
  final SyncRepository _repository;

  SyncCustomersUseCase(this._repository);

  Future<List<CustomerEntity>> call({
    required String userid,
    required String workspace,
    required String password,
  }) async {
    final customers = await _repository.getCustomers(
      userid: userid,
      workspace: workspace,
      password: password,
    );
    
    await _repository.saveCustomers(customers);
    return customers;
  }
}
