import 'package:larid/database/invoice_table.dart';
import 'package:larid/database/receipt_voucher_table.dart';
import 'package:larid/features/summary/domain/entities/summary_item_entity.dart';
import 'package:larid/features/summary/domain/repositories/summary_repository.dart';
import 'package:larid/core/l10n/app_localizations.dart';

class SummaryRepositoryImpl implements SummaryRepository {
  final InvoiceTable _invoiceTable;
  final ReceiptVoucherTable _receiptVoucherTable;

  SummaryRepositoryImpl({
    required InvoiceTable invoiceTable,
    required ReceiptVoucherTable receiptVoucherTable,
  }) : _invoiceTable = invoiceTable,
       _receiptVoucherTable = receiptVoucherTable;

  @override
  Future<List<SummaryItemEntity>> getInvoices({
    bool returnInvoices = false,
  }) async {
    try {
      // Get all invoices or return invoices based on the parameter
      final invoices = await _invoiceTable.getAllInvoices(
        isReturn: returnInvoices,
      );

      return invoices
          .map(
            (invoice) => SummaryItemEntity(
              id: invoice['id'].toString(),
              title: 'Invoice #${invoice['invoiceNumber']}',
              subtitle: invoice['customerName'],
              date: DateTime.parse(invoice['invoiceDate']),
              amount: invoice['grandTotal'],
              isSynced: invoice['isSynced'] == 1,
              details: invoice['comment'],
            ),
          )
          .toList();
    } catch (e) {
      print('Error fetching invoices: $e');
      return [];
    }
  }

  @override
  Future<List<SummaryItemEntity>> getReceiptVouchers() async {
    try {
      final vouchers = await _receiptVoucherTable.getReceiptVouchers();

      return vouchers.map((voucher) {
        // Convert payment type code to readable string
        String paymentType = _getPaymentTypeString(voucher['payment_type']);

        return SummaryItemEntity(
          id: voucher['id'].toString(),
          title: 'Voucher #${voucher['id']}',
          subtitle: '${voucher['customer_name']} - $paymentType',
          date: DateTime.parse(voucher['created_at']),
          amount: voucher['paid_amt'],
          isSynced: voucher['isSynced'] == 1,
          details: voucher['description'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching receipt vouchers: $e');
      return [];
    }
  }

  @override
  Future<void> updateInvoiceSyncStatus(String id, bool isSynced) async {
    await _invoiceTable.updateSyncStatus(int.parse(id), isSynced ? 1 : 0);
  }

  @override
  Future<void> updateReceiptVoucherSyncStatus(String id, bool isSynced) async {
    await _receiptVoucherTable.updateSyncStatus(
      int.parse(id),
      isSynced ? 1 : 0,
    );
  }

  // Helper method to convert payment type code to readable string
  String _getPaymentTypeString(dynamic paymentType) {
    int type = 0;
    if (paymentType is String) {
      type = int.tryParse(paymentType) ?? 0;
    } else if (paymentType is int) {
      type = paymentType;
    }

    switch (type) {
      case 0:
        return 'Cash';
      case 1:
        return 'Credit Card';
      case 2:
        return 'Check';
      case 3:
        return 'Bank Transfer';
      default:
        return 'Other';
    }
  }
}
