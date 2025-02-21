import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class WorkingSessionTable {
  final Database _db;
  static const String tableName = 'working_sessions';

  WorkingSessionTable(this._db);

  static const String createTableQuery = '''
    CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id TEXT NOT NULL,
      workspace TEXT NOT NULL,
      day_name TEXT NOT NULL,
      date TEXT NOT NULL,
      start_time TEXT NOT NULL,
      end_time TEXT
    )
  ''';

  Future<bool> hasActiveSession() async {
    final List<Map<String, dynamic>> result = await _db.query(
      tableName,
      where: 'end_time IS NULL',
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<void> startNewSession(String userId, String workspace) async {
    final now = DateTime.now();
    final dayName = DateFormat('EEEE').format(now);
    final date = DateFormat('dd-MM-yyyy').format(now);
    final startTime = DateFormat('HH:mm').format(now);

    await _db.insert(
      tableName,
      {
        'user_id': userId,
        'workspace': workspace,
        'day_name': dayName,
        'date': date,
        'start_time': startTime,
      },
    );
  }

  Future<void> endCurrentSession() async {
    final now = DateTime.now();
    final endTime = DateFormat('HH:mm').format(now);

    await _db.update(
      tableName,
      {'end_time': endTime},
      where: 'end_time IS NULL',
    );
  }

  Future<Map<String, dynamic>?> getCurrentSession() async {
    final List<Map<String, dynamic>> result = await _db.query(
      tableName,
      where: 'end_time IS NULL',
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }
}