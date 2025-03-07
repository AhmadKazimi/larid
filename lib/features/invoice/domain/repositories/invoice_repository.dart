import 'package:larid/features/invoice/domain/entities/invoice_entity.dart';
import 'package:larid/features/invoice/domain/entities/invoice_item_entity.dart';

abstract class InvoiceRepository {
  /// Saves an invoice to the database
  Future<void> saveInvoice(InvoiceEntity invoice);

  /// Saves a list of invoice items to the database
  Future<void> saveInvoiceItems(List<InvoiceItemEntity> items);

  /// Gets all invoices from the database
  Future<List<InvoiceEntity>> getInvoices();

  /// Gets all items for a specific invoice
  Future<List<InvoiceItemEntity>> getInvoiceItems(String invoiceId);
}
