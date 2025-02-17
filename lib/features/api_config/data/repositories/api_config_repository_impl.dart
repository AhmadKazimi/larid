import 'package:larid/features/api_config/domain/repositories/api_config_repository.dart';
import '../../../../database/user_db.dart';

class ApiConfigRepositoryImpl implements ApiConfigRepository {
  final UserDB _userDB;

  ApiConfigRepositoryImpl({required UserDB userDB}) : _userDB = userDB;

  @override
  Future<String?> getBaseUrl() async {
    return await _userDB.getBaseUrl();
  }

  @override
  Future<void> saveBaseUrl(String baseUrl) async {
    await _userDB.saveBaseUrl(baseUrl);
  }
}
