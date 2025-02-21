import '../entities/working_session_entity.dart';

abstract class WorkingSessionRepository {
  Future<bool> hasActiveSession();
  Future<void> startNewSession();
  Future<void> endCurrentSession();
  Future<WorkingSessionEntity?> getCurrentSession();
}
