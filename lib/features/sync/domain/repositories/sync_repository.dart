import '../entities/customer_entity.dart';

abstract class SyncRepository {
  Future<List<CustomerEntity>> getCustomers({
    required String userid,
    required String workspace,
    required String password,
  });
  
  Future<void> saveCustomers(List<CustomerEntity> customers);
}
