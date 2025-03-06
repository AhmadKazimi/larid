import 'package:sqflite/sqflite.dart';
import '../features/invoice/presentation/bloc/invoice_state.dart';
import '../features/sync/domain/entities/customer_entity.dart';

class InvoiceTable {
  static const String tableName = 'invoices';
  static const String invoiceItemsTableName = 'invoice_items';

  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      invoiceNumber TEXT NOT NULL,
      customerId TEXT NOT NULL,
      customerName TEXT NOT NULL,
      invoiceDate TEXT NOT NULL,
      subtotal REAL NOT NULL,
      discount REAL NOT NULL,
      salesTax REAL NOT NULL,
      grandTotal REAL NOT NULL,
      paymentType TEXT NOT NULL,
      isReturn INTEGER NOT NULL DEFAULT 0,
      isSynced INTEGER NOT NULL DEFAULT 0,
      FOREIGN KEY (customerId) REFERENCES customers(customerCode)
    )
  ''';

  static const String createInvoiceItemsTableQuery = '''
    CREATE TABLE IF NOT EXISTS $invoiceItemsTableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      invoiceId INTEGER NOT NULL,
      itemCode TEXT NOT NULL,
      description TEXT NOT NULL,
      quantity INTEGER NOT NULL,
      unitPrice REAL NOT NULL,
      totalPrice REAL NOT NULL,
      isReturn INTEGER NOT NULL DEFAULT 0,
      FOREIGN KEY (invoiceId) REFERENCES $tableName(id)
    )
  ''';

  final Database db;

  InvoiceTable(this.db);

  // Save a complete invoice with its items
  Future<int> saveInvoice({
    required String invoiceNumber,
    required CustomerEntity customer,
    required InvoiceState invoiceState,
    required bool isReturn,
  }) async {
    // Begin transaction
    return await db.transaction((txn) async {
      // Insert the invoice header
      final invoiceId = await txn.insert(
        tableName,
        {
          'invoiceNumber': invoiceNumber,
          'customerId': customer.customerCode,
          'customerName': customer.customerName,
          'invoiceDate': DateTime.now().toIso8601String(),
          'subtotal': invoiceState.subtotal,
          'discount': invoiceState.discount,
          'salesTax': invoiceState.salesTax,
          'grandTotal': invoiceState.grandTotal,
          'paymentType': invoiceState.paymentType.toString(),
          'isReturn': isReturn ? 1 : 0,
          'isSynced': 0,
        },
      );

      // Insert all invoice items
      final items = isReturn ? invoiceState.returnItems : invoiceState.items;
      final batch = txn.batch();

      for (final item in items) {
        batch.insert(
          invoiceItemsTableName,
          {
            'invoiceId': invoiceId,
            'itemCode': item.item.itemCode,
            'description': item.item.description,
            'quantity': item.quantity,
            'unitPrice': item.item.sellUnitPrice,
            'totalPrice': item.totalPrice,
            'isReturn': isReturn ? 1 : 0,
          },
        );
      }

      await batch.commit();
      return invoiceId;
    });
  }

  // Get all unsynchronized invoices
  Future<List<Map<String, dynamic>>> getUnsyncedInvoices() async {
    final List<Map<String, dynamic>> invoices = await db.query(
      tableName,
      where: 'isSynced = ?',
      whereArgs: [0],
    );

    // For each invoice, get its items
    for (var i = 0; i < invoices.length; i++) {
      final invoiceId = invoices[i]['id'];
      final List<Map<String, dynamic>> items = await db.query(
        invoiceItemsTableName,
        where: 'invoiceId = ?',
        whereArgs: [invoiceId],
      );
      
      invoices[i]['items'] = items;
    }

    return invoices;
  }

  // Mark invoices as synchronized
  Future<void> markInvoicesAsSynced(List<int> invoiceIds) async {
    final batch = db.batch();
    
    for (final id in invoiceIds) {
      batch.update(
        tableName,
        {'isSynced': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
    
    await batch.commit();
  }

  // Get all invoices for a specific customer
  Future<List<Map<String, dynamic>>> getInvoicesForCustomer(String customerId) async {
    final List<Map<String, dynamic>> invoices = await db.query(
      tableName,
      where: 'customerId = ?',
      whereArgs: [customerId],
      orderBy: 'invoiceDate DESC',
    );

    // For each invoice, get its items
    for (var i = 0; i < invoices.length; i++) {
      final invoiceId = invoices[i]['id'];
      final List<Map<String, dynamic>> items = await db.query(
        invoiceItemsTableName,
        where: 'invoiceId = ?',
        whereArgs: [invoiceId],
      );
      
      invoices[i]['items'] = items;
    }

    return invoices;
  }

  // Get an invoice by its ID with all items
  Future<Map<String, dynamic>?> getInvoiceById(int invoiceId) async {
    final List<Map<String, dynamic>> invoices = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [invoiceId],
    );

    if (invoices.isEmpty) {
      return null;
    }

    final invoice = invoices.first;
    
    // Get all items for this invoice
    final List<Map<String, dynamic>> items = await db.query(
      invoiceItemsTableName,
      where: 'invoiceId = ?',
      whereArgs: [invoiceId],
    );
    
    invoice['items'] = items;
    return invoice;
  }

  // Get the next invoice number (simple implementation)
  Future<String> getNextInvoiceNumber() async {
    // Get the highest invoice number
    final result = await db.rawQuery('SELECT MAX(CAST(invoiceNumber AS INTEGER)) as maxNumber FROM $tableName');
    final maxNumber = result.first['maxNumber'] as int? ?? 0;
    
    // Return the next number as a string with leading zeros
    return (maxNumber + 1).toString().padLeft(6, '0');
  }

  // Delete an invoice and all its items
  Future<void> deleteInvoice(int invoiceId) async {
    return await db.transaction((txn) async {
      // First delete all items
      await txn.delete(
        invoiceItemsTableName,
        where: 'invoiceId = ?',
        whereArgs: [invoiceId],
      );
      
      // Then delete the invoice
      await txn.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [invoiceId],
      );
    });
  }
}
