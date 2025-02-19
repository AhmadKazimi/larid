import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_service.dart';
import '../../../../database/user_db.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final DioClient _dioClient;
  final ApiService _apiService;
  final SharedPreferences _sharedPreferences;
  final UserDB _userDB;
  static const String _userKey = 'user_key';
  static const String _isLoggedInKey = 'is_logged_in';

  AuthRepositoryImpl({
    required DioClient dioClient,
    required SharedPreferences sharedPreferences,
    required ApiService apiService,
    required UserDB userDB,
  })  : _dioClient = dioClient,
        _sharedPreferences = sharedPreferences,
        _apiService = apiService,
        _userDB = userDB;

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
    // First try to get from SharedPreferences for active session
    final userJson = _sharedPreferences.getString(_userKey);
    if (userJson != null) {
      return UserEntity.fromJson(json.decode(userJson));
    }
    
    // If not in SharedPreferences, try to get from database
    return await _userDB.getCurrentUser();
  }

  @override
  Future<void> saveUser(UserEntity user) async {
    // Save to SharedPreferences for session management
    await _sharedPreferences.setString(_userKey, json.encode(user.toJson()));
    
    // Save to database for persistence
    await _userDB.updateCurrentUser(user, _dioClient.baseUrl);
  }

  @override
  bool isLoggedIn() {
    return _sharedPreferences.getBool(_isLoggedInKey) ?? false;
  }
}
