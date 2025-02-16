import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<UserEntity> call({
    required String userid,
    required String workspace,
    required String password,
  }) {
    return _authRepository.login(
      userid: userid,
      workspace: workspace,
      password: password,
    );
  }
}
