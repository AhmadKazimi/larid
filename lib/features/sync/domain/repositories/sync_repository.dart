import '../entities/customer_entity.dart';

abstract class SyncRepository {
  Future<List<CustomerEntity>> getCustomers();
  
  Future<void> saveCustomers(List<CustomerEntity> customers);
}
