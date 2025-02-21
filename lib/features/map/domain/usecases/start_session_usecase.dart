import '../repositories/working_session_repository.dart';

class StartSessionUseCase {
  final WorkingSessionRepository _repository;

  StartSessionUseCase(this._repository);

  Future<void> call() async {
    await _repository.startNewSession();
  }
}
