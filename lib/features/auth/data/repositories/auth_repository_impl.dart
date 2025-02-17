import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final DioClient _dioClient;
  final ApiService _apiService;
  final SharedPreferences _sharedPreferences;
  static const String _userKey = 'user_key';
  static const String _isLoggedInKey = 'is_logged_in';

  AuthRepositoryImpl({
    required DioClient dioClient,
    required SharedPreferences sharedPreferences,
    required ApiService apiService,
  })  : _dioClient = dioClient,
        _sharedPreferences = sharedPreferences,
        _apiService = apiService;

  @override
  Future<bool> login({
    required String userid,
    required String workspace,
    required String password,
  }) async {
    try {
      // Call the checkUser API and verify credentials
      final isAuthenticated = await _apiService.checkUser(
        userid: userid,
        workspace: workspace,
        password: password,
      );

      if (isAuthenticated) {
        // Create user entity since authentication was successful
        final user = UserEntity(
          userid: userid,
          workspace: workspace,
          password: password,
        );
        
        await saveUser(user);
        await _sharedPreferences.setBool(_isLoggedInKey, true);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await _sharedPreferences.remove(_userKey);
    await _sharedPreferences.remove(_isLoggedInKey);
    _dioClient.removeAuthToken();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final userJson = _sharedPreferences.getString(_userKey);
    if (userJson == null) return null;
    
    final user = UserEntity.fromJson(json.decode(userJson));
    return user;
  }

  @override
  Future<void> saveUser(UserEntity user) async {
    await _sharedPreferences.setString(_userKey, json.encode(user.toJson()));
  }

  @override
  bool isLoggedIn() {
    return _sharedPreferences.getBool(_isLoggedInKey) ?? false;
  }
}
