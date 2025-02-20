import 'package:larid/features/api_config/domain/repositories/api_config_repository.dart';
import '../../../../database/user_table.dart';

class ApiConfigRepositoryImpl implements ApiConfigRepository {
  final UserTable _userDB;

  ApiConfigRepositoryImpl({required UserTable userDB}) : _userDB = userDB;

  @override
  Future<String?> getBaseUrl() async {
    return await _userDB.getBaseUrl();
  }

  @override
  Future<void> saveBaseUrl(String baseUrl) async {
    await _userDB.saveBaseUrl(baseUrl);
  }
}
