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
}
