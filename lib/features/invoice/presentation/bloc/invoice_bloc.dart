import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../database/customer_table.dart';
import '../../../../database/inventory_items_table.dart';
import '../../../../database/invoice_table.dart';
import '../../../../features/sync/domain/entities/customer_entity.dart';
import '../../../../features/sync/domain/entities/inventory/inventory_item_entity.dart';
import 'invoice_event.dart';
import 'invoice_state.dart';
import 'package:equatable/equatable.dart';
import 'package:larid/features/invoice/domain/entities/invoice_entity.dart';
import 'package:larid/features/invoice/domain/entities/invoice_item_entity.dart';
import 'package:larid/features/invoice/domain/repositories/invoice_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import 'package:larid/features/taxes/domain/repositories/tax_repository.dart';
import 'package:larid/features/taxes/domain/services/tax_calculator_service.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final CustomerTable _customerTable = getIt<CustomerTable>();
  final InventoryItemsTable _inventoryItemsTable = getIt<InventoryItemsTable>();
  final InvoiceTable _invoiceTable = getIt<InvoiceTable>();
  final InvoiceRepository _invoiceRepository;
  final TaxRepository _taxRepository;
  TaxCalculatorService? _taxCalculator;

  InvoiceBloc({
    required InvoiceRepository invoiceRepository,
    required TaxRepository taxRepository,
  }) : _invoiceRepository = invoiceRepository,
       _taxRepository = taxRepository,
       super(
         InvoiceState.initial(
           CustomerEntity(customerCode: "", customerName: ""),
         ),
       ) {
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
    on<SaveInvoice>(_onSaveInvoice);
    on<GetInvoices>(_onGetInvoices);
    on<DeleteInvoice>(_onDeleteInvoice);

    // Initialize tax calculator
    _initTaxCalculator();
  }

  Future<void> _initTaxCalculator() async {
    try {
      final taxes = await _taxRepository.getAllTaxes();
      _taxCalculator = TaxCalculatorService(taxes);
      debugPrint('Tax calculator initialized with ${taxes.length} taxes');
    } catch (e) {
      debugPrint('Error initializing tax calculator: $e');
    }
  }

  // Handler implementations
  void _onInitializeInvoice(
    InitializeInvoice event,
    Emitter<InvoiceState> emit,
  ) async {
    try {
      debugPrint(
        '\n======= INITIALIZING INVOICE FOR CUSTOMER: ${event.customerCode} =======',
      );
      emit(state.copyWith(isLoading: true));

      final customer = await _customerTable.getCustomerByCode(
        event.customerCode,
      );
      if (customer == null) {
        debugPrint('❌ CUSTOMER NOT FOUND: ${event.customerCode}');
        emit(
          state.copyWith(errorMessage: 'Customer not found', isLoading: false),
        );
        return;
      }

      debugPrint('✅ Customer found: ${customer.customerName}');

      // Check if there's an existing unsynchronized invoice for this customer
      final existingInvoices = await _invoiceTable.getInvoicesForCustomer(
        customer.customerCode,
      );

      debugPrint(
        '\n📋 Found ${existingInvoices.length} invoices total for customer ${customer.customerName}',
      );

      // Always use the first (most recent) invoice for this customer, regardless of sync status
      // This ensures we always show an invoice if one exists
      if (existingInvoices.isNotEmpty && !event.forceNew) {
        debugPrint('Using the most recent invoice for this customer');

        // Use the existing invoice
        final invoice = existingInvoices.first;

        // Check if the invoice has a valid items array
        final hasItems =
            invoice.containsKey('items') && invoice['items'] != null;
        final invoiceItems =
            hasItems
                ? invoice['items'] as List<Map<String, dynamic>>
                : <Map<String, dynamic>>[];

        debugPrint(
          '\n🧾 LOADING INVOICE ID: ${invoice['id']}, NUMBER: ${invoice['invoiceNumber']} with ${invoiceItems.length} items',
        );

        // Detailed invoice information debugging
        debugPrint('\n==== INVOICE DATABASE DETAILS ====');
        invoice.forEach((key, value) {
          if (key != 'items') {
            // Skip items array as we'll log that separately
            debugPrint('$key: $value');
          }
        });
        debugPrint('================================\n');

        // Convert items to InvoiceItemModel list
        final items = <InvoiceItemModel>[];
        final returnItems = <InvoiceItemModel>[];

        // Debug all invoice items
        debugPrint('\n🔍 PROCESSING ${invoiceItems.length} INVOICE ITEMS:');

        for (final itemData in invoiceItems) {
          try {
            // Check if the required fields exist in the item data
            if (!itemData.containsKey('itemCode') ||
                !itemData.containsKey('quantity') ||
                !itemData.containsKey('unitPrice')) {
              debugPrint('⚠️ Item missing required fields, skipping');
              continue;
            }

            final isReturn = itemData['isReturn'] == 1;
            final itemCode = itemData['itemCode'] as String;
            final quantity = itemData['quantity'] as int;

            debugPrint(
              '\n📦 Processing item: $itemCode (isReturn: $isReturn, Qty: $quantity)',
            );

            // Get the current inventory item
            final currentInventoryItem = await _inventoryItemsTable
                .getItemByCode(itemCode);

            if (currentInventoryItem == null) {
              debugPrint('⚠️ Item $itemCode not found in inventory, skipping');
              continue;
            }

            debugPrint(
              '✅ Item found in inventory: ${currentInventoryItem.description}',
            );

            // Use the saved unit price from the invoice, not the current inventory price
            final dynamic rawUnitPrice = itemData['unitPrice'];
            final double unitPrice = _parseDouble(rawUnitPrice);

            debugPrint(
              'Unit price from database: $rawUnitPrice (converted to: $unitPrice)',
            );

            final totalPrice = unitPrice * quantity;
            debugPrint('Calculated total price: $totalPrice');

            final item = InvoiceItemModel(
              item: InventoryItemEntity(
                itemCode: currentInventoryItem.itemCode,
                description: currentInventoryItem.description,
                taxableFlag: currentInventoryItem.taxableFlag,
                taxCode: currentInventoryItem.taxCode,
                sellUnitCode: currentInventoryItem.sellUnitCode,
                sellUnitPrice: unitPrice, // Use the saved price
                qty: currentInventoryItem.qty,
              ),
              quantity: quantity,
              totalPrice: totalPrice,
              discount: 0, // Add actual discount if available in the future
              tax: 0, // Add actual tax if available in the future
            );

            if (isReturn) {
              returnItems.add(item);
              debugPrint(
                'Added to RETURN items: $itemCode, quantity: $quantity',
              );
            } else {
              items.add(item);
              debugPrint(
                'Added to REGULAR items: $itemCode, quantity: $quantity',
              );
            }
          } catch (e) {
            debugPrint('❌ ERROR processing item: $e');
          }
        }

        debugPrint(
          '\n✅ Created ${items.length} regular items and ${returnItems.length} return items',
        );

        // Get numeric values directly from the invoice to ensure we use the exact values from DB
        final subtotal = _parseDouble(invoice['subtotal']);
        final discount = _parseDouble(invoice['discount']);
        final salesTax = _parseDouble(invoice['salesTax']);
        final grandTotal = _parseDouble(invoice['grandTotal']);
        final returnSubtotal = _parseDouble(invoice['returnSubtotal']);
        final returnDiscount = _parseDouble(invoice['returnDiscount']);
        final returnSalesTax = _parseDouble(invoice['returnSalesTax']);
        final returnGrandTotal = _parseDouble(invoice['returnGrandTotal']);

        debugPrint('\n💰 INVOICE TOTALS FROM DATABASE:');
        debugPrint('- subtotal: $subtotal');
        debugPrint('- discount: $discount');
        debugPrint('- salesTax: $salesTax');
        debugPrint('- grandTotal: $grandTotal');
        debugPrint('- return subtotal: $returnSubtotal');
        debugPrint('- return discount: $returnDiscount');
        debugPrint('- return salesTax: $returnSalesTax');
        debugPrint('- return grandTotal: $returnGrandTotal');

        // Calculate derived values
        final total = subtotal - discount;
        final returnTotal = returnSubtotal - returnDiscount;

        // Calculate item counts
        final itemCount = _calculateTotalQuantity(items);
        final returnCount = _calculateTotalQuantity(returnItems);

        // Get comment from invoice
        final comment = invoice['comment'] as String? ?? '';
        final paymentType = invoice['paymentType'] as String? ?? 'Cash';
        final invoiceNumber = invoice['invoiceNumber'] as String;

        debugPrint('\n📝 OTHER INVOICE DETAILS:');
        debugPrint('- comment: ${comment.isNotEmpty ? comment : "empty"}');
        debugPrint('- paymentType: $paymentType');
        debugPrint('- invoiceNumber: $invoiceNumber');
        debugPrint('- itemCount: $itemCount');
        debugPrint('- returnCount: $returnCount');

        // Create state with existing invoice data
        final newState = InvoiceState(
          customer: customer,
          items: items,
          returnItems: returnItems,
          invoiceNumber: invoiceNumber,
          subtotal: subtotal,
          discount: discount,
          salesTax: salesTax,
          grandTotal: grandTotal,
          returnSubtotal: returnSubtotal,
          returnDiscount: returnDiscount,
          returnSalesTax: returnSalesTax,
          returnGrandTotal: returnGrandTotal,
          itemCount: itemCount,
          returnCount: returnCount,
          total: total,
          returnTotal: returnTotal,
          comment: comment,
          paymentType: paymentType,
          isLoading: false,
        );

        debugPrint('\n🔄 EMITTING NEW STATE WITH INVOICE DATA');
        emit(newState);

        // Additional calculation to ensure UI is updated
        add(const CalculateInvoiceTotals());

        debugPrint('\n✅ INVOICE INITIALIZATION COMPLETE');
      } else {
        // Create new invoice
        debugPrint(
          '\n🆕 Creating new invoice for customer: ${customer.customerName}',
        );
        emit(InvoiceState.initial(customer).copyWith(isLoading: false));
        debugPrint('✅ New invoice initialized');
      }
    } catch (e, stackTrace) {
      debugPrint('\n❌ ERROR INITIALIZING INVOICE: $e');
      debugPrint('Stack trace: $stackTrace');
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  void _onNavigateToItemsPage(
    NavigateToItemsPage event,
    Emitter<InvoiceState> emit,
  ) {
    // This event doesn't change state, just triggers navigation in the UI
    // The navigation will be handled in the widget
  }

  void _onAddItems(AddItems event, Emitter<InvoiceState> emit) {
    // Ensure tax calculator is initialized
    if (_taxCalculator == null) {
      _initTaxCalculator();
    }

    final items = event.items;
    final updatedItems = <InvoiceItemModel>[];

    for (final item in items) {
      // Get tax rate for this item
      double? taxRate;
      if (_taxCalculator != null) {
        taxRate = _taxCalculator!.getTaxPercentage(item.item.taxCode);
      }

      // Calculate tax amount
      final priceBeforeTax = item.item.sellUnitPrice * item.quantity;
      final taxAmount =
          _taxCalculator?.calculateTax(item.item.taxCode, priceBeforeTax) ??
          0.0;
      final priceAfterTax = priceBeforeTax + taxAmount;

      // Update item with tax information
      final updatedItem = item.copyWith(
        taxRate: taxRate ?? 0.0,
        priceBeforeTax: priceBeforeTax,
        taxAmount: taxAmount,
        priceAfterTax: priceAfterTax,
        totalPrice: priceAfterTax,
      );

      updatedItems.add(updatedItem);
    }

    // Add updated items to state
    final newItems = [...state.items, ...updatedItems];

    emit(
      state.copyWith(items: newItems, itemCount: _calculateItemCount(newItems)),
    );

    // Recalculate totals
    _calculateTotals(emit);
  }

  void _onAddInvoiceItems(AddInvoiceItems event, Emitter<InvoiceState> emit) {
    try {
      final List<InvoiceItemModel> updatedItems = List.from(state.items);

      // Log the received data for debugging
      debugPrint('Processing invoice items: ${event.items.toString()}');

      // Process the items from the Map<String, dynamic>
      for (var entry in event.items.entries) {
        final itemCode = entry.key;
        final itemData = entry.value as Map<String, dynamic>;

        if (itemData.containsKey('item')) {
          final itemMap = itemData['item'] as Map<String, dynamic>;
          final item = InventoryItemEntity(
            itemCode: itemMap['itemCode'],
            description: itemMap['description'],
            taxableFlag: itemMap['taxableFlag'],
            taxCode: itemMap['taxCode'],
            sellUnitCode: itemMap['sellUnitCode'],
            sellUnitPrice: (itemMap['sellUnitPrice'] as num).toDouble(),
            qty: (itemMap['qty'] as num).toInt(),
          );

          final quantity = (itemData['quantity'] as num).toInt();
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
            (invoiceItem) => invoiceItem.item.itemCode == itemCode,
          );

          if (existingItemIndex != -1) {
            // Update existing item
            updatedItems[existingItemIndex] = newItem;
          } else {
            // Add new item
            updatedItems.add(newItem);
          }
        }
      }

      // Update the state with the new items
      emit(state.copyWith(items: updatedItems));

      // Calculate the invoice totals
      add(const CalculateInvoiceTotals());

      // Log the updated state for debugging
      debugPrint('Updated invoice items count: ${updatedItems.length}');
    } catch (e, stackTrace) {
      debugPrint('Error adding invoice items: $e');
      debugPrint('Stack trace: $stackTrace');
      emit(state.copyWith(errorMessage: 'Failed to add items: $e'));
    }
  }

  void _onAddReturnItems(AddReturnItems event, Emitter<InvoiceState> emit) {
    try {
      final List<InvoiceItemModel> updatedReturnItems = List.from(
        state.returnItems,
      );

      // Log the received data for debugging
      debugPrint('Processing return items: ${event.items.toString()}');

      // Process the items from the Map<String, dynamic>
      for (var entry in event.items.entries) {
        final itemCode = entry.key;
        final itemData = entry.value as Map<String, dynamic>;

        if (itemData.containsKey('item')) {
          final itemMap = itemData['item'] as Map<String, dynamic>;
          final item = InventoryItemEntity(
            itemCode: itemMap['itemCode'],
            description: itemMap['description'],
            taxableFlag: itemMap['taxableFlag'],
            taxCode: itemMap['taxCode'],
            sellUnitCode: itemMap['sellUnitCode'],
            sellUnitPrice: (itemMap['sellUnitPrice'] as num).toDouble(),
            qty: (itemMap['qty'] as num).toInt(),
          );

          final quantity = (itemData['quantity'] as num).toInt();
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
            (invoiceItem) => invoiceItem.item.itemCode == itemCode,
          );

          if (existingItemIndex != -1) {
            // Update existing return item
            updatedReturnItems[existingItemIndex] = newItem;
          } else {
            // Add new return item
            updatedReturnItems.add(newItem);
          }
        }
      }

      // Update the state with the new return items
      emit(state.copyWith(returnItems: updatedReturnItems));

      // Calculate the invoice totals
      add(const CalculateInvoiceTotals());

      // Log the updated state for debugging
      debugPrint('Updated return items count: ${updatedReturnItems.length}');
    } catch (e, stackTrace) {
      debugPrint('Error adding return items: $e');
      debugPrint('Stack trace: $stackTrace');
      emit(state.copyWith(errorMessage: 'Failed to add return items: $e'));
    }
  }

  void _onRemoveItem(RemoveItem event, Emitter<InvoiceState> emit) {
    if (event.isReturn) {
      final List<InvoiceItemModel> updatedReturnItems = List.from(
        state.returnItems,
      )..removeWhere((item) => item.item.itemCode == event.item.item.itemCode);

      emit(state.copyWith(returnItems: updatedReturnItems));
    } else {
      final List<InvoiceItemModel> updatedItems = List.from(state.items)
        ..removeWhere((item) => item.item.itemCode == event.item.item.itemCode);

      emit(state.copyWith(items: updatedItems));
    }

    add(const CalculateInvoiceTotals());
  }

  void _onUpdateItemQuantity(
    UpdateItemQuantity event,
    Emitter<InvoiceState> emit,
  ) {
    if (event.quantity <= 0) {
      // Remove the item if quantity is 0 or negative
      add(RemoveItem(item: event.item, isReturn: event.isReturn));
      return;
    }

    if (event.isReturn) {
      final List<InvoiceItemModel> updatedReturnItems = List.from(
        state.returnItems,
      );
      final itemIndex = updatedReturnItems.indexWhere(
        (item) => item.item.itemCode == event.item.item.itemCode,
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
        (item) => item.item.itemCode == event.item.item.itemCode,
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
    emit(state.copyWith(comment: event.comment, errorMessage: null));
  }

  void _onCalculateInvoiceTotals(
    CalculateInvoiceTotals event,
    Emitter<InvoiceState> emit,
  ) {
    // Calculate invoice totals
    double subtotal = 0.0;
    double discount = 0.0;
    int itemCount = 0;

    debugPrint('Calculating invoice totals...');
    debugPrint('Regular items: ${state.items.length}');

    for (final item in state.items) {
      subtotal += item.totalPrice;
      discount += item.discount;
      itemCount += item.quantity;
      debugPrint(
        'Item: ${item.item.itemCode}, Qty: ${item.quantity}, Price: ${item.item.sellUnitPrice}, Total: ${item.totalPrice}',
      );
    }

    final total = subtotal - discount;
    final salesTax = total * 0.15; // Assuming 15% sales tax
    final grandTotal = total + salesTax;

    // Calculate return totals
    double returnSubtotal = 0.0;
    double returnDiscount = 0.0;
    int returnCount = 0;

    debugPrint('Return items: ${state.returnItems.length}');

    for (final item in state.returnItems) {
      returnSubtotal += item.totalPrice;
      returnDiscount += item.discount;
      returnCount += item.quantity;
      debugPrint(
        'Return Item: ${item.item.itemCode}, Qty: ${item.quantity}, Price: ${item.item.sellUnitPrice}, Total: ${item.totalPrice}',
      );
    }

    final returnTotal = returnSubtotal - returnDiscount;
    final returnSalesTax = returnTotal * 0.15; // Assuming 15% sales tax
    final returnGrandTotal = returnTotal + returnSalesTax;

    debugPrint('CALCULATED TOTALS:');
    debugPrint('- subtotal: $subtotal');
    debugPrint('- discount: $discount');
    debugPrint('- total: $total');
    debugPrint('- salesTax: $salesTax');
    debugPrint('- grandTotal: $grandTotal');
    debugPrint('- returnSubtotal: $returnSubtotal');
    debugPrint('- returnDiscount: $returnDiscount');
    debugPrint('- returnTotal: $returnTotal');
    debugPrint('- returnSalesTax: $returnSalesTax');
    debugPrint('- returnGrandTotal: $returnGrandTotal');

    final newState = state.copyWith(
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
    );

    emit(newState);

    debugPrint('Emitted new state with updated totals');
  }

  void _onUpdatePaymentType(
    UpdatePaymentType event,
    Emitter<InvoiceState> emit,
  ) {
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
        final invoiceIds =
            unsyncedInvoices.map<int>((i) => i['id'] as int).toList();
        await _invoiceTable.markInvoicesAsSynced(invoiceIds);
      }

      emit(state.copyWith(isSyncing: false));
    } catch (e) {
      emit(
        state.copyWith(
          isSyncing: false,
          errorMessage: 'Failed to sync: ${e.toString()}',
        ),
      );
    }
  }

  void _onSubmitInvoice(SubmitInvoice event, Emitter<InvoiceState> emit) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      // Validate invoice data
      if (event.isReturn && state.returnItems.isEmpty) {
        emit(
          state.copyWith(
            isSubmitting: false,
            errorMessage: 'Cannot submit a return with no items',
          ),
        );
        return;
      } else if (!event.isReturn && state.items.isEmpty) {
        emit(
          state.copyWith(
            isSubmitting: false,
            errorMessage: 'Cannot submit an invoice with no items',
          ),
        );
        return;
      }

      // Get existing invoice number or generate a new one
      String invoiceNumber =
          state.invoiceNumber ?? await _invoiceTable.getNextInvoiceNumber();

      // Check if invoice already exists
      bool isUpdate = state.invoiceNumber != null;
      int invoiceId;

      if (isUpdate) {
        // Update existing invoice
        invoiceId = await _invoiceTable.updateInvoice(
          invoiceNumber: invoiceNumber,
          customer: state.customer,
          invoiceState: state,
          isReturn: event.isReturn,
        );
      } else {
        // Save new invoice
        invoiceId = await _invoiceTable.saveInvoice(
          invoiceNumber: invoiceNumber,
          customer: state.customer,
          invoiceState: state,
          isReturn: event.isReturn,
        );
      }

      // Mark invoice as submitted
      emit(
        state.copyWith(
          isSubmitting: false,
          isSubmitted: true,
          invoiceNumber: invoiceNumber,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'Failed to submit invoice: ${e.toString()}',
        ),
      );
    }
  }

  void _onPrintInvoice(PrintInvoice event, Emitter<InvoiceState> emit) async {
    emit(state.copyWith(isPrinting: true, errorMessage: null));

    try {
      // TODO: Implement actual print/PDF generation functionality
      await Future.delayed(const Duration(seconds: 1));

      emit(state.copyWith(isPrinting: false));
    } catch (e) {
      emit(
        state.copyWith(
          isPrinting: false,
          errorMessage: 'Failed to print invoice: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onSaveInvoice(
    SaveInvoice event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      final String invoiceId = const Uuid().v4();
      final DateTime now = DateTime.now();

      // Create invoice entity
      final invoice = InvoiceEntity(
        id: invoiceId,
        customerId: event.customerId,
        customerName: event.customerName,
        totalAmount: event.totalAmount,
        date: now,
        status: 'pending',
        isReturn: event.hasReturnItems,
        createdAt: now,
        updatedAt: now,
      );

      await _invoiceRepository.saveInvoice(invoice);

      final List<InvoiceItemEntity> invoiceItems = [];
      if (event.items != null) {
        for (var entry in event.items!.entries) {
          final itemData = entry.value;
          final invoiceItem = InvoiceItemEntity(
            id: const Uuid().v4(),
            invoiceId: invoiceId,
            itemCode: itemData['item']['itemCode'],
            description: itemData['item']['description'],
            quantity: itemData['quantity'],
            unitPrice: itemData['item']['sellUnitPrice'],
            totalPrice: itemData['total'],
            isReturn: itemData['isReturn'] ?? false,
            taxCode: itemData['item']['taxCode'],
            taxableFlag: itemData['item']['taxableFlag'],
            sellUnitCode: itemData['item']['sellUnitCode'],
            createdAt: now,
            updatedAt: now,
          );
          invoiceItems.add(invoiceItem);
        }
      }

      await _invoiceRepository.saveInvoiceItems(invoiceItems);
      emit(
        state.copyWith(
          isSubmitting: false,
          isSubmitted: true,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          isSubmitted: false,
          errorMessage: 'Failed to save invoice: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onGetInvoices(
    GetInvoices event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      final invoices = await _invoiceRepository.getInvoices();
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: null,
          // Add any other relevant state updates
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'Failed to load invoices: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onDeleteInvoice(
    DeleteInvoice event,
    Emitter<InvoiceState> emit,
  ) async {
    try {
      debugPrint('Deleting invoice with ID: ${event.invoiceId}');
      emit(state.copyWith(isSubmitting: true, errorMessage: null));

      // Delete the invoice using the InvoiceTable
      await _invoiceTable.deleteInvoice(event.invoiceId);

      // Return to the customer screen without using isDeleted
      emit(
        state.copyWith(
          isSubmitting: false,
          isSubmitted: true, // Use isSubmitted instead of isDeleted
          errorMessage: null,
        ),
      );

      debugPrint('Invoice deleted successfully');
    } catch (e) {
      debugPrint('Error deleting invoice: $e');
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'Failed to delete invoice: ${e.toString()}',
        ),
      );
    }
  }

  // Helper method to safely parse double values
  double _parseDouble(dynamic value) {
    if (value == null) {
      debugPrint('Warning: Parsing null value as 0.0');
      return 0.0;
    }

    try {
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        final trimmed = value.trim();
        if (trimmed.isEmpty) return 0.0;
        return double.parse(trimmed);
      }
      if (value is num) return value.toDouble();

      // For any other type, try to convert to string first then parse
      final stringValue = value.toString();
      debugPrint(
        'Converting non-standard type to double: $value (${value.runtimeType}) → $stringValue',
      );
      return double.parse(stringValue);
    } catch (e) {
      debugPrint(
        'Error parsing double value: $value (${value.runtimeType}): $e',
      );
      return 0.0;
    }
  }

  // Helper method to calculate total quantity
  int _calculateTotalQuantity(List<InvoiceItemModel> items) {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  // Add the missing _calculateItemCount method
  int _calculateItemCount(List<InvoiceItemModel> items) {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  // Add a method to get the tax calculator
  TaxCalculatorService? getTaxCalculator() {
    return _taxCalculator;
  }

  // Update the _calculateTotals method to include tax calculations
  void _calculateTotals(Emitter<InvoiceState> emit) async {
    // Ensure tax calculator is initialized
    if (_taxCalculator == null) {
      await _initTaxCalculator();
    }

    double subtotal = 0.0;
    double discount = 0.0;
    double salesTax = 0.0;
    double returnSubtotal = 0.0;
    double returnDiscount = 0.0;
    double returnSalesTax = 0.0;

    // Calculate for regular items
    for (final item in state.items) {
      // Calculate price before tax
      final priceBeforeTax = item.item.sellUnitPrice * item.quantity;

      // Calculate tax amount if tax calculator is available
      double taxAmount = 0.0;
      if (_taxCalculator != null) {
        taxAmount = _taxCalculator!.calculateTax(
          item.item.taxCode,
          priceBeforeTax,
        );
      }

      subtotal += priceBeforeTax;
      discount += item.discount;
      salesTax += taxAmount;
    }

    // Calculate for return items
    for (final item in state.returnItems) {
      // Calculate price before tax
      final priceBeforeTax = item.item.sellUnitPrice * item.quantity;

      // Calculate tax amount if tax calculator is available
      double taxAmount = 0.0;
      if (_taxCalculator != null) {
        taxAmount = _taxCalculator!.calculateTax(
          item.item.taxCode,
          priceBeforeTax,
        );
      }

      returnSubtotal += priceBeforeTax;
      returnDiscount += item.discount;
      returnSalesTax += taxAmount;
    }

    // Calculate totals
    final total = subtotal - discount;
    final grandTotal = total + salesTax;
    final returnTotal = returnSubtotal - returnDiscount;
    final returnGrandTotal = returnTotal + returnSalesTax;

    emit(
      state.copyWith(
        subtotal: subtotal,
        discount: discount,
        total: total,
        salesTax: salesTax,
        grandTotal: grandTotal,
        returnSubtotal: returnSubtotal,
        returnDiscount: returnDiscount,
        returnTotal: returnTotal,
        returnSalesTax: returnSalesTax,
        returnGrandTotal: returnGrandTotal,
      ),
    );
  }
}
