import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final DioClient _dioClient;
  final SharedPreferences _sharedPreferences;
  static const String _userKey = 'user_key';

  AuthRepositoryImpl({
    required DioClient dioClient,
    required SharedPreferences sharedPreferences,
  })  : _dioClient = dioClient,
        _sharedPreferences = sharedPreferences;

  @override
  Future<UserEntity> login({
    required String userid,
    required String workspace,
    required String password,
    required String baseUrl,
  }) async {
    try {
      // Configure base URL for API calls
      _dioClient.setBaseUrl(baseUrl);

      final user = UserEntity(
        userid: userid,
        workspace: workspace,
        password: password,
        baseUrl: baseUrl,
      );
      
      await saveUser(user);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await _sharedPreferences.remove(_userKey);
    _dioClient.removeAuthToken();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final userJson = _sharedPreferences.getString(_userKey);
    if (userJson == null) return null;
    
    final user = UserEntity.fromJson(json.decode(userJson));
    _dioClient.setBaseUrl(user.baseUrl);
    return user;
  }

  @override
  Future<void> saveUser(UserEntity user) async {
    await _sharedPreferences.setString(_userKey, json.encode(user.toJson()));
  }
}
