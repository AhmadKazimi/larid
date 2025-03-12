import 'dart:developer' as dev;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'company_info_table.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  void setDatabase(Database db) {
    _database = db;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'larid.db');

    dev.log('Initializing database at: $path');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    dev.log('Creating database tables for version $version');
    await _createTables(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    dev.log('Upgrading database from $oldVersion to $newVersion');
    // Handle database migrations here
    if (oldVersion < newVersion) {
      // Add upgrade logic if needed
    }
  }

  Future<void> _createTables(Database db) async {
    // Create customers table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS customers (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        phone TEXT,
        email TEXT,
        address TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Create inventory_items table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS inventory_items (
        item_code TEXT PRIMARY KEY,
        description TEXT NOT NULL,
        taxable_flag INTEGER NOT NULL,
        tax_code TEXT,
        sell_unit_code TEXT NOT NULL,
        sell_unit_price REAL NOT NULL,
        qty INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Create invoices table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS invoices (
        id TEXT PRIMARY KEY,
        customer_id TEXT NOT NULL,
        customer_name TEXT NOT NULL,
        total_amount REAL NOT NULL,
        date TEXT NOT NULL,
        status TEXT NOT NULL,
        is_return INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE CASCADE
      )
    ''');

    // Create invoice_items table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS invoice_items (
        id TEXT PRIMARY KEY,
        invoice_id TEXT NOT NULL,
        item_code TEXT NOT NULL,
        description TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        unit_price REAL NOT NULL,
        total_price REAL NOT NULL,
        is_return INTEGER NOT NULL,
        tax_code TEXT,
        taxable_flag INTEGER NOT NULL,
        tax_amt REAL DEFAULT 0,
        tax_pc REAL DEFAULT 0,
        sell_unit_code TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (invoice_id) REFERENCES invoices (id) ON DELETE CASCADE,
        FOREIGN KEY (item_code) REFERENCES inventory_items (item_code) ON DELETE RESTRICT
      )
    ''');

    // Create company_info table
    dev.log('Creating company_info table');
    try {
      await db.execute(CompanyInfoTable.createTableQuery);
      dev.log('Successfully created company_info table');
    } catch (e) {
      dev.log('Error creating company_info table: $e');
    }

    // Create any other tables you might need
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('invoice_items');
    await db.delete('invoices');
    await db.delete('inventory_items');
    await db.delete('customers');
    await db.delete('company_info');
    // Delete data from other tables as needed
  }

  // Utility method to check if a table exists
  Future<bool> tableExists(String tableName) async {
    final db = await database;
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName'",
    );
    return result.isNotEmpty;
  }
}
