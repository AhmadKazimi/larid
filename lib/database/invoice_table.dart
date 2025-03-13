import 'package:sqflite/sqflite.dart';
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
      comment TEXT,
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
      taxCode TEXT,
      taxableFlag INTEGER DEFAULT 0,
      tax_amt REAL DEFAULT 0,
      tax_pc REAL DEFAULT 0,
      sellUnitCode TEXT,
      FOREIGN KEY (invoiceId) REFERENCES $tableName(id)
    )
  ''';

  final Database db;

  InvoiceTable(this.db);

  // Save a complete invoice with its items
  Future<int> saveInvoice({
    required String invoiceNumber,
    required CustomerEntity customer,
    required dynamic invoiceState,
    required bool isReturn,
  }) async {
    // Begin transaction
    print(
      'Saving invoice: $invoiceNumber for customer: ${customer.customerCode}, isReturn: $isReturn',
    );
    try {
      return await db.transaction((txn) async {
        // Insert the invoice header
        print('Inserting invoice header...');
        print(
          'Customer data: ID=${customer.customerCode}, Name=${customer.customerName}',
        );

        final Map<String, dynamic> invoiceData = {
          'invoiceNumber': invoiceNumber,
          'customerId': customer.customerCode,
          'customerName': customer.customerName,
          'invoiceDate': DateTime.now().toIso8601String(),
          'subtotal':
              isReturn ? invoiceState.returnSubtotal : invoiceState.subtotal,
          'discount':
              isReturn ? invoiceState.returnDiscount : invoiceState.discount,
          'salesTax':
              isReturn ? invoiceState.returnSalesTax : invoiceState.salesTax,
          'grandTotal':
              isReturn
                  ? invoiceState.returnGrandTotal
                  : invoiceState.grandTotal,
          'paymentType': invoiceState.paymentType.toString(),
          'comment': invoiceState.comment,
          'isReturn': isReturn ? 1 : 0,
          'isSynced': 0,
        };

        print('Invoice data: ${invoiceData.toString()}');

        final invoiceId = await txn.insert(tableName, invoiceData);
        print('Invoice inserted with ID: $invoiceId');

        // Insert all invoice items for this invoice type (regular or return)
        final items = isReturn ? invoiceState.returnItems : invoiceState.items;
        print('Inserting ${items.length} items for invoice ID: $invoiceId');

        final batch = txn.batch();

        for (final item in items) {
          print(
            'Adding item: ${item.item.itemCode}, quantity: ${item.quantity}',
          );
          batch.insert(invoiceItemsTableName, {
            'invoiceId': invoiceId,
            'itemCode': item.item.itemCode,
            'description': item.item.description,
            'quantity': item.quantity,
            'unitPrice': item.item.sellUnitPrice,
            'totalPrice': item.totalPrice,
            'isReturn': isReturn ? 1 : 0,
            'taxCode': item.item.taxCode,
            'taxableFlag': item.item.taxableFlag,
            'tax_amt': item.taxAmount,
            'tax_pc': item.taxRate,
            'sellUnitCode': item.item.sellUnitCode,
          });
        }

        await batch.commit();
        print('Committed ${items.length} items for invoice ID: $invoiceId');

        print('Successfully saved invoice ID: $invoiceId');
        return invoiceId;
      });
    } catch (e) {
      print('Error saving invoice: $e');
      throw e;
    }
  }

  // Update an existing invoice with its items
  Future<int> updateInvoice({
    required String invoiceNumber,
    required CustomerEntity customer,
    required dynamic invoiceState,
    required bool isReturn,
  }) async {
    // Begin transaction
    print(
      'Updating invoice: $invoiceNumber for customer: ${customer.customerCode}, isReturn: $isReturn',
    );
    try {
      return await db.transaction((txn) async {
        // Find the invoice ID by invoice number
        final List<Map<String, dynamic>> invoiceResult = await txn.query(
          tableName,
          columns: ['id'],
          where: 'invoiceNumber = ?',
          whereArgs: [invoiceNumber],
        );

        if (invoiceResult.isEmpty) {
          print(
            'Invoice not found for updating, invoice number: $invoiceNumber',
          );
          throw Exception('Invoice not found for updating');
        }

        final int invoiceId = invoiceResult.first['id'] as int;
        print('Found invoice ID: $invoiceId for update');

        // Update the invoice header with appropriate values based on isReturn
        final Map<String, dynamic> invoiceData = {
          'customerId': customer.customerCode,
          'customerName': customer.customerName,
          'subtotal':
              isReturn ? invoiceState.returnSubtotal : invoiceState.subtotal,
          'discount':
              isReturn ? invoiceState.returnDiscount : invoiceState.discount,
          'salesTax':
              isReturn ? invoiceState.returnSalesTax : invoiceState.salesTax,
          'grandTotal':
              isReturn
                  ? invoiceState.returnGrandTotal
                  : invoiceState.grandTotal,
          'paymentType': invoiceState.paymentType.toString(),
          'comment': invoiceState.comment,
          'isReturn': isReturn ? 1 : 0,
          'isSynced': 0, // Reset sync status
        };

        print('Invoice update data: ${invoiceData.toString()}');

        await txn.update(
          tableName,
          invoiceData,
          where: 'id = ?',
          whereArgs: [invoiceId],
        );

        print('Invoice header updated for ID: $invoiceId');

        // Delete all existing items for this invoice
        print('Deleting existing items for invoice ID: $invoiceId');

        final int deletedCount = await txn.delete(
          invoiceItemsTableName,
          where: 'invoiceId = ?',
          whereArgs: [invoiceId],
        );

        print(
          'Deleted $deletedCount existing items for invoice ID: $invoiceId',
        );

        // Insert all items - only the relevant type (regular or return)
        print('Inserting new items for invoice ID: $invoiceId');

        final batch = txn.batch();

        // Add only the items for this invoice type
        final items = isReturn ? invoiceState.returnItems : invoiceState.items;
        print('Adding ${items.length} items (isReturn: $isReturn)');

        for (final item in items) {
          print(
            'Adding item: ${item.item.itemCode}, quantity: ${item.quantity}',
          );
          batch.insert(invoiceItemsTableName, {
            'invoiceId': invoiceId,
            'itemCode': item.item.itemCode,
            'description': item.item.description,
            'quantity': item.quantity,
            'unitPrice': item.item.sellUnitPrice,
            'totalPrice': item.totalPrice,
            'isReturn': isReturn ? 1 : 0,
            'taxCode': item.item.taxCode,
            'taxableFlag': item.item.taxableFlag,
            'tax_amt': item.taxAmount,
            'tax_pc': item.taxRate,
            'sellUnitCode': item.item.sellUnitCode,
          });
        }

        await batch.commit();
        print('Committed all items for updated invoice ID: $invoiceId');

        return invoiceId;
      });
    } catch (e) {
      print('Error updating invoice: $e');
      throw e;
    }
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
  Future<List<Map<String, dynamic>>> getInvoicesForCustomer(
    String customerId,
  ) async {
    try {
      print('===== GETTING INVOICES FOR CUSTOMER: $customerId =====');

      // First try to find the customer to make sure it exists
      final List<Map<String, dynamic>> customers = await db.query(
        'customers',
        where: 'customerCode = ?',
        whereArgs: [customerId],
      );

      print(
        'Customer found in database: ${customers.isNotEmpty ? 'YES' : 'NO'}',
      );
      if (customers.isNotEmpty) {
        print('Customer name: ${customers.first['customerName']}');
      } else {
        print('Customer not found in database, returning empty invoice list');
        return [];
      }

      // Now get the invoices with a raw query to see exactly what's happening
      final List<Map<String, dynamic>> rawInvoices = await db.rawQuery(
        'SELECT * FROM $tableName WHERE customerId = ? ORDER BY invoiceDate DESC',
        [customerId],
      );

      print(
        'Raw query found ${rawInvoices.length} invoices for customer: $customerId',
      );

      if (rawInvoices.isEmpty) {
        print('No invoices found for customer: $customerId');
        return [];
      }

      // Create modifiable copies of the query results
      final List<Map<String, dynamic>> invoices =
          rawInvoices
              .map((invoice) => Map<String, dynamic>.from(invoice))
              .toList();

      // Detailed invoice information
      for (var invoice in invoices) {
        print('\n----- INVOICE DETAILS -----');
        print('ID: ${invoice['id']}');
        print('Invoice Number: ${invoice['invoiceNumber']}');
        print('Customer ID: ${invoice['customerId']}');
        print('Subtotal: ${invoice['subtotal']}');
        print('Discount: ${invoice['discount']}');
        print('Sales Tax: ${invoice['salesTax']}');
        print('Grand Total: ${invoice['grandTotal']}');
        print('Is Return: ${invoice['isReturn'] == 1 ? "Yes" : "No"}');
        print('Is Synced: ${invoice['isSynced']}');
        print('----------------------------\n');
      }

      // For each invoice, get its items with more detailed logging
      for (var i = 0; i < invoices.length; i++) {
        final invoiceId = invoices[i]['id'];
        if (invoiceId == null) {
          print(
            'WARNING: Invoice at index $i has null id, skipping item retrieval',
          );
          invoices[i]['items'] = [];
          continue;
        }

        print('\n>>>>> Getting items for invoice ID: $invoiceId <<<<<');

        try {
          // Use raw query to get more information
          final List<Map<String, dynamic>> rawItems = await db.rawQuery(
            'SELECT * FROM $invoiceItemsTableName WHERE invoiceId = ?',
            [invoiceId],
          );

          // Create modifiable copies of the item query results
          final List<Map<String, dynamic>> items =
              rawItems.map((item) => Map<String, dynamic>.from(item)).toList();

          print('Found ${items.length} items for invoice ID: $invoiceId');

          // Log all items for this invoice
          if (items.isNotEmpty) {
            print('\n----- ITEM DETAILS FOR INVOICE $invoiceId -----');
            for (var j = 0; j < items.length; j++) {
              final item = items[j];
              print('Item ${j + 1}:');
              print('  - ID: ${item['id']}');
              print('  - Item Code: ${item['itemCode']}');
              print('  - Description: ${item['description']}');
              print('  - Quantity: ${item['quantity']}');
              print('  - Unit Price: ${item['unitPrice']}');
              print('  - Total Price: ${item['totalPrice']}');
              print('  - Is Return: ${item['isReturn']}');
              print('  - Tax Code: ${item['taxCode']}');
              print('  - Taxable Flag: ${item['taxableFlag']}');
              print('  - Tax Amount: ${item['tax_amt']}');
              print('  - Tax Percentage: ${item['tax_pc']}');
              print('  - Sell Unit Code: ${item['sellUnitCode']}');
            }
            print('-------------------------------------------\n');
          } else {
            print('NO ITEMS FOUND FOR INVOICE $invoiceId');
          }

          // Add the items to the invoice
          invoices[i]['items'] = items;
        } catch (e) {
          print('ERROR getting items for invoice $invoiceId: $e');
          invoices[i]['items'] = []; // Add empty items list on error
        }
      }

      print('===== FINISHED GETTING INVOICES FOR CUSTOMER $customerId =====');
      return invoices;
    } catch (e, stackTrace) {
      print('ERROR getting invoices for customer: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
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
    final result = await db.rawQuery(
      'SELECT MAX(CAST(invoiceNumber AS INTEGER)) as maxNumber FROM $tableName',
    );
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
      await txn.delete(tableName, where: 'id = ?', whereArgs: [invoiceId]);
    });
  }

  // Method to ensure all required columns exist in the tables
  Future<void> ensureSchema() async {
    try {
      // Check for missing columns in invoices table
      final invoiceInfoMap = await db.rawQuery('PRAGMA table_info($tableName)');
      final invoiceColumns =
          invoiceInfoMap.map((col) => col['name'] as String).toList();

      // No longer need to check for return fields since we use separate records now

      if (!invoiceColumns.contains('comment')) {
        await db.execute('ALTER TABLE $tableName ADD COLUMN comment TEXT');
      }

      // Check for missing columns in invoice_items table
      final itemsInfoMap = await db.rawQuery(
        'PRAGMA table_info($invoiceItemsTableName)',
      );
      final itemsColumns =
          itemsInfoMap.map((col) => col['name'] as String).toList();

      if (!itemsColumns.contains('taxCode')) {
        await db.execute(
          'ALTER TABLE $invoiceItemsTableName ADD COLUMN taxCode TEXT',
        );
      }
      if (!itemsColumns.contains('taxableFlag')) {
        await db.execute(
          'ALTER TABLE $invoiceItemsTableName ADD COLUMN taxableFlag INTEGER DEFAULT 0',
        );
      }
      if (!itemsColumns.contains('sellUnitCode')) {
        await db.execute(
          'ALTER TABLE $invoiceItemsTableName ADD COLUMN sellUnitCode TEXT',
        );
      }
      if (!itemsColumns.contains('tax_amt')) {
        await db.execute(
          'ALTER TABLE $invoiceItemsTableName ADD COLUMN tax_amt REAL DEFAULT 0',
        );
      }
      if (!itemsColumns.contains('tax_pc')) {
        await db.execute(
          'ALTER TABLE $invoiceItemsTableName ADD COLUMN tax_pc REAL DEFAULT 0',
        );
      }
    } catch (e) {
      print('Error ensuring schema: $e');
    }
  }
}
