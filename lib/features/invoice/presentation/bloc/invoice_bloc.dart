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
import 'package:larid/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final CustomerTable _customerTable = getIt<CustomerTable>();
  final InventoryItemsTable _inventoryItemsTable = getIt<InventoryItemsTable>();
  final InvoiceTable _invoiceTable = getIt<InvoiceTable>();
  final InvoiceRepository _invoiceRepository;
  final TaxRepository _taxRepository;
  TaxCalculatorService? _taxCalculator;
  AppLocalizations? _localizations;

  InvoiceBloc({
    required InvoiceRepository invoiceRepository,
    required TaxRepository taxRepository,
  }) : _invoiceRepository = invoiceRepository,
       _taxRepository = taxRepository,
       super(
         InvoiceState.initial(
           const CustomerEntity(customerCode: '', customerName: ''),
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

  // Add method to initialize localizations
  void initializeLocalizations(BuildContext context) {
    _localizations = AppLocalizations.of(context)!;
  }

  // Helper method to get localizations with null check
  AppLocalizations get localizations {
    if (_localizations == null) {
      throw StateError(
        'Localizations not initialized. Call initializeLocalizations first.',
      );
    }
    return _localizations!;
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
      if (_localizations == null) {
        emit(
          state.copyWith(
            errorMessage: 'Localizations not initialized',
            isLoading: false,
          ),
        );
        return;
      }

      debugPrint(
        '\n======= INITIALIZING INVOICE FOR CUSTOMER: ${event.customerCode} =======',
      );
      debugPrint('Is Return: ${event.isReturn}, Force New: ${event.forceNew}');
      emit(state.copyWith(isLoading: true));

      final customer = await _customerTable.getCustomerByCode(
        event.customerCode,
      );
      if (customer == null) {
        debugPrint('❌ CUSTOMER NOT FOUND: ${event.customerCode}');
        emit(
          state.copyWith(
            errorMessage: localizations.customerNotFound,
            isLoading: false,
          ),
        );
        return;
      }

      debugPrint('✅ Customer found: ${customer.customerName}');

      // Check if there's an existing invoice for this customer
      final allInvoices = await _invoiceTable.getInvoicesForCustomer(
        customer.customerCode,
      );

      debugPrint(
        '\n📋 Found ${allInvoices.length} total invoices for customer ${customer.customerName}',
      );

      // Debug all invoices before filtering
      if (allInvoices.isNotEmpty) {
        debugPrint('\n------ All Available Invoices Before Filtering ------');
        for (final invoice in allInvoices) {
          final isReturnInvoice = invoice['isReturn'] == 1;
          final isSynced = invoice['isSynced'] == 1;
          final invoiceNumber =
              invoice['invoiceNumber'] as String? ?? localizations.noNumber;
          final invoiceDateStr = invoice['invoiceDate'] as String? ?? '';
          debugPrint(
            '- Invoice #$invoiceNumber: Return=$isReturnInvoice, Synced=$isSynced, Date=$invoiceDateStr',
          );
        }
        debugPrint('----------------------------------------------------\n');
      }

      // First, check for unsynced invoices that match the requested type
      final unsyncedInvoices = allInvoices.where((invoice) {
        final isReturnInvoice = invoice['isReturn'] == 1;
        final isSynced = invoice['isSynced'] == 1;
        return (isReturnInvoice == event.isReturn) && !isSynced;
      }).toList();

      // If we have an unsynced invoice, use it without further checks
      if (unsyncedInvoices.isNotEmpty && !event.forceNew) {
        debugPrint('Found unsynced invoice - loading for editing');
        return _loadExistingInvoice(unsyncedInvoices.first, customer, emit);
      }

      // Check for synced invoices within the last 24 hours
      final recentSyncedInvoices = allInvoices.where((invoice) {
        final isReturnInvoice = invoice['isReturn'] == 1;
        final isSynced = invoice['isSynced'] == 1;
        
        // Only check invoices that match the type and are synced
        if (!(isReturnInvoice == event.isReturn) || !isSynced) {
          return false;
        }
        
        // Check the date against the 24-hour rule
        final invoiceDateStr = invoice['invoiceDate'] as String? ?? '';
        if (invoiceDateStr.isEmpty) {
          return false;
        }
        
        try {
          final invoiceDate = DateTime.parse(invoiceDateStr);
          final now = DateTime.now();
          final difference = now.difference(invoiceDate);
          
          // If less than 24 hours have passed, consider it a recent invoice
          final isWithin24Hours = difference.inHours < 24;
          
          debugPrint(
            'Invoice ${invoice['invoiceNumber']} date: $invoiceDate, '
            'hours passed: ${difference.inHours}, within 24h: $isWithin24Hours'
          );
          
          return isWithin24Hours;
        } catch (e) {
          debugPrint('Error parsing invoice date: $e');
          return false;
        }
      }).toList();

      // If we have a recent synced invoice (less than 24h old), load it as view-only
      if (recentSyncedInvoices.isNotEmpty && !event.forceNew) {
        debugPrint('Found recent synced invoice (< 24h) - loading as view-only');
        return _loadExistingInvoice(recentSyncedInvoices.first, customer, emit, viewOnly: true);
      }

      // If we reach here, either:
      // 1. There are no invoices for this customer
      // 2. There are only synced invoices older than 24 hours
      // 3. Force new was requested
      // In all cases, create a new invoice
      debugPrint('Creating new invoice (no recent invoices found or force new requested)');
      
      // Initialize a new invoice state
      InvoiceState newState = InvoiceState.initial(customer, isReturn: event.isReturn);

      // Get tax settings for this invoice - replace with defaults since _userPrefs doesn't exist
      newState = newState.copyWith(
        paymentType: localizations.cash, // Default payment type
      );

      emit(newState.copyWith(isLoading: false));
    } catch (e, stackTrace) {
      debugPrint('Error initializing invoice: $e');
      debugPrint('Stack trace: $stackTrace');
      emit(
        state.copyWith(
          errorMessage: 'Failed to initialize invoice: ${e.toString()}',
          isLoading: false,
        ),
      );
    }
  }

  // Helper method to load an existing invoice
  void _loadExistingInvoice(
    Map<String, dynamic> invoice, 
    CustomerEntity customer, 
    Emitter<InvoiceState> emit, 
    {bool viewOnly = false}
  ) async {
    try {
      final isReturnInvoice = invoice['isReturn'] == 1;
      final invoiceNumber = invoice['invoiceNumber'] as String? ?? '';
      final comment = invoice['comment'] as String? ?? '';
      
      // Get invoice items - convert the string invoice number to int if needed
      final int? invoiceId = invoice['id'] as int?;
      final items = await _invoiceTable.getInvoiceItems(invoiceId ?? 0);
      
      debugPrint(
        'Loading existing ${isReturnInvoice ? "return" : "regular"} invoice: $invoiceNumber '
        'with ${items.length} items${viewOnly ? " (view-only mode)" : ""}'
      );

      // Parse the items into the correct format based on whether it's a return invoice
      List<InvoiceItemModel> invoiceItems = [];
      List<InvoiceItemModel> returnItems = [];

      if (items.isNotEmpty) {
        for (final itemData in items) {
          final itemCode = itemData['itemCode'] as String;
          final item = await _inventoryItemsTable.getItemByCode(itemCode);
          
          if (item != null) {
            // Get the quantity as an integer
            final quantity = (itemData['quantity'] as num).toInt();
            final taxRate = (itemData['taxRate'] as num?)?.toDouble() ?? 0.0;
            final taxAmount = (itemData['taxAmount'] as num?)?.toDouble() ?? 0.0;
            
            // Calculate total price
            final totalPrice = (item.sellUnitPrice * quantity) + taxAmount;
            
            final invoiceItem = InvoiceItemModel(
              item: item,
              quantity: quantity,
              totalPrice: totalPrice,
              taxRate: taxRate,
              taxAmount: taxAmount,
            );
            
            if (isReturnInvoice) {
              returnItems.add(invoiceItem);
            } else {
              invoiceItems.add(invoiceItem);
            }
          }
        }
      }

      // Calculate the totals
      final subtotal = isReturnInvoice ? 
        returnItems.fold(0.0, (sum, item) => sum + (item.item.sellUnitPrice * item.quantity)) :
        invoiceItems.fold(0.0, (sum, item) => sum + (item.item.sellUnitPrice * item.quantity));
      
      final taxTotal = isReturnInvoice ?
        returnItems.fold(0.0, (sum, item) => sum + item.taxAmount) :
        invoiceItems.fold(0.0, (sum, item) => sum + item.taxAmount);
      
      final grandTotal = subtotal + taxTotal;

      // Get the payment type from the invoice
      final paymentType = invoice['paymentType'] as String? ?? localizations.cash;

      // Create and emit the new state
      final newState = InvoiceState.initial(customer, isReturn: isReturnInvoice)
        .copyWith(
          invoiceNumber: invoiceNumber,
          items: invoiceItems,
          returnItems: returnItems,
          comment: comment,
          subtotal: subtotal,
          salesTax: taxTotal,
          grandTotal: grandTotal,
          returnSubtotal: isReturnInvoice ? subtotal : 0.0,
          returnSalesTax: isReturnInvoice ? taxTotal : 0.0,
          returnGrandTotal: isReturnInvoice ? grandTotal : 0.0,
          paymentType: paymentType,
          isSubmitted: viewOnly, // Mark as submitted if view-only
          isLoading: false,
        );

      emit(newState);
    } catch (e) {
      debugPrint('Error loading existing invoice: $e');
      emit(
        state.copyWith(
          errorMessage: 'Failed to load invoice: ${e.toString()}',
          isLoading: false,
        ),
      );
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

  Future<void> _onAddInvoiceItems(
    AddInvoiceItems event,
    Emitter<InvoiceState> emit,
  ) async {
    try {
      // Ensure tax calculator is initialized
      if (_taxCalculator == null) {
        _initTaxCalculator();
      }

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
          final priceBeforeTax = item.sellUnitPrice * quantity;

          // Calculate tax values using tax calculator
          double taxRate = 0.0;
          double taxAmount = 0.0;

          if (_taxCalculator != null && item.taxCode.isNotEmpty) {
            taxRate = _taxCalculator!.getTaxPercentage(item.taxCode);
            taxAmount = _taxCalculator!.calculateTax(
              item.taxCode,
              priceBeforeTax,
            );
          }

          final totalPrice = priceBeforeTax + taxAmount;

          // Create the invoice item model with tax values
          final newItem = InvoiceItemModel(
            item: item,
            quantity: quantity,
            totalPrice: totalPrice,
            priceBeforeTax: priceBeforeTax,
            taxAmount: taxAmount,
            priceAfterTax: totalPrice,
            taxRate: taxRate,
            discount: 0,
            tax: taxAmount,
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

          // Debug log for tax values
          debugPrint('Added item ${item.itemCode} with:');
          debugPrint('- Tax Rate: $taxRate%');
          debugPrint('- Tax Amount: $taxAmount');
          debugPrint('- Total Price: $totalPrice');
        }
      }

      // Update the state with the new items
      emit(state.copyWith(items: updatedItems));

      // Calculate the invoice totals
      add(const CalculateInvoiceTotals());

      // Log the updated state for debugging
      debugPrint('Updated invoice items count: ${updatedItems.length}');

      // Check if the invoice is dirty
      final isDirty = await checkIfInvoiceIsDirty(
        invoiceNumber: state.invoiceNumber,
        currentItems: updatedItems,
        currentReturnItems: state.returnItems,
        isReturn: false,
      );

      // Update state with isDirty
      emit(
        state.copyWith(
          items: updatedItems,
          itemCount: updatedItems.length,
          isDirty: isDirty,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('Error adding invoice items: $e');
      debugPrint('Stack trace: $stackTrace');
      emit(state.copyWith(errorMessage: 'Failed to add items: $e'));
    }
  }

  Future<void> _onAddReturnItems(
    AddReturnItems event,
    Emitter<InvoiceState> emit,
  ) async {
    try {
      // Ensure tax calculator is initialized
      if (_taxCalculator == null) {
        _initTaxCalculator();
      }

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
          final priceBeforeTax = item.sellUnitPrice * quantity;

          // Calculate tax values using tax calculator
          double taxRate = 0.0;
          double taxAmount = 0.0;

          if (_taxCalculator != null && item.taxCode.isNotEmpty) {
            taxRate = _taxCalculator!.getTaxPercentage(item.taxCode);
            taxAmount = _taxCalculator!.calculateTax(
              item.taxCode,
              priceBeforeTax,
            );
          }

          final totalPrice = priceBeforeTax + taxAmount;

          // Create the invoice item model with tax values
          final newItem = InvoiceItemModel(
            item: item,
            quantity: quantity,
            totalPrice: totalPrice,
            priceBeforeTax: priceBeforeTax,
            taxAmount: taxAmount,
            priceAfterTax: totalPrice,
            taxRate: taxRate,
            discount: 0,
            tax: taxAmount,
          );

          // Check if the item already exists in the invoice
          final existingItemIndex = updatedReturnItems.indexWhere(
            (invoiceItem) => invoiceItem.item.itemCode == itemCode,
          );

          if (existingItemIndex != -1) {
            // Update existing item
            updatedReturnItems[existingItemIndex] = newItem;
          } else {
            // Add new item
            updatedReturnItems.add(newItem);
          }

          // Debug log for tax values
          debugPrint('Added return item ${item.itemCode} with:');
          debugPrint('- Tax Rate: $taxRate%');
          debugPrint('- Tax Amount: $taxAmount');
          debugPrint('- Total Price: $totalPrice');
        }
      }

      // Update the state with the new items
      emit(state.copyWith(returnItems: updatedReturnItems));

      // Calculate the invoice totals
      add(const CalculateInvoiceTotals());

      // Log the updated state for debugging
      debugPrint('Updated return items count: ${updatedReturnItems.length}');

      // Check if the invoice is dirty
      final isDirty = await checkIfInvoiceIsDirty(
        invoiceNumber: state.invoiceNumber,
        currentItems: state.items,
        currentReturnItems: updatedReturnItems,
        isReturn: true,
      );

      // Update state with isDirty
      emit(
        state.copyWith(
          returnItems: updatedReturnItems,
          returnCount: updatedReturnItems.length,
          isDirty: isDirty,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('Error adding return items: $e');
      debugPrint('Stack trace: $stackTrace');
      emit(state.copyWith(errorMessage: 'Failed to add return items: $e'));
    }
  }

  Future<void> _onRemoveItem(
    RemoveItem event,
    Emitter<InvoiceState> emit,
  ) async {
    final List<InvoiceItemModel> updatedItems = List.from(state.items);
    final List<InvoiceItemModel> updatedReturnItems = List.from(
      state.returnItems,
    );

    if (event.isReturn) {
      // Remove from return items
      updatedReturnItems.removeWhere(
        (item) => item.item.itemCode == event.item.item.itemCode,
      );
    } else {
      // Remove from regular items
      updatedItems.removeWhere(
        (item) => item.item.itemCode == event.item.item.itemCode,
      );
    }

    // After removing, check if the invoice is still dirty
    final isDirty = await checkIfInvoiceIsDirty(
      invoiceNumber: state.invoiceNumber,
      currentItems: event.isReturn ? state.items : updatedItems,
      currentReturnItems:
          event.isReturn ? updatedReturnItems : state.returnItems,
      isReturn: event.isReturn,
    );

    // Update state with isDirty
    emit(
      state.copyWith(
        items: event.isReturn ? state.items : updatedItems,
        returnItems: event.isReturn ? updatedReturnItems : state.returnItems,
        itemCount: event.isReturn ? state.itemCount : updatedItems.length,
        returnCount:
            event.isReturn ? updatedReturnItems.length : state.returnCount,
        isDirty: isDirty,
      ),
    );

    // Calculate totals
    add(const CalculateInvoiceTotals());
  }

  Future<void> _onUpdateItemQuantity(
    UpdateItemQuantity event,
    Emitter<InvoiceState> emit,
  ) async {
    // Process regular items or return items based on isReturn flag
    if (event.isReturn) {
      // Update return item
      final List<InvoiceItemModel> updatedReturnItems =
          state.returnItems.map((item) {
            if (item.item.itemCode == event.item.item.itemCode) {
              // Create a new item with the updated quantity and price
              final double priceBeforeTax =
                  event.quantity * item.item.sellUnitPrice;
              final double taxAmount =
                  _taxCalculator?.calculateTax(
                    item.item.taxCode,
                    priceBeforeTax,
                  ) ??
                  0.0;
              final double priceAfterTax = priceBeforeTax + taxAmount;

              return item.copyWith(
                quantity: event.quantity,
                totalPrice: priceAfterTax,
                priceBeforeTax: priceBeforeTax,
                taxAmount: taxAmount,
                priceAfterTax: priceAfterTax,
              );
            }
            return item;
          }).toList();

      // After updating quantity, check if the invoice is still dirty
      final isDirty = await checkIfInvoiceIsDirty(
        invoiceNumber: state.invoiceNumber,
        currentItems: state.items,
        currentReturnItems: updatedReturnItems,
        isReturn: true,
      );

      // Update state
      emit(state.copyWith(returnItems: updatedReturnItems, isDirty: isDirty));
    } else {
      // Update regular item
      final List<InvoiceItemModel> updatedItems =
          state.items.map((item) {
            if (item.item.itemCode == event.item.item.itemCode) {
              // Create a new item with the updated quantity and price
              final double priceBeforeTax =
                  event.quantity * item.item.sellUnitPrice;
              final double taxAmount =
                  _taxCalculator?.calculateTax(
                    item.item.taxCode,
                    priceBeforeTax,
                  ) ??
                  0.0;
              final double priceAfterTax = priceBeforeTax + taxAmount;

              return item.copyWith(
                quantity: event.quantity,
                totalPrice: priceAfterTax,
                priceBeforeTax: priceBeforeTax,
                taxAmount: taxAmount,
                priceAfterTax: priceAfterTax,
              );
            }
            return item;
          }).toList();

      // After updating quantity, check if the invoice is still dirty
      final isDirty = await checkIfInvoiceIsDirty(
        invoiceNumber: state.invoiceNumber,
        currentItems: updatedItems,
        currentReturnItems: state.returnItems,
        isReturn: false,
      );

      // Update state
      emit(state.copyWith(items: updatedItems, isDirty: isDirty));
    }

    // Calculate totals
    add(const CalculateInvoiceTotals());
  }

  void _onUpdateComment(UpdateComment event, Emitter<InvoiceState> emit) {
    emit(state.copyWith(comment: event.comment, errorMessage: null));
  }

  void _onCalculateInvoiceTotals(
    CalculateInvoiceTotals event,
    Emitter<InvoiceState> emit,
  ) async {
    // Ensure tax calculator is initialized
    if (_taxCalculator == null) {
      debugPrint('Tax calculator not initialized, initializing now...');
      _initTaxCalculator();
    }

    // Calculate invoice totals
    double subtotal = 0.0;
    double discount = 0.0;
    double salesTax = 0.0;
    int itemCount = 0;

    debugPrint('Calculating invoice totals...');
    debugPrint('Regular items: ${state.items.length}');

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
        debugPrint(
          'Tax for item ${item.item.itemCode} (code: ${item.item.taxCode}): $taxAmount',
        );
      } else {
        debugPrint('Warning: Tax calculator not available, using zero tax');
      }

      subtotal += priceBeforeTax;
      discount += item.discount;
      salesTax += taxAmount;
      itemCount += item.quantity;

      debugPrint(
        'Item: ${item.item.itemCode}, Qty: ${item.quantity}, Price: ${item.item.sellUnitPrice}, Total: ${priceBeforeTax}, Tax: $taxAmount',
      );
    }

    final total = subtotal - discount;
    final grandTotal = total + salesTax;

    // Calculate return totals
    double returnSubtotal = 0.0;
    double returnDiscount = 0.0;
    double returnSalesTax = 0.0;
    int returnCount = 0;

    debugPrint('Return items: ${state.returnItems.length}');

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
        debugPrint(
          'Tax for return item ${item.item.itemCode} (code: ${item.item.taxCode}): $taxAmount',
        );
      }

      returnSubtotal += priceBeforeTax;
      returnDiscount += item.discount;
      returnSalesTax += taxAmount;
      returnCount += item.quantity;

      debugPrint(
        'Return Item: ${item.item.itemCode}, Qty: ${item.quantity}, Price: ${item.item.sellUnitPrice}, Total: ${priceBeforeTax}, Tax: $taxAmount',
      );
    }

    final returnTotal = returnSubtotal - returnDiscount;
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

    // Check if invoice is dirty (has unsaved changes)
    final bool isReturn = state.returnItems.isNotEmpty && state.items.isEmpty;

    bool isDirty = state.isDirty ?? true; // Default to true if null

    // If we have an invoice number, check if the current items match the saved ones
    if (state.invoiceNumber != null && state.invoiceNumber!.isNotEmpty) {
      isDirty = await checkIfInvoiceIsDirty(
        invoiceNumber: state.invoiceNumber,
        currentItems: state.items,
        currentReturnItems: state.returnItems,
        isReturn: isReturn,
      );
    }

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
      isDirty: isDirty,
    );

    emit(newState);

    debugPrint('Emitted new state with updated totals and isDirty: $isDirty');
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
      debugPrint('Found ${unsyncedInvoices.length} unsynced invoices to sync');

      bool currentInvoiceSynced = false;

      if (unsyncedInvoices.isNotEmpty) {
        // Simulate API sync
        await Future.delayed(const Duration(seconds: 1));
        debugPrint('API sync completed successfully');

        // Check if current invoice is in the synced list
        if (state.invoiceNumber != null) {
          final currentInvoice = unsyncedInvoices.firstWhere(
            (invoice) => invoice['invoiceNumber'] == state.invoiceNumber,
            orElse: () => <String, dynamic>{},
          );

          currentInvoiceSynced = currentInvoice.isNotEmpty;

          if (currentInvoiceSynced) {
            debugPrint('Current invoice #${state.invoiceNumber} was synced');
          }
        }

        // Mark invoices as synced in the database
        final invoiceIds =
            unsyncedInvoices.map<int>((i) => i['id'] as int).toList();
        await _invoiceTable.markInvoicesAsSynced(invoiceIds);
        debugPrint(
          'Marked ${invoiceIds.length} invoices as synced in database',
        );
      }

      // Update the UI state
      if (currentInvoiceSynced) {
        // Update the current invoice state to reflect it has been synced
        emit(
          state.copyWith(
            isSyncing: false,
            isSubmitted: true,
            isDirty: false
          )
        );
        debugPrint('Current invoice marked as synced in UI state');
      } else {
        // Otherwise just update the syncing status
        emit(state.copyWith(isSyncing: false));
      }
    } catch (e) {
      debugPrint('Error during sync: $e');
      emit(
        state.copyWith(
          isSyncing: false,
          errorMessage: 'Failed to sync: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onSubmitInvoice(
    SubmitInvoice event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      // Determine what we're submitting
      final bool hasRegularItems = state.items.isNotEmpty;
      final bool hasReturnItems = state.returnItems.isNotEmpty;

      // Validate based on what we're trying to submit
      if (event.isReturn && !hasReturnItems) {
        emit(
          state.copyWith(
            isSubmitting: false,
            errorMessage: 'Cannot submit a return with no items',
          ),
        );
        return;
      } else if (!event.isReturn && !hasRegularItems) {
        emit(
          state.copyWith(
            isSubmitting: false,
            errorMessage: 'Cannot submit an invoice with no items',
          ),
        );
        return;
      }

      String invoiceNumber;
      bool isUpdate = false;

      if (event.isReturn) {
        // For return invoices, ALWAYS get a new invoice number
        // This ensures return invoices are always saved as new records
        invoiceNumber = await _invoiceTable.getNextInvoiceNumber();
        isUpdate = false; // Force treating it as a new invoice
        debugPrint(
          'Creating new return invoice with new number: $invoiceNumber',
        );
      } else {
        // For regular invoices, use existing number or get a new one
        invoiceNumber =
            state.invoiceNumber ?? await _invoiceTable.getNextInvoiceNumber();
        isUpdate = state.invoiceNumber != null;
      }

      int invoiceId;

      // Main invoice submission
      if (isUpdate && !event.isReturn) {
        // Update existing invoice (only for regular invoices)
        debugPrint('Updating existing regular invoice: $invoiceNumber');
        invoiceId = await _invoiceTable.updateInvoice(
          invoiceNumber: invoiceNumber,
          customer: state.customer,
          invoiceState: state,
          isReturn: event.isReturn,
        );
        debugPrint('Updated invoice ID: $invoiceId');
      } else {
        // Save new invoice
        debugPrint(
          'Saving new ${event.isReturn ? "return" : "regular"} invoice: $invoiceNumber',
        );
        invoiceId = await _invoiceTable.saveInvoice(
          invoiceNumber: invoiceNumber,
          customer: state.customer,
          invoiceState: state,
          isReturn: event.isReturn,
        );
        debugPrint('Saved new invoice with ID: $invoiceId');
      }

      // Mark invoice as submitted and explicitly set isDirty to false
      debugPrint('Setting invoice as submitted with isDirty=false');
      emit(
        state.copyWith(
          isSubmitting: false,
          isSubmitted: true,
          invoiceNumber: invoiceNumber,
          isDirty: false, // Explicitly set to false after successful save
        ),
      );

      debugPrint(
        'Invoice successfully submitted, save button should now be disabled',
      );
    } catch (e) {
      debugPrint('Error submitting invoice: $e');
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
      // First determine if we need to save or update the invoice
      if (state.items.isEmpty && state.returnItems.isEmpty) {
        emit(
          state.copyWith(
            isPrinting: false,
            errorMessage: 'Cannot print an invoice with no items',
          ),
        );
        return;
      }

      // Save invoice if it hasn't been saved yet
      String invoiceNumber = state.invoiceNumber ?? '';
      bool isReturn = state.returnItems.isNotEmpty && state.items.isEmpty;

      if (invoiceNumber.isEmpty) {
        debugPrint('Invoice not yet saved, saving before printing...');
        // Save the invoice first by submitting it
        add(SubmitInvoice(isReturn: isReturn));

        // Wait a moment for the submit operation to complete
        await Future.delayed(const Duration(milliseconds: 500));

        // Get the invoice number from the updated state
        invoiceNumber = state.invoiceNumber ?? '';

        if (invoiceNumber.isEmpty) {
          emit(
            state.copyWith(
              isPrinting: false,
              errorMessage: 'Failed to save invoice before printing',
            ),
          );
          return;
        }

        debugPrint(
          'Successfully saved invoice #$invoiceNumber before printing',
        );
      } else {
        debugPrint('Using existing invoice #$invoiceNumber for printing');
      }

      // Now proceed with printing
      debugPrint('Printing invoice #$invoiceNumber...');
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

  // Method to compare current items with items saved in the database
  Future<bool> checkIfInvoiceIsDirty({
    required String? invoiceNumber,
    required List<InvoiceItemModel> currentItems,
    required List<InvoiceItemModel> currentReturnItems,
    required bool isReturn,
  }) async {
    // If no invoice number, it's a new invoice and is considered dirty
    if (invoiceNumber == null || invoiceNumber.isEmpty) {
      return true;
    }

    try {
      // Get saved invoice items from the database based on invoice number
      final savedInvoice = await _invoiceTable.getInvoiceByNumber(
        invoiceNumber,
      );

      if (savedInvoice.isEmpty) {
        return true; // No saved invoice found, so it's dirty
      }

      final invoiceId = savedInvoice['id'] as int;
      final savedItems = await _invoiceTable.getInvoiceItems(invoiceId);

      // If item counts don't match, it's dirty
      final itemsToCheck = isReturn ? currentReturnItems : currentItems;
      if (savedItems.length != itemsToCheck.length) {
        return true;
      }

      // Compare each item
      final Map<String, dynamic> currentItemMap = {};

      // Create a map of current items for easier comparison
      for (final item in itemsToCheck) {
        final key = item.item.itemCode;
        currentItemMap[key] = {
          'quantity': item.quantity,
          'unitPrice': item.item.sellUnitPrice,
        };
      }

      // Compare with saved items
      for (final savedItem in savedItems) {
        final itemCode = savedItem['itemCode'] as String;
        final savedQuantity = savedItem['quantity'] as int;
        final savedUnitPrice = savedItem['unitPrice'] as double;

        // If current items don't contain this saved item or quantities differ
        if (!currentItemMap.containsKey(itemCode) ||
            currentItemMap[itemCode]['quantity'] != savedQuantity ||
            currentItemMap[itemCode]['unitPrice'] != savedUnitPrice) {
          return true;
        }
      }

      // If we reach here, all items match
      return false;
    } catch (e) {
      debugPrint('Error checking if invoice is dirty: $e');
      return true; // On error, assume it's dirty to be safe
    }
  }
}
