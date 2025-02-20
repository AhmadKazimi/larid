import 'dart:developer' as dev;
import 'package:sqflite/sqflite.dart';
import '../features/sync/domain/entities/inventory/inventory_unit_entity.dart';

class InventoryUnitsTable {
  static const String tableName = 'inventory_units';

  static const String createTableQuery = '''
      CREATE TABLE IF NOT EXISTS $tableName (
      unit_code TEXT PRIMARY KEY,
      created_at TEXT NOT NULL
    )
  ''';

  final Database db;

  InventoryUnitsTable(this.db);

  Future<void> createOrUpdateUnits(List<InventoryUnitEntity> units) async {
    try {
      dev.log('Saving ${units.length} units to database');
      final batch = db.batch();

      for (final unit in units) {
        batch.insert(tableName, {
          'unit_code': unit.unitCode,
          'created_at': DateTime.now().toIso8601String(),
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }

      await batch.commit();
      dev.log('Successfully saved units to database');

      // Verify the save
      final savedUnits = await getAllUnits();
      dev.log('Verified ${savedUnits.length} units in database');
    } catch (e) {
      dev.log('Error saving units: $e');
      rethrow;
    }
  }

  Future<List<InventoryUnitEntity>> getAllUnits() async {
    final results = await db.query(tableName);

    return results
        .map((map) => InventoryUnitEntity(unitCode: map['unit_code'] as String))
        .toList();
  }
}
