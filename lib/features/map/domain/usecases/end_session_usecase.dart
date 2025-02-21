import '../repositories/working_session_repository.dart';

class EndSessionUseCase {
  final WorkingSessionRepository _workingSessionRepository;

  EndSessionUseCase(this._workingSessionRepository);

  Future<void> call() async {
    await _workingSessionRepository.endCurrentSession();
  }
}
