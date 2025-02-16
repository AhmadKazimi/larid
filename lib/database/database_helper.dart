import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Private constructor
  DatabaseHelper._internal();

  // Singleton pattern
  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'larid.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create your tables here
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userid TEXT,
        workspace TEXT NOT NULL,
        password TEXT NOT NULL,
        baseUrl TEXT NOT NULL,
        createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Add more tables as needed
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < 1) {
      await _onCreate(db, newVersion);
    }
  }

  // Generic CRUD operations
  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await database;
    try {
      return await db.insert(table, row, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print('Error inserting into $table: $e');
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    Database db = await database;
    try {
      return await db.query(table);
    } catch (e) {
      print('Error querying $table: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> queryWhere(
      String table, String whereClause, List<dynamic> whereArgs) async {
    Database db = await database;
    try {
      return await db.query(table, where: whereClause, whereArgs: whereArgs);
    } catch (e) {
      print('Error querying $table with where clause: $e');
      return [];
    }
  }

  Future<int> update(
      String table, Map<String, dynamic> row, String whereClause, List<dynamic> whereArgs) async {
    Database db = await database;
    try {
      return await db.update(table, row, where: whereClause, whereArgs: whereArgs);
    } catch (e) {
      print('Error updating $table: $e');
      return -1;
    }
  }

  Future<int> delete(String table, String whereClause, List<dynamic> whereArgs) async {
    Database db = await database;
    try {
      return await db.delete(table, where: whereClause, whereArgs: whereArgs);
    } catch (e) {
      print('Error deleting from $table: $e');
      return -1;
    }
  }

  // Close the database
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
