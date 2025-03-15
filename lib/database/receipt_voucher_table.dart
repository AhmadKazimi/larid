import 'package:sqflite/sqflite.dart';

class ReceiptVoucherTable {
  static const String tableName = 'receipt_vouchers';

  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      customer_cd TEXT NOT NULL,
      customer_name TEXT NOT NULL,
      paid_amt REAL NOT NULL,
      description TEXT,
      payment_type TEXT NOT NULL,
      created_at TEXT NOT NULL,
      isSynced INTEGER DEFAULT 0,
      FOREIGN KEY (customer_cd) REFERENCES customers(customerCode)
    )
  ''';

  final Database db;

  ReceiptVoucherTable(this.db);

  Future<void> ensureSchema() async {
    await db.execute(createTableQuery);
  }

  Future<int> saveReceiptVoucher({
    required String customerCode,
    required String customerName,
    required double paidAmount,
    required int paymentType,
    String? description,
    int isSynced = 0,
  }) async {
    return await db.insert(tableName, {
      'customer_cd': customerCode,
      'customer_name': customerName,
      'paid_amt': paidAmount,
      'description': description,
      'payment_type': paymentType,
      'created_at': DateTime.now().toIso8601String(),
      'isSynced': isSynced,
    });
  }

  Future<List<Map<String, dynamic>>> getReceiptVouchers() async {
    return await db.query(tableName, orderBy: 'created_at DESC');
  }

  Future<List<Map<String, dynamic>>> getUnsyncedReceiptVouchers() async {
    return await db.query(
      tableName,
      where: 'isSynced = ?',
      whereArgs: [0],
      orderBy: 'created_at DESC',
    );
  }

  Future<int> updateSyncStatus(int id, int isSynced) async {
    return await db.update(
      tableName,
      {'isSynced': isSynced},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
