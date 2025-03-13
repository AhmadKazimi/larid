import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import '../../../../features/sync/domain/entities/inventory/inventory_item_entity.dart';
import 'invoice_state.dart';

@immutable
abstract class InvoiceEvent extends Equatable {
  const InvoiceEvent();

  @override
  List<Object?> get props => [];
}

class InitializeInvoice extends InvoiceEvent {
  final String customerCode;
  final bool forceNew;
  final bool isReturn;

  const InitializeInvoice({
    required this.customerCode,
    this.forceNew = false,
    this.isReturn = false,
  });

  @override
  List<Object?> get props => [customerCode, forceNew, isReturn];
}

class NavigateToItemsPage extends InvoiceEvent {
  final bool isReturn;

  const NavigateToItemsPage({this.isReturn = false});

  @override
  List<Object?> get props => [isReturn];
}

class AddItems extends InvoiceEvent {
  final List<InvoiceItemModel> items;

  const AddItems({required this.items});

  @override
  List<Object?> get props => [items];
}

class RemoveItem extends InvoiceEvent {
  final InvoiceItemModel item;
  final bool isReturn;

  const RemoveItem({required this.item, this.isReturn = false});

  @override
  List<Object?> get props => [item, isReturn];
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

  @override
  List<Object?> get props => [item, quantity, isReturn];
}

class AddInvoiceItems extends InvoiceEvent {
  final Map<String, dynamic> items;

  const AddInvoiceItems({required this.items});

  @override
  List<Object?> get props => [items];
}

class AddReturnItems extends InvoiceEvent {
  final Map<String, dynamic> items;

  const AddReturnItems({required this.items});

  @override
  List<Object?> get props => [items];
}

class UpdateComment extends InvoiceEvent {
  final String comment;

  const UpdateComment({required this.comment});

  @override
  List<Object?> get props => [comment];
}

class CalculateInvoiceTotals extends InvoiceEvent {
  const CalculateInvoiceTotals();

  @override
  List<Object?> get props => [];
}

class UpdatePaymentType extends InvoiceEvent {
  final String paymentType;

  const UpdatePaymentType({required this.paymentType});

  @override
  List<Object?> get props => [paymentType];
}

class SyncInvoice extends InvoiceEvent {
  const SyncInvoice();

  @override
  List<Object?> get props => [];
}

class SubmitInvoice extends InvoiceEvent {
  final bool isReturn;

  const SubmitInvoice({this.isReturn = false});

  @override
  List<Object?> get props => [isReturn];
}

class PrintInvoice extends InvoiceEvent {
  const PrintInvoice();

  @override
  List<Object?> get props => [];
}

class SaveInvoice extends InvoiceEvent {
  final String customerId;
  final String customerName;
  final double totalAmount;
  final Map<String, dynamic>? items;
  final bool hasReturnItems;

  const SaveInvoice({
    required this.customerId,
    required this.customerName,
    required this.totalAmount,
    this.items,
    this.hasReturnItems = false,
  });

  @override
  List<Object?> get props => [
    customerId,
    customerName,
    totalAmount,
    items,
    hasReturnItems,
  ];
}

class GetInvoices extends InvoiceEvent {
  const GetInvoices();

  @override
  List<Object?> get props => [];
}

class DeleteInvoice extends InvoiceEvent {
  final int invoiceId;

  const DeleteInvoice({required this.invoiceId});

  @override
  List<Object?> get props => [invoiceId];
}
