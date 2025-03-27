import 'package:intl/intl.dart';
import 'package:larid/core/network/api_service.dart';
import 'package:larid/database/customer_table.dart';
import 'package:larid/database/user_table.dart';
import 'package:larid/database/working_session_table.dart';
import '../../domain/entities/working_session_entity.dart';
import '../../domain/repositories/working_session_repository.dart';
import 'package:larid/core/di/service_locator.dart';

class WorkingSessionRepositoryImpl implements WorkingSessionRepository {
  final WorkingSessionTable _workingSessionTable;
  final UserTable _userTable;
  final CustomerTable _customerTable;
  final ApiService _apiService;

  WorkingSessionRepositoryImpl(
    this._workingSessionTable,
    this._userTable,
    this._customerTable,
    this._apiService,
  );

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
    // Get the current session to retrieve start time
    final session = await _workingSessionTable.getCurrentSession();
    if (session == null) {
      throw Exception('No active session found');
    }

    // End the session in the local database
    await _workingSessionTable.endCurrentSession();

    // Get user credentials
    final currentUser = await _userTable.getCurrentUser();
    if (currentUser == null) {
      throw Exception('No user found');
    }

    // Get the currently active customer for this visit
    final customerVisit = await _customerTable.getActiveCustomerVisit();
    if (customerVisit == null) {
      // No customer was visited during this session, so don't call the API
      return;
    }

    // Format visit date as YYYYMMDD
    final visitDate = int.parse(DateFormat('yyyyMMdd').format(DateTime.now()));

    // Format start time and end time as YYYY-MM-DD HH:mm:ss
    final now = DateTime.now();
    final startTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    final endTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    // Call API to save the visit data
    await _apiService.addSalesrepVisit(
      workspace: currentUser.workspace,
      userid: currentUser.userid,
      password: currentUser.password,
      customerCode: customerVisit['customer_code'],
      visitDate: visitDate,
      startTime: startTime,
      endTime: endTime,
      comments: '',
    );
  }

  @override
  Future<WorkingSessionEntity?> getCurrentSession() async {
    final session = await _workingSessionTable.getCurrentSession();
    if (session == null) return null;
    return WorkingSessionEntity.fromMap(session);
  }
}
