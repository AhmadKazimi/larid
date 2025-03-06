import 'package:flutter/foundation.dart';
import 'package:larid/features/sync/domain/entities/inventory/inventory_item_entity.dart';
import 'invoice_state.dart';

@immutable
abstract class InvoiceEvent {
  const InvoiceEvent();
}

class InitializeInvoice extends InvoiceEvent {
  final String customerCode;
  
  const InitializeInvoice({required this.customerCode});
}

class NavigateToItemsPage extends InvoiceEvent {
  final bool isReturn;
  
  const NavigateToItemsPage({this.isReturn = false});
}

class AddItems extends InvoiceEvent {
  final List<InvoiceItemModel> items;
  
  const AddItems({required this.items});
}

class RemoveItem extends InvoiceEvent {
  final InvoiceItemModel item;
  final bool isReturn;
  
  const RemoveItem({
    required this.item,
    this.isReturn = false,
  });
}

class UpdateItemQuantity extends InvoiceEvent {
  final InvoiceItemModel item;
  final int quantity;
  final bool isReturn;
  
  const UpdateItemQuantity({
    required this.item,
    required this.quantity,
    this.isReturn = false,
  });
}

class AddInvoiceItems extends InvoiceEvent {
  final Map<String, dynamic> items;
  
  const AddInvoiceItems({required this.items});
}

class AddReturnItems extends InvoiceEvent {
  final Map<String, dynamic> items;
  
  const AddReturnItems({required this.items});
}

class UpdateComment extends InvoiceEvent {
  final String comment;
  
  const UpdateComment({required this.comment});
}

class CalculateInvoiceTotals extends InvoiceEvent {
  const CalculateInvoiceTotals();
}

class UpdatePaymentType extends InvoiceEvent {
  final String paymentType;
  
  const UpdatePaymentType({required this.paymentType});
}

class SyncInvoice extends InvoiceEvent {
  const SyncInvoice();
}

class SubmitInvoice extends InvoiceEvent {
  final bool isReturn;
  
  const SubmitInvoice({this.isReturn = false});
}

class PrintInvoice extends InvoiceEvent {
  const PrintInvoice();
}
