import 'package:larid/core/network/api_service.dart';
import 'package:larid/database/customer_db.dart';
import 'package:larid/database/user_db.dart';
import '../../domain/entities/customer_entity.dart';
import '../../domain/repositories/sync_repository.dart';


class SyncRepositoryImpl implements SyncRepository {
  final ApiService _apiService;
  final CustomerDB _customerDB;
  final UserDB _userDB;

  SyncRepositoryImpl({
    required ApiService apiService,
    required CustomerDB customerDB,
    required UserDB userDB,
  })  : _apiService = apiService,
        _customerDB = customerDB,
        _userDB = userDB;

  @override
  Future<List<CustomerEntity>> getCustomers() async {
    final user = await _userDB.getCurrentUser();
    if (user == null) {
      throw Exception('User not found');
    }

    final customersData = await _apiService.getCustomers(
      userid: user.userid,
      workspace: user.workspace,
      password: user.password,
    );
    
    return customersData.map((json) => CustomerEntity.fromJson(json)).toList();
  }

  @override
  Future<void> saveCustomers(List<CustomerEntity> customers) async {
    await _customerDB.createOrUpdateBatch(customers);
  }
}
