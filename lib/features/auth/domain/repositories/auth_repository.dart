import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<bool> login({
    required String userid,
    required String workspace,
    required String password,
  });
  Future<void> logout();
  Future<UserEntity?> getCurrentUser();
  Future<void> saveUser(UserEntity user);
  bool isLoggedIn();
}
