import 'package:sqflite/sqflite.dart';

class ReceiptVoucherTable {
  static const String tableName = 'receipt_vouchers';

  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      customer_cd TEXT NOT NULL,
      paid_amt REAL NOT NULL,
      description TEXT,
      payment_type TEXT NOT NULL,
      comment TEXT,
      created_at TEXT NOT NULL,
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
    required double paidAmount,
    required String paymentType,
    String? description,
    String? comment,
  }) async {
    return await db.insert(tableName, {
      'customer_cd': customerCode,
      'paid_amt': paidAmount,
      'description': description,
      'payment_type': paymentType,
      'comment': comment,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getReceiptVouchers() async {
    return await db.query(tableName, orderBy: 'created_at DESC');
  }
}
