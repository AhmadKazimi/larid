import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ApiConfigLocalDataSource {
  static final ApiConfigLocalDataSource instance = ApiConfigLocalDataSource._init();
  static Database? _database;

  ApiConfigLocalDataSource._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('larid.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        workspaceId TEXT NOT NULL,
        password TEXT NOT NULL,
        baseUrl TEXT NOT NULL,
        createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  Future<void> saveBaseUrl(String baseUrl) async {
    final db = await database;
    
    final List<Map<String, dynamic>> users = await db.query('users');
    
    if (users.isEmpty) {
      await db.insert('users', {
        'workspaceId': '',
        'password': '',
        'baseUrl': baseUrl,
      });
    } else {
      await db.update(
        'users',
        {'baseUrl': baseUrl},
        where: 'id = ?',
        whereArgs: [users.first['id']],
      );
    }
  }

  Future<String?> getBaseUrl() async {
    final db = await database;
    final List<Map<String, dynamic>> users = await db.query('users');
    
    if (users.isEmpty) return null;
    return users.first['baseUrl'] as String;
  }
}
