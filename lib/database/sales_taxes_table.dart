import 'dart:developer' as dev;
import 'package:sqflite/sqflite.dart';
import '../features/sync/domain/entities/sales_tax_entity.dart';

class SalesTaxesTable {
  static const String tableName = 'sales_taxes';

  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      sTax_cd TEXT NOT NULL,
      sTax_desc TEXT NOT NULL,
      mTax_rate REAL NOT NULL,
      created_at TEXT
    )
  ''';

  final Database db;

  SalesTaxesTable(this.db);

  Future<void> createOrUpdateTaxes(List<SalesTaxEntity> taxes) async {
    dev.log('Starting to save ${taxes.length} sales taxes to database');
    
    try {
      // First clear existing data
      await db.delete(tableName);
      dev.log('Cleared existing sales taxes data');

      final batch = db.batch();

      for (final tax in taxes) {
        batch.insert(
          tableName,
          {
            'sTax_cd': tax.taxCode,
            'sTax_desc': tax.description,
            'mTax_rate': tax.taxRate,
            'created_at': DateTime.now().toIso8601String(),
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
      dev.log('Successfully saved all sales taxes to database');
    } catch (e) {
      dev.log('Error saving sales taxes to database: $e');
      throw Exception('Failed to save sales taxes: $e');
    }
  }

  Future<List<SalesTaxEntity>> getAllTaxes() async {
    try {
      final taxesData = await db.query(tableName);
      dev.log('Retrieved ${taxesData.length} sales taxes from database');

      return taxesData.map((tax) => SalesTaxEntity(
        id: tax['id'] as int?,
        taxCode: tax['sTax_cd'] as String,
        description: tax['sTax_desc'] as String,
        taxRate: tax['mTax_rate'] as double,
        createdAt: tax['created_at'] as String?,
      )).toList();
    } catch (e) {
      dev.log('Error retrieving sales taxes: $e');
      throw Exception('Failed to retrieve sales taxes: $e');
    }
  }

  Future<SalesTaxEntity?> getTaxByCode(String taxCode) async {
    try {
      final taxes = await db.query(
        tableName,
        where: 'sTax_cd = ?',
        whereArgs: [taxCode],
        limit: 1,
      );

      if (taxes.isEmpty) {
        dev.log('No tax found for code: $taxCode');
        return null;
      }

      return SalesTaxEntity(
        id: taxes.first['id'] as int?,
        taxCode: taxes.first['sTax_cd'] as String,
        description: taxes.first['sTax_desc'] as String,
        taxRate: taxes.first['mTax_rate'] as double,
        createdAt: taxes.first['created_at'] as String?,
      );
    } catch (e) {
      dev.log('Error retrieving tax by code: $e');
      throw Exception('Failed to retrieve tax by code: $e');
    }
  }
}
