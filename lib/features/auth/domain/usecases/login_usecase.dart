import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<bool> call(UserEntity user) {
    return _authRepository.login(
      userid: user.userid,
      workspace: user.workspace,
      password: user.password,
    );
  }
}
