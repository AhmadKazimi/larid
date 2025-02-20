import 'dart:developer' as dev;
import 'package:sqflite/sqflite.dart';
import '../features/sync/domain/entities/prices/prices_entity.dart';

class PricesTable {
  static const String tableName = 'prices';
  
  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      sItem_cd TEXT NOT NULL,
      mPrice_amt REAL NOT NULL,
      sCustomer_cd TEXT NOT NULL,
      created_at TEXT NOT NULL
    )
  ''';

  final Database db;

  PricesTable(this.db);

  Future<void> createOrUpdatePrices(List<PriceEntity> prices) async {
    try {
      dev.log('Saving ${prices.length} prices to database');
      final batch = db.batch();
      
      for (final price in prices) {
        batch.insert(
          tableName,
          price.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      
      await batch.commit();
      dev.log('Successfully saved prices to database');
      
      // Verify the save
      final savedPrices = await getPrices();
      dev.log('Verified ${savedPrices.length} prices in database');
    } catch (e) {
      dev.log('Error saving prices: $e');
      rethrow;
    }
  }

  Future<List<PriceEntity>> getPrices() async {
    try {
      final List<Map<String, dynamic>> maps = await db.query(tableName);
      dev.log('Retrieved ${maps.length} prices from database');
      return maps.map((map) => PriceEntity.fromJson(map)).toList();
    } catch (e) {
      dev.log('Error getting prices: $e');
      rethrow;
    }
  }

  Future<PriceEntity?> getPriceByItemAndCustomer({
    required String itemCode,
    required String customerCode,
  }) async {
    try {
      final List<Map<String, dynamic>> result = await db.query(
        tableName,
        where: 'sItem_cd = ? AND sCustomer_cd = ?',
        whereArgs: [itemCode, customerCode],
        orderBy: 'created_at DESC',
        limit: 1,
      );

      if (result.isEmpty) return null;
      return PriceEntity.fromJson(result.first);
    } catch (e) {
      dev.log('Error getting price by item and customer: $e');
      rethrow;
    }
  }
}
