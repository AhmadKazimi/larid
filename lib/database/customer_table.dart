import 'package:sqflite/sqflite.dart';
import '../features/sync/domain/entities/customer_entity.dart';

class CustomerTable {
  static const String tableName = 'customers';
  static const String salesrepCustomerTableName = 'sales_rep_customer';

  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      customerCode TEXT PRIMARY KEY,
      customerName TEXT NOT NULL,
      address TEXT,
      contactPhone TEXT,
      mapCoords TEXT
    )
  ''';

  static const String createSalesrepCustomerTableQuery = '''
    CREATE TABLE IF NOT EXISTS $salesrepCustomerTableName (
      customerCode TEXT PRIMARY KEY,
      customerName TEXT NOT NULL,
      address TEXT,
      contactPhone TEXT,
      mapCoords TEXT
    )
  ''';

  final Database db;

  CustomerTable(this.db);

  Future<void> createOrUpdateCustomers(List<CustomerEntity> customers) async {
    final batch = db.batch();
    
    for (final customer in customers) {
      batch.insert(
        tableName,
        {
          'customerCode': customer.customerCode,
          'customerName': customer.customerName,
          'address': customer.address,
          'contactPhone': customer.contactPhone,
          'mapCoords': customer.mapCoords,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    
    await batch.commit();
  }

  Future<void> createOrUpdateSalesRepCustomers(List<CustomerEntity> customers) async {
    final batch = db.batch();
    
    for (final customer in customers) {
      batch.insert(
        salesrepCustomerTableName,
        {
          'customerCode': customer.customerCode,
          'customerName': customer.customerName,
          'address': customer.address,
          'contactPhone': customer.contactPhone,
          'mapCoords': customer.mapCoords,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    
    await batch.commit();
  }

  Future<List<CustomerEntity>> getAllSalesRepCustomers() async {
    final List<Map<String, dynamic>> maps = await db.query(salesrepCustomerTableName);
    
    return maps.map((map) => CustomerEntity(
      customerCode: map['customerCode'] as String? ?? '',
      customerName: map['customerName'] as String? ?? '',
      address: map['address'] as String?,
      contactPhone: map['contactPhone'] as String?,
      mapCoords: map['mapCoords'] as String?,
    )).toList();
  }

  Future<List<CustomerEntity>> searchCustomers(String query) async {
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'customerName LIKE ? OR customerCode LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );

    return maps.map((map) => CustomerEntity.fromJson({
      'sCustomer_cd': map['customerCode'],
      'sCustomer_nm': map['customerName'],
      'sAddress1': map['address'],
      'sContactPhone': map['contactPhone'],
      'sMapCoords': map['mapCoords'],
    })).toList();
  }

  Future<List<CustomerEntity>> searchSalesRepCustomers(String query) async {
    final List<Map<String, dynamic>> maps = await db.query(
      salesrepCustomerTableName,
      where: 'customerName LIKE ? OR customerCode LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );

    return maps.map((map) => CustomerEntity.fromJson({
      'sCustomer_cd': map['customerCode'],
      'sCustomer_nm': map['customerName'],
      'sAddress1': map['address'],
      'sContactPhone': map['contactPhone'],
      'sMapCoords': map['mapCoords'],
    })).toList();
  }

  Future<List<CustomerEntity>> getAllCustomers() async {
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return maps.map((map) => CustomerEntity.fromJson(map)).toList();
  }
}
