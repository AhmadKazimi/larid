import 'dart:developer' as dev;
import 'package:sqflite/sqflite.dart';
import '../features/sync/domain/entities/company_info_entity.dart';

class CompanyInfoTable {
  static const String tableName = 'company_info';

  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      id INTEGER PRIMARY KEY,
      company_name TEXT NOT NULL,
      address1 TEXT,
      address2 TEXT,
      address3 TEXT,
      phone TEXT,
      tax_id TEXT,
      created_at TEXT
    )
  ''';

  final Database db;

  CompanyInfoTable(this.db);

  Future<void> saveCompanyInfo(CompanyInfoEntity companyInfo) async {
    dev.log('Saving company info to database: ${companyInfo.companyName}');

    try {
      // First check if table exists
      final tableCheck = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName'",
      );

      if (tableCheck.isEmpty) {
        dev.log('Company info table does not exist, creating it');
        await db.execute(createTableQuery);
      }

      // First clear existing data as we always have only one company
      final deletedRows = await db.delete(tableName);
      dev.log('Cleared existing company info data: $deletedRows rows deleted');

      // Insert new company info with ID 1 (we only have one company)
      final insertId = await db.insert(tableName, {
        'id': 1,
        'company_name': companyInfo.companyName,
        'address1': companyInfo.address1,
        'address2': companyInfo.address2,
        'address3': companyInfo.address3,
        'phone': companyInfo.phone,
        'tax_id': companyInfo.taxId,
        'created_at': DateTime.now().toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      dev.log('Successfully saved company info to database with ID: $insertId');

      // Verify data was saved
      final verification = await getCompanyInfo();
      if (verification != null) {
        dev.log('Verification successful: ${verification.companyName}');
      } else {
        dev.log('Verification failed: could not retrieve saved company info');
      }
    } catch (e, stackTrace) {
      dev.log('Error saving company info to database: $e\n$stackTrace');
      throw Exception('Failed to save company info: $e');
    }
  }

  Future<CompanyInfoEntity?> getCompanyInfo() async {
    try {
      // Check if table exists first
      final tableCheck = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName'",
      );

      if (tableCheck.isEmpty) {
        dev.log('Company info table does not exist');
        return null;
      }

      final results = await db.query(tableName, limit: 1);

      if (results.isEmpty) {
        dev.log('No company info found in database');
        return null;
      }

      final data = results.first;
      dev.log('Retrieved company info: ${data['company_name']}');

      return CompanyInfoEntity(
        companyName: data['company_name'] as String,
        address1: data['address1'] as String? ?? '',
        address2: data['address2'] as String? ?? '',
        address3: data['address3'] as String? ?? '',
        phone: data['phone'] as String? ?? '',
        taxId: data['tax_id'] as String? ?? '',
      );
    } catch (e, stackTrace) {
      dev.log('Error retrieving company info from database: $e\n$stackTrace');
      throw Exception('Failed to get company info: $e');
    }
  }

  Future<void> deleteCompanyInfo() async {
    try {
      await db.delete(tableName);
      dev.log('Deleted all company info from database');
    } catch (e) {
      dev.log('Error deleting company info from database: $e');
      throw Exception('Failed to delete company info: $e');
    }
  }
}
