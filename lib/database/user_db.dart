import 'package:sqflite/sqflite.dart';
import '../features/auth/domain/entities/user_entity.dart';

class UserDB {
  static const String tableName = 'users';
  
  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userid TEXT NOT NULL,
      workspace TEXT NOT NULL,
      password TEXT NOT NULL,
      baseUrl TEXT NOT NULL
    )
  ''';

  final Database _db;

  UserDB(this._db);

  Future<void> updateCurrentUser(UserEntity user, String baseUrl) async {
    final users = await _db.query(tableName);
    
    if (users.isEmpty) {
      await _db.insert(
        tableName,
        {
          'userid': user.userid,
          'workspace': user.workspace,
          'password': user.password,
          'baseUrl': baseUrl,
        },
      );
    } else {
      await _db.update(
        tableName,
        {
          'userid': user.userid,
          'workspace': user.workspace,
          'password': user.password,
          'baseUrl': baseUrl,
        },
        where: 'id = ?',
        whereArgs: [users.first['id']],
      );
    }
  }

  Future<UserEntity?> getCurrentUser() async {
    final List<Map<String, dynamic>> users = await _db.query(
      tableName,
      limit: 1,
    );

    if (users.isEmpty) {
      return null;
    }

    return UserEntity(
      userid: users.first['userid'] as String,
      workspace: users.first['workspace'] as String,
      password: users.first['password'] as String,
    );
  }

  Future<String?> getBaseUrl() async {
    final List<Map<String, dynamic>> users = await _db.query(
      tableName,
      columns: ['baseUrl'],
      limit: 1,
    );

    if (users.isEmpty) {
      return null;
    }

    return users.first['baseUrl'] as String;
  }

  Future<void> saveBaseUrl(String baseUrl) async {
    final users = await _db.query(tableName);
    
    if (users.isEmpty) {
      await _db.insert(
        tableName,
        {
          'userid': '',
          'workspace': '',
          'password': '',
          'baseUrl': baseUrl,
        },
      );
    } else {
      await _db.update(
        tableName,
        {'baseUrl': baseUrl},
        where: 'id = ?',
        whereArgs: [users.first['id']],
      );
    }
  }
}
