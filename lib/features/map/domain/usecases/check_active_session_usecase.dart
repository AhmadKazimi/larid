import '../repositories/working_session_repository.dart';

class CheckActiveSessionUseCase {
  final WorkingSessionRepository _repository;

  CheckActiveSessionUseCase(this._repository);

  Future<bool> call() async {
    return _repository.hasActiveSession();
  }
}
