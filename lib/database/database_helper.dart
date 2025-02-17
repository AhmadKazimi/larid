import 'package:sqflite/sqflite.dart';
import 'package:logging/logging.dart';
import '../core/di/service_locator.dart';
import 'user_db.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  final _logger = Logger('DatabaseHelper');

  // Private constructor
  DatabaseHelper._internal() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      _logger.info('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  // Singleton pattern
  factory DatabaseHelper() => _instance;

  // Get database instance from service locator
  Future<Database> get database async => getIt<Database>();

  Future<void> _onCreate(Database db, int version) async {
    _logger.info('Creating database tables for version $version');
    // Create your tables here
    await db.execute(UserDB.createTableQuery);
    // Add more tables as needed
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    _logger.info('Upgrading database from version $oldVersion to $newVersion');
    // Handle database upgrades here
    if (oldVersion < 1) {
      await _onCreate(db, newVersion);
    }
  }

  // Generic CRUD operations
  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await database;
    try {
      _logger.info('Inserting into $table: $row');
      final result = await db.insert(table, row, conflictAlgorithm: ConflictAlgorithm.replace);
      if (result != -1) {
        _logger.info('Successfully inserted into $table with id: $result');
      } else {
        _logger.warning('Failed to insert into $table');
      }
      return result;
    } catch (e) {
      _logger.severe('Error inserting into $table: $e');
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    Database db = await database;
    try {
      _logger.info('Querying all records from $table');
      final results = await db.query(table);
      _logger.info('Successfully retrieved ${results.length} records from $table');
      return results;
    } catch (e) {
      _logger.severe('Error querying $table: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> queryWhere(
      String table, String whereClause, List<dynamic> whereArgs) async {
    Database db = await database;
    try {
      _logger.info('Querying $table with where clause: $whereClause, args: $whereArgs');
      final results = await db.query(table, where: whereClause, whereArgs: whereArgs);
      _logger.info('Successfully retrieved ${results.length} records from $table');
      return results;
    } catch (e) {
      _logger.severe('Error querying $table with where clause: $e');
      return [];
    }
  }

  Future<int> update(
      String table, Map<String, dynamic> row, String whereClause, List<dynamic> whereArgs) async {
    Database db = await database;
    try {
      _logger.info('Updating $table with data: $row, where: $whereClause, args: $whereArgs');
      final result = await db.update(table, row, where: whereClause, whereArgs: whereArgs);
      if (result > 0) {
        _logger.info('Successfully updated $result rows in $table');
      } else {
        _logger.warning('No rows updated in $table');
      }
      return result;
    } catch (e) {
      _logger.severe('Error updating $table: $e');
      return -1;
    }
  }

  Future<int> delete(String table, String whereClause, List<dynamic> whereArgs) async {
    Database db = await database;
    try {
      _logger.info('Deleting from $table where: $whereClause, args: $whereArgs');
      final result = await db.delete(table, where: whereClause, whereArgs: whereArgs);
      if (result > 0) {
        _logger.info('Successfully deleted $result rows from $table');
      } else {
        _logger.warning('No rows deleted from $table');
      }
      return result;
    } catch (e) {
      _logger.severe('Error deleting from $table: $e');
      return -1;
    }
  }
}
