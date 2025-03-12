import 'package:larid/database/database_helper.dart';
import 'package:larid/features/invoice/domain/entities/invoice_entity.dart';
import 'package:larid/features/invoice/domain/entities/invoice_item_entity.dart';
import 'package:larid/features/invoice/domain/repositories/invoice_repository.dart';
import 'package:sqflite/sqflite.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final DatabaseHelper _dbHelper;

  InvoiceRepositoryImpl({required DatabaseHelper dbHelper})
    : _dbHelper = dbHelper;

  @override
  Future<void> saveInvoice(InvoiceEntity invoice) async {
    final db = await _dbHelper.database;

    await db.insert('invoices', {
      'id': invoice.id,
      'customer_id': invoice.customerId,
      'customer_name': invoice.customerName,
      'total_amount': invoice.totalAmount,
      'date': invoice.date.toIso8601String(),
      'status': invoice.status,
      'is_return': invoice.isReturn ? 1 : 0,
      'created_at': invoice.createdAt.toIso8601String(),
      'updated_at': invoice.updatedAt.toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> saveInvoiceItems(List<InvoiceItemEntity> items) async {
    final db = await _dbHelper.database;

    // Start a transaction for batch operations
    await db.transaction((txn) async {
      final Batch batch = txn.batch();

      for (var item in items) {
        batch.insert('invoice_items', {
          'id': item.id,
          'invoice_id': item.invoiceId,
          'item_code': item.itemCode,
          'description': item.description,
          'quantity': item.quantity,
          'unit_price': item.unitPrice,
          'total_price': item.totalPrice,
          'is_return': item.isReturn ? 1 : 0,
          'tax_code': item.taxCode,
          'taxable_flag': item.taxableFlag,
          'sell_unit_code': item.sellUnitCode,
          'tax_amt': item.tax_amt,
          'tax_pc': item.tax_pc,
          'created_at': item.createdAt.toIso8601String(),
          'updated_at': item.updatedAt.toIso8601String(),
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }

      await batch.commit();
    });
  }

  @override
  Future<List<InvoiceEntity>> getInvoices() async {
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'invoices',
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) {
      return InvoiceEntity(
        id: maps[i]['id'],
        customerId: maps[i]['customer_id'],
        customerName: maps[i]['customer_name'],
        totalAmount: maps[i]['total_amount'],
        date: DateTime.parse(maps[i]['date']),
        status: maps[i]['status'],
        isReturn: maps[i]['is_return'] == 1,
        createdAt: DateTime.parse(maps[i]['created_at']),
        updatedAt: DateTime.parse(maps[i]['updated_at']),
      );
    });
  }

  @override
  Future<List<InvoiceItemEntity>> getInvoiceItems(String invoiceId) async {
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'invoice_items',
      where: 'invoice_id = ?',
      whereArgs: [invoiceId],
    );

    return List.generate(maps.length, (i) {
      return InvoiceItemEntity(
        id: maps[i]['id'],
        invoiceId: maps[i]['invoice_id'],
        itemCode: maps[i]['item_code'],
        description: maps[i]['description'],
        quantity: maps[i]['quantity'],
        unitPrice: maps[i]['unit_price'],
        totalPrice: maps[i]['total_price'],
        isReturn: maps[i]['is_return'] == 1,
        taxCode: maps[i]['tax_code'],
        taxableFlag: maps[i]['taxable_flag'],
        sellUnitCode: maps[i]['sell_unit_code'],
        createdAt: DateTime.parse(maps[i]['created_at']),
        updatedAt: DateTime.parse(maps[i]['updated_at']),
      );
    });
  }
}
