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
      mapCoords TEXT,
      visitStartTime TEXT,
      visitEndTime TEXT
    )
  ''';

  static const String createSalesrepCustomerTableQuery = '''
    CREATE TABLE IF NOT EXISTS $salesrepCustomerTableName (
      customerCode TEXT PRIMARY KEY,
      customerName TEXT NOT NULL,
      address TEXT,
      contactPhone TEXT,
      mapCoords TEXT,
      visitStartTime TEXT,
      visitEndTime TEXT
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
          'visitStartTime': customer.visitStartTime,
          'visitEndTime': customer.visitEndTime,
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
          'visitStartTime': customer.visitStartTime,
          'visitEndTime': customer.visitEndTime,
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
      visitStartTime: map['visitStartTime'] as String?,
      visitEndTime: map['visitEndTime'] as String?,
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
      'visitStartTime': map['visitStartTime'],
      'visitEndTime': map['visitEndTime'],
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
      'visitStartTime': map['visitStartTime'],
      'visitEndTime': map['visitEndTime'],
    })).toList();
  }

  Future<List<CustomerEntity>> getAllCustomers() async {
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return maps.map((map) => CustomerEntity.fromJson(map)).toList();
  }

  // Check if there's an active visit session for any customer
  Future<bool> hasActiveVisitSession() async {
    final List<Map<String, dynamic>> maps = await db.query(
      salesrepCustomerTableName,
      where: 'visitStartTime IS NOT NULL AND visitEndTime IS NULL',
      limit: 1,
    );
    return maps.isNotEmpty;
  }

  // Get the customer with an active visit session
  Future<CustomerEntity?> getCustomerWithActiveVisitSession() async {
    try {
      print('Checking for customer with active visit session...');
      
      final List<Map<String, dynamic>> maps = await db.query(
        salesrepCustomerTableName,
        where: 'visitStartTime IS NOT NULL AND visitEndTime IS NULL',
        limit: 1,
      );
      
      if (maps.isEmpty) {
        print('No customer found with active visit session');
        return null;
      }
      
      // Debug print to understand what data we're getting back
      print('Customer with active visit: ${maps[0]}');
      print('Active visit start time: ${maps[0]['visitStartTime']}');
      
      return CustomerEntity.fromJson({
        'sCustomer_cd': maps[0]['customerCode'],
        'sCustomer_nm': maps[0]['customerName'],
        'sAddress1': maps[0]['address'],
        'sContactPhone': maps[0]['contactPhone'],
        'sMapCoords': maps[0]['mapCoords'],
        'visitStartTime': maps[0]['visitStartTime'],
        'visitEndTime': maps[0]['visitEndTime'],
      });
    } catch (e) {
      print('Error getting customer with active visit session: $e');
      return null;
    }
  }

  // Start a visit session for a customer
  Future<void> startVisitSession(String customerCode) async {
    // Generate timestamp in HH:MM:SS format
    final now = DateTime.now();
    final formattedTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    
    // First, check if this update is successful
    int updatedRows = await db.update(
      salesrepCustomerTableName,
      {'visitStartTime': formattedTime, 'visitEndTime': null},
      where: 'customerCode = ?',
      whereArgs: [customerCode],
    );
    
    // If no rows were updated, the customer might not exist or there's another issue
    if (updatedRows == 0) {
      print('Warning: Failed to start visit session for customer code: $customerCode. No rows updated.');
      
      // Let's verify if the customer exists
      final customerExists = await _customerExists(customerCode);
      print('Customer exists check: $customerExists for code $customerCode');
      
      if (customerExists) {
        // Retry with a raw query for debugging
        try {
          await db.rawUpdate(
            'UPDATE $salesrepCustomerTableName SET visitStartTime = ?, visitEndTime = NULL WHERE customerCode = ?',
            [formattedTime, customerCode]
          );
          print('Raw update attempted for customer code: $customerCode');
        } catch (e) {
          print('Error in raw update: $e');
        }
      }
    } else {
      print('Successfully started visit session for customer code: $customerCode');
    }
  }
  
  // Helper method to check if customer exists
  Future<bool> _customerExists(String customerCode) async {
    final List<Map<String, dynamic>> result = await db.query(
      salesrepCustomerTableName,
      where: 'customerCode = ?',
      whereArgs: [customerCode],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  // End a visit session for a customer
  Future<void> endVisitSession(String customerCode) async {
    // Generate timestamp in HH:MM:SS format
    final now = DateTime.now();
    final formattedTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    
    // First, check if this update is successful
    int updatedRows = await db.update(
      salesrepCustomerTableName,
      {'visitEndTime': formattedTime},
      where: 'customerCode = ?',
      whereArgs: [customerCode],
    );
    
    // If no rows were updated, the customer might not exist or there's another issue
    if (updatedRows == 0) {
      print('Warning: Failed to end visit session for customer code: $customerCode. No rows updated.');
      
      // Let's verify if the customer exists
      final customerExists = await _customerExists(customerCode);
      print('Customer exists check: $customerExists for code $customerCode');
      
      if (customerExists) {
        // Retry with a raw query for debugging
        try {
          await db.rawUpdate(
            'UPDATE $salesrepCustomerTableName SET visitEndTime = ? WHERE customerCode = ?',
            [formattedTime, customerCode]
          );
          print('Raw update attempted for ending visit for customer code: $customerCode');
        } catch (e) {
          print('Error in raw update for ending visit: $e');
        }
      }
    } else {
      print('Successfully ended visit session for customer code: $customerCode');
    }
  }

  // Get customer by code
  Future<CustomerEntity?> getCustomerByCode(String customerCode) async {
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        salesrepCustomerTableName,
        where: 'customerCode = ?',
        whereArgs: [customerCode],
        limit: 1,
      );
      
      if (maps.isEmpty) {
        print('No customer found with code: $customerCode');
        return null;
      }
      
      // Debug print to understand what data we're getting back
      print('Customer data from DB: ${maps[0]}');
      print('Visit start time from DB: ${maps[0]['visitStartTime']}');
      print('Visit end time from DB: ${maps[0]['visitEndTime']}');
      
      return CustomerEntity.fromJson({
        'sCustomer_cd': maps[0]['customerCode'],
        'sCustomer_nm': maps[0]['customerName'],
        'sAddress1': maps[0]['address'],
        'sContactPhone': maps[0]['contactPhone'],
        'sMapCoords': maps[0]['mapCoords'],
        'visitStartTime': maps[0]['visitStartTime'],
        'visitEndTime': maps[0]['visitEndTime'],
      });
    } catch (e) {
      print('Error getting customer by code: $e');
      return null;
    }
  }
}
