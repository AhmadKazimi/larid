import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../features/sync/domain/entities/customer_entity.dart';

part 'invoice_state.freezed.dart';

@freezed
class InvoiceState with _$InvoiceState {
  const factory InvoiceState({
    required CustomerEntity customer,
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
    @Default('Cash') String paymentType,
    String? errorMessage,
  }) = _InvoiceState;
  
  factory InvoiceState.initial(CustomerEntity customer) => InvoiceState(
    customer: customer,
  );
}
