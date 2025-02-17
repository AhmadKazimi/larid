import 'package:sqflite/sqflite.dart';
import '../features/sync/domain/entities/customer_entity.dart';

class CustomerDB {
  static const String tableName = 'customers';
  
  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      customerCode TEXT PRIMARY KEY,
      customerName TEXT NOT NULL,
      address TEXT,
      contactPhone TEXT,
      mapCoords TEXT
    )
  ''';

  final Database db;

  CustomerDB(this.db);

  Future<void> createOrUpdate(CustomerEntity customer) async {
    await db.insert(
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

  Future<void> createOrUpdateBatch(List<CustomerEntity> customers) async {
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
}
