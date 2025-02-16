import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login({
    required String userid,
    required String workspace,
    required String password,
    required String baseUrl,
  });
  Future<void> logout();
  Future<UserEntity?> getCurrentUser();
  Future<void> saveUser(UserEntity user);
}
