import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../database/customer_table.dart';
import '../../../../features/sync/domain/entities/customer_entity.dart';
import 'invoice_event.dart';
import 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final CustomerTable _customerTable = getIt<CustomerTable>();
  
  InvoiceBloc() : super(InvoiceState.initial(CustomerEntity(
    customerCode: "",
    customerName: "",
  ))) {
    on<InitializeInvoice>(_onInitializeInvoice);
    on<AddItem>(_onAddItem);
    on<ReturnItem>(_onReturnItem);
    on<UpdateComment>(_onUpdateComment);
    on<SyncInvoice>(_onSyncInvoice);
    on<SubmitInvoice>(_onSubmitInvoice);
    on<PrintInvoice>(_onPrintInvoice);
  }

  // Sample handler implementations
  void _onInitializeInvoice(InitializeInvoice event, Emitter<InvoiceState> emit) async {
    try {
      final customer = await _customerTable.getCustomerByCode(event.customerCode);
      if (customer != null) {
        emit(InvoiceState.initial(customer));
      } else {
        emit(state.copyWith(errorMessage: 'Customer not found'));
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void _onAddItem(AddItem event, Emitter<InvoiceState> emit) {
    // Demo values for UI presentation
    final newItemCount = state.itemCount + 1;
    final newSubtotal = state.subtotal + 50.0;
    final newDiscount = state.discount + 5.0;
    final newTotal = newSubtotal - newDiscount;
    final newSalesTax = newTotal * 0.15;
    final newGrandTotal = newTotal + newSalesTax;
    
    emit(state.copyWith(
      itemCount: newItemCount,
      subtotal: newSubtotal,
      discount: newDiscount,
      total: newTotal,
      salesTax: newSalesTax,
      grandTotal: newGrandTotal,
      errorMessage: null,
    ));
  }

  void _onReturnItem(ReturnItem event, Emitter<InvoiceState> emit) {
    // Demo values for UI presentation
    final newReturnCount = state.returnCount + 1;
    final newReturnSubtotal = state.returnSubtotal + 25.0;
    final newReturnDiscount = state.returnDiscount + 2.5;
    final newReturnTotal = newReturnSubtotal - newReturnDiscount;
    final newReturnSalesTax = newReturnTotal * 0.15;
    final newReturnGrandTotal = newReturnTotal + newReturnSalesTax;
    
    emit(state.copyWith(
      returnCount: newReturnCount,
      returnSubtotal: newReturnSubtotal,
      returnDiscount: newReturnDiscount,
      returnTotal: newReturnTotal,
      returnSalesTax: newReturnSalesTax,
      returnGrandTotal: newReturnGrandTotal,
      errorMessage: null,
    ));
  }

  void _onUpdateComment(UpdateComment event, Emitter<InvoiceState> emit) {
    emit(state.copyWith(
      comment: event.comment,
      errorMessage: null,
    ));
  }

  void _onSyncInvoice(SyncInvoice event, Emitter<InvoiceState> emit) async {
    emit(state.copyWith(isSyncing: true, errorMessage: null));
    
    // Simulate sync operation
    await Future.delayed(const Duration(seconds: 1));
    
    emit(state.copyWith(isSyncing: false));
  }

  void _onSubmitInvoice(SubmitInvoice event, Emitter<InvoiceState> emit) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null));
    
    // Simulate submit operation
    await Future.delayed(const Duration(seconds: 1));
    
    emit(state.copyWith(isSubmitting: false));
  }

  void _onPrintInvoice(PrintInvoice event, Emitter<InvoiceState> emit) async {
    emit(state.copyWith(isPrinting: true, errorMessage: null));
    
    // Simulate print operation
    await Future.delayed(const Duration(seconds: 1));
    
    emit(state.copyWith(isPrinting: false));
  }
}
