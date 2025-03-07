import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../features/sync/domain/entities/customer_entity.dart';
import '../../../../features/sync/domain/entities/inventory/inventory_item_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:larid/features/invoice/domain/entities/invoice_entity.dart';

part 'invoice_state.freezed.dart';

@freezed
class InvoiceState with _$InvoiceState {
  const factory InvoiceState({
    required CustomerEntity customer,
    @Default(<InvoiceItemModel>[]) List<InvoiceItemModel> items,
    @Default(<InvoiceItemModel>[]) List<InvoiceItemModel> returnItems,
    @Default(0) int itemCount,
    @Default(0) int returnCount,
    @Default(0.0) double subtotal,
    @Default(0.0) double discount,
    @Default(0.0) double total,
    @Default(0.0) double salesTax,
    @Default(0.0) double grandTotal,
    @Default(0.0) double returnSubtotal,
    @Default(0.0) double returnDiscount,
    @Default(0.0) double returnTotal,
    @Default(0.0) double returnSalesTax,
    @Default(0.0) double returnGrandTotal,
    @Default('') String comment,
    @Default(false) bool isSubmitting,
    @Default(false) bool isSyncing,
    @Default(false) bool isPrinting,
    @Default(false) bool isSubmitted,
    @Default('Cash') String paymentType,
    String? invoiceNumber,
    String? errorMessage,
    @Default(false) bool isLoading,
  }) = _InvoiceState;

  factory InvoiceState.initial(CustomerEntity customer) =>
      InvoiceState(customer: customer);
}

@freezed
class InvoiceItemModel with _$InvoiceItemModel {
  const factory InvoiceItemModel({
    required InventoryItemEntity item,
    required int quantity,
    required double totalPrice,
    @Default(0.0) double discount,
    @Default(0.0) double tax,
  }) = _InvoiceItemModel;

  factory InvoiceItemModel.fromInventoryItem({
    required InventoryItemEntity item,
    required int quantity,
  }) {
    final totalPrice = item.sellUnitPrice * quantity;
    // Tax will be calculated later based on tax rules

    return InvoiceItemModel(
      item: item,
      quantity: quantity,
      totalPrice: totalPrice,
    );
  }
}

// Bloc-specific states
abstract class InvoiceBlocState extends Equatable {
  const InvoiceBlocState();

  @override
  List<Object?> get props => [];
}

class InvoiceInitial extends InvoiceBlocState {}

class InvoiceSaving extends InvoiceBlocState {}

class InvoiceSaved extends InvoiceBlocState {}

class InvoicesLoading extends InvoiceBlocState {}

class InvoicesLoaded extends InvoiceBlocState {
  final List<InvoiceEntity> invoices;

  const InvoicesLoaded({required this.invoices});

  @override
  List<Object?> get props => [invoices];
}

class InvoiceError extends InvoiceBlocState {
  final String message;

  const InvoiceError({required this.message});

  @override
  List<Object?> get props => [message];
}
