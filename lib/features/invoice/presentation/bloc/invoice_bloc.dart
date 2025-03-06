import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../database/customer_table.dart';
import '../../../../database/inventory_items_table.dart';
import '../../../../database/invoice_table.dart';
import '../../../../features/sync/domain/entities/customer_entity.dart';
import '../../../../features/sync/domain/entities/inventory/inventory_item_entity.dart';
import 'invoice_event.dart';
import 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final CustomerTable _customerTable = getIt<CustomerTable>();
  final InventoryItemsTable _inventoryItemsTable = getIt<InventoryItemsTable>();
  final InvoiceTable _invoiceTable = getIt<InvoiceTable>();
  
  InvoiceBloc() : super(InvoiceState.initial(CustomerEntity(
    customerCode: "",
    customerName: "",
  ))) {
    on<InitializeInvoice>(_onInitializeInvoice);
    on<NavigateToItemsPage>(_onNavigateToItemsPage);
    on<AddItems>(_onAddItems);
    on<AddInvoiceItems>(_onAddInvoiceItems);
    on<AddReturnItems>(_onAddReturnItems);
    on<RemoveItem>(_onRemoveItem);
    on<UpdateItemQuantity>(_onUpdateItemQuantity);
    on<UpdateComment>(_onUpdateComment);
    on<CalculateInvoiceTotals>(_onCalculateInvoiceTotals);
    on<UpdatePaymentType>(_onUpdatePaymentType);
    on<SyncInvoice>(_onSyncInvoice);
    on<SubmitInvoice>(_onSubmitInvoice);
    on<PrintInvoice>(_onPrintInvoice);
  }

  // Handler implementations
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

  void _onNavigateToItemsPage(NavigateToItemsPage event, Emitter<InvoiceState> emit) {
    // This event doesn't change state, just triggers navigation in the UI
    // The navigation will be handled in the widget
  }

  void _onAddItems(AddItems event, Emitter<InvoiceState> emit) {
    final List<InvoiceItemModel> updatedItems = List.from(state.items);
    
    // Add new items or update existing ones
    for (final newItem in event.items) {
      final existingItemIndex = updatedItems.indexWhere(
        (item) => item.item.itemCode == newItem.item.itemCode
      );
      
      if (existingItemIndex != -1) {
        // Update existing item
        final existingItem = updatedItems[existingItemIndex];
        updatedItems[existingItemIndex] = InvoiceItemModel(
          item: existingItem.item,
          quantity: newItem.quantity,
          totalPrice: newItem.item.sellUnitPrice * newItem.quantity,
          discount: existingItem.discount,
          tax: existingItem.tax,
        );
      } else {
        // Add new item
        updatedItems.add(newItem);
      }
    }
    
    emit(state.copyWith(items: updatedItems));
    add(const CalculateInvoiceTotals());
  }
  
  void _onAddInvoiceItems(AddInvoiceItems event, Emitter<InvoiceState> emit) {
    final List<InvoiceItemModel> updatedItems = List.from(state.items);
    
    // Log the received data for debugging
    print('Processing invoice items: ${event.items.length} items');
    
    // Process the items from the Map<String, dynamic>
    for (final entry in event.items.entries) {
      final itemCode = entry.key;
      final itemData = entry.value as Map<String, dynamic>;
      final item = itemData['item'] as InventoryItemEntity;
      final quantity = itemData['quantity'] as int;
      
      // Calculate the total price
      final totalPrice = item.sellUnitPrice * quantity;
      
      // Create the invoice item model
      final newItem = InvoiceItemModel(
        item: item,
        quantity: quantity,
        totalPrice: totalPrice,
        // Default values for discount and tax can be set here or calculated based on business rules
        discount: 0,
        tax: 0,
      );
      
      // Check if the item already exists in the invoice
      final existingItemIndex = updatedItems.indexWhere(
        (invoiceItem) => invoiceItem.item.itemCode == itemCode
      );
      
      if (existingItemIndex != -1) {
        // Update existing item
        updatedItems[existingItemIndex] = newItem;
      } else {
        // Add new item
        updatedItems.add(newItem);
      }
    }
    
    // Update the state with the new items
    emit(state.copyWith(items: updatedItems));
    
    // Calculate the invoice totals
    add(const CalculateInvoiceTotals());
    
    // Log the updated state for debugging
    print('Updated invoice items count: ${updatedItems.length}');
  }

  void _onAddReturnItems(AddReturnItems event, Emitter<InvoiceState> emit) {
    final List<InvoiceItemModel> updatedReturnItems = List.from(state.returnItems);
    
    // Log the received data for debugging
    print('Processing return items: ${event.items.length} items');
    
    // Process the items from the Map<String, dynamic>
    for (final entry in event.items.entries) {
      final itemCode = entry.key;
      final itemData = entry.value as Map<String, dynamic>;
      final item = itemData['item'] as InventoryItemEntity;
      final quantity = itemData['quantity'] as int;
      
      // Calculate the total price
      final totalPrice = item.sellUnitPrice * quantity;
      
      // Create the invoice item model
      final newItem = InvoiceItemModel(
        item: item,
        quantity: quantity,
        totalPrice: totalPrice,
        // Default values for discount and tax can be set here or calculated based on business rules
        discount: 0,
        tax: 0,
      );
      
      // Check if the item already exists in the invoice
      final existingItemIndex = updatedReturnItems.indexWhere(
        (invoiceItem) => invoiceItem.item.itemCode == itemCode
      );
      
      if (existingItemIndex != -1) {
        // Update existing return item
        updatedReturnItems[existingItemIndex] = newItem;
      } else {
        // Add new return item
        updatedReturnItems.add(newItem);
      }
    }
    
    // Update the state with the new return items
    emit(state.copyWith(returnItems: updatedReturnItems));
    
    // Calculate the invoice totals
    add(const CalculateInvoiceTotals());
    
    // Log the updated state for debugging
    print('Updated return items count: ${updatedReturnItems.length}');
  }

  void _onRemoveItem(RemoveItem event, Emitter<InvoiceState> emit) {
    if (event.isReturn) {
      final List<InvoiceItemModel> updatedReturnItems = List.from(state.returnItems)
        ..removeWhere((item) => item.item.itemCode == event.item.item.itemCode);
      
      emit(state.copyWith(returnItems: updatedReturnItems));
    } else {
      final List<InvoiceItemModel> updatedItems = List.from(state.items)
        ..removeWhere((item) => item.item.itemCode == event.item.item.itemCode);
      
      emit(state.copyWith(items: updatedItems));
    }
    
    add(const CalculateInvoiceTotals());
  }

  void _onUpdateItemQuantity(UpdateItemQuantity event, Emitter<InvoiceState> emit) {
    if (event.quantity <= 0) {
      // Remove the item if quantity is 0 or negative
      add(RemoveItem(item: event.item, isReturn: event.isReturn));
      return;
    }
    
    if (event.isReturn) {
      final List<InvoiceItemModel> updatedReturnItems = List.from(state.returnItems);
      final itemIndex = updatedReturnItems.indexWhere(
        (item) => item.item.itemCode == event.item.item.itemCode
      );
      
      if (itemIndex != -1) {
        // Update existing item
        final existingItem = updatedReturnItems[itemIndex];
        updatedReturnItems[itemIndex] = existingItem.copyWith(
          quantity: event.quantity,
          totalPrice: existingItem.item.sellUnitPrice * event.quantity,
        );
        
        emit(state.copyWith(returnItems: updatedReturnItems));
      }
    } else {
      final List<InvoiceItemModel> updatedItems = List.from(state.items);
      final itemIndex = updatedItems.indexWhere(
        (item) => item.item.itemCode == event.item.item.itemCode
      );
      
      if (itemIndex != -1) {
        // Update existing item
        final existingItem = updatedItems[itemIndex];
        updatedItems[itemIndex] = existingItem.copyWith(
          quantity: event.quantity,
          totalPrice: existingItem.item.sellUnitPrice * event.quantity,
        );
        
        emit(state.copyWith(items: updatedItems));
      }
    }
    
    add(const CalculateInvoiceTotals());
  }

  void _onUpdateComment(UpdateComment event, Emitter<InvoiceState> emit) {
    emit(state.copyWith(
      comment: event.comment,
      errorMessage: null,
    ));
  }

  void _onCalculateInvoiceTotals(CalculateInvoiceTotals event, Emitter<InvoiceState> emit) {
    // Calculate invoice totals
    double subtotal = 0.0;
    double discount = 0.0;
    int itemCount = 0;
    
    for (final item in state.items) {
      subtotal += item.totalPrice;
      discount += item.discount;
      itemCount += item.quantity;
    }
    
    final total = subtotal - discount;
    final salesTax = total * 0.15; // Assuming 15% sales tax
    final grandTotal = total + salesTax;
    
    // Calculate return totals
    double returnSubtotal = 0.0;
    double returnDiscount = 0.0;
    int returnCount = 0;
    
    for (final item in state.returnItems) {
      returnSubtotal += item.totalPrice;
      returnDiscount += item.discount;
      returnCount += item.quantity;
    }
    
    final returnTotal = returnSubtotal - returnDiscount;
    final returnSalesTax = returnTotal * 0.15; // Assuming 15% sales tax
    final returnGrandTotal = returnTotal + returnSalesTax;
    
    emit(state.copyWith(
      itemCount: itemCount,
      subtotal: subtotal,
      discount: discount,
      total: total,
      salesTax: salesTax,
      grandTotal: grandTotal,
      returnCount: returnCount,
      returnSubtotal: returnSubtotal,
      returnDiscount: returnDiscount,
      returnTotal: returnTotal,
      returnSalesTax: returnSalesTax,
      returnGrandTotal: returnGrandTotal,
    ));
  }

  void _onUpdatePaymentType(UpdatePaymentType event, Emitter<InvoiceState> emit) {
    emit(state.copyWith(paymentType: event.paymentType));
  }

  void _onSyncInvoice(SyncInvoice event, Emitter<InvoiceState> emit) async {
    emit(state.copyWith(isSyncing: true, errorMessage: null));
    
    try {
      // Get all unsynced invoices
      final unsyncedInvoices = await _invoiceTable.getUnsyncedInvoices();
      
      // In a real app, this would involve API calls to sync with the server
      // For now, we'll just mark them as synced after a delay to simulate network call
      
      if (unsyncedInvoices.isNotEmpty) {
        await Future.delayed(const Duration(seconds: 1));
        
        // Mark invoices as synced
        final invoiceIds = unsyncedInvoices.map<int>((i) => i['id'] as int).toList();
        await _invoiceTable.markInvoicesAsSynced(invoiceIds);
      }
      
      emit(state.copyWith(isSyncing: false));
    } catch (e) {
      emit(state.copyWith(
        isSyncing: false,
        errorMessage: 'Failed to sync: ${e.toString()}',
      ));
    }
  }

  void _onSubmitInvoice(SubmitInvoice event, Emitter<InvoiceState> emit) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null));
    
    try {
      // Validate invoice data
      if (event.isReturn && state.returnItems.isEmpty) {
        emit(state.copyWith(
          isSubmitting: false,
          errorMessage: 'Cannot submit a return with no items'
        ));
        return;
      } else if (!event.isReturn && state.items.isEmpty) {
        emit(state.copyWith(
          isSubmitting: false,
          errorMessage: 'Cannot submit an invoice with no items'
        ));
        return;
      }
      
      // Get next invoice number
      final invoiceNumber = await _invoiceTable.getNextInvoiceNumber();
      
      // Save invoice to database
      final invoiceId = await _invoiceTable.saveInvoice(
        invoiceNumber: invoiceNumber,
        customer: state.customer,
        invoiceState: state,
        isReturn: event.isReturn,
      );
      
      // Mark invoice as submitted
      emit(state.copyWith(
        isSubmitting: false,
        isSubmitted: true,
        invoiceNumber: invoiceNumber,
      ));
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'Failed to submit invoice: ${e.toString()}',
      ));
    }
  }

  void _onPrintInvoice(PrintInvoice event, Emitter<InvoiceState> emit) async {
    emit(state.copyWith(isPrinting: true, errorMessage: null));
    
    try {
      // TODO: Implement actual print/PDF generation functionality
      await Future.delayed(const Duration(seconds: 1));
      
      emit(state.copyWith(isPrinting: false));
    } catch (e) {
      emit(state.copyWith(
        isPrinting: false,
        errorMessage: 'Failed to print invoice: ${e.toString()}',
      ));
    }
  }
}
