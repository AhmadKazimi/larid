import 'package:larid/features/summary/domain/entities/summary_item_entity.dart';

abstract class SummaryRepository {
  /// Gets all invoices from the database
  Future<List<SummaryItemEntity>> getInvoices({bool returnInvoices = false});

  /// Gets all receipt vouchers from the database
  Future<List<SummaryItemEntity>> getReceiptVouchers();

  /// Update sync status of an invoice
  Future<void> updateInvoiceSyncStatus(String id, bool isSynced);

  /// Update sync status of a receipt voucher
  Future<void> updateReceiptVoucherSyncStatus(String id, bool isSynced);
}
