import 'dart:developer' as dev;
import 'package:sqflite/sqflite.dart';
import '../features/sync/domain/entities/inventory/inventory_item_entity.dart';

class InventoryItemsTable {
  static const String tableName = 'inventory_items';
  
  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      sItem_cd TEXT NOT NULL,
      sDescription TEXT NOT NULL,
      iTaxable_fl INTEGER NOT NULL,
      sTax_cd TEXT NOT NULL,
      sSellUnit_cd TEXT NOT NULL,
      mSellUnitPrice_amt REAL NOT NULL,
      created_at TEXT
    )
  ''';

  final Database db;

  InventoryItemsTable(this.db);

  Future<void> createOrUpdateItems(List<InventoryItemEntity> items) async {
    try {
      dev.log('Saving ${items.length} inventory items to database');
      final batch = db.batch();
      
      for (final item in items) {
        batch.insert(
          tableName,
          {
            'sItem_cd': item.itemCode,
            'sDescription': item.description,
            'iTaxable_fl': item.taxableFlag,
            'sTax_cd': item.taxCode,
            'sSellUnit_cd': item.sellUnitCode,
            'mSellUnitPrice_amt': item.sellUnitPrice,
            'created_at': item.createdAt ?? DateTime.now().toIso8601String(),
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      
      await batch.commit();
      dev.log('Successfully saved inventory items to database');
      
      // Verify the save
      final savedItems = await getItems();
      dev.log('Verified ${savedItems.length} inventory items in database');
    } catch (e) {
      dev.log('Error saving inventory items: $e');
      rethrow;
    }
  }

  Future<List<InventoryItemEntity>> getItems() async {
    try {
      final List<Map<String, dynamic>> maps = await db.query(tableName);
      dev.log('Retrieved ${maps.length} inventory items from database');
      return maps.map((map) => InventoryItemEntity.fromJson(map)).toList();
    } catch (e) {
      dev.log('Error getting inventory items: $e');
      rethrow;
    }
  }

  Future<InventoryItemEntity?> getItemByCode(String itemCode) async {
    try {
      final List<Map<String, dynamic>> result = await db.query(
        tableName,
        where: 'sItem_cd = ?',
        whereArgs: [itemCode],
        limit: 1,
      );

      if (result.isEmpty) return null;
      return InventoryItemEntity.fromJson(result.first);
    } catch (e) {
      dev.log('Error getting inventory item by code: $e');
      rethrow;
    }
  }
}
