import 'package:larid/database/user_table.dart';
import 'package:larid/database/working_session_table.dart';
import '../../domain/entities/working_session_entity.dart';
import '../../domain/repositories/working_session_repository.dart';

class WorkingSessionRepositoryImpl implements WorkingSessionRepository {
  final WorkingSessionTable _workingSessionTable;
  final UserTable _userTable;

  WorkingSessionRepositoryImpl(this._workingSessionTable, this._userTable);

  @override
  Future<bool> hasActiveSession() async {
    return _workingSessionTable.hasActiveSession();
  }

  @override
  Future<void> startNewSession() async {
    final currentUser = await _userTable.getCurrentUser();
    if (currentUser == null) {
      throw Exception('No user found');
    }
    await _workingSessionTable.startNewSession(
      currentUser.userid,
      currentUser.workspace,
    );
  }

  @override
  Future<void> endCurrentSession() async {
    await _workingSessionTable.endCurrentSession();
  }

  @override
  Future<WorkingSessionEntity?> getCurrentSession() async {
    final session = await _workingSessionTable.getCurrentSession();
    if (session == null) return null;
    return WorkingSessionEntity.fromMap(session);
  }
}
