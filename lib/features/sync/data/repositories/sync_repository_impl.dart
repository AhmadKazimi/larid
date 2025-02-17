import 'package:larid/core/network/api_service.dart';
import 'package:larid/database/customer_db.dart';
import '../../domain/entities/customer_entity.dart';
import '../../domain/repositories/sync_repository.dart';

class SyncRepositoryImpl implements SyncRepository {
  final ApiService _apiService;
  final CustomerDB _customerDB;

  SyncRepositoryImpl({
    required ApiService apiService,
    required CustomerDB customerDB,
  })  : _apiService = apiService,
        _customerDB = customerDB;

  @override
  Future<List<CustomerEntity>> getCustomers({
    required String userid,
    required String workspace,
    required String password,
  }) async {
    final customersData = await _apiService.getCustomers(
      userid: userid,
      workspace: workspace,
      password: password,
    );
    
    return customersData.map((json) => CustomerEntity.fromJson(json)).toList();
  }

  @override
  Future<void> saveCustomers(List<CustomerEntity> customers) async {
    await _customerDB.createOrUpdateBatch(customers);
  }
}
