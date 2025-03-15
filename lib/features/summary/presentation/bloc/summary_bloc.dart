import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larid/features/summary/domain/usecases/get_invoices_usecase.dart';
import 'package:larid/features/summary/domain/usecases/get_receipt_vouchers_usecase.dart';
import 'package:larid/features/summary/presentation/bloc/summary_event.dart';
import 'package:larid/features/summary/presentation/bloc/summary_state.dart';
import 'package:larid/features/summary/domain/repositories/summary_repository.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:larid/core/l10n/app_localizations.dart';
import 'package:larid/core/network/api_service.dart';
import 'package:larid/database/invoice_table.dart';
import 'package:larid/features/auth/domain/repositories/auth_repository.dart';
import 'package:larid/database/receipt_voucher_table.dart';

class SummaryBloc extends Bloc<SummaryEvent, SummaryState> {
  final GetInvoicesUseCase _getInvoicesUseCase;
  final GetReceiptVouchersUseCase _getReceiptVouchersUseCase;
  final SummaryRepository _repository;

  SummaryBloc({
    required GetInvoicesUseCase getInvoicesUseCase,
    required GetReceiptVouchersUseCase getReceiptVouchersUseCase,
    required SummaryRepository repository,
  }) : _getInvoicesUseCase = getInvoicesUseCase,
       _getReceiptVouchersUseCase = getReceiptVouchersUseCase,
       _repository = repository,
       super(const SummaryState()) {
    on<LoadSummaryData>(_onLoadSummaryData);
    on<UpdateInvoiceSyncStatus>(_onUpdateInvoiceSyncStatus);
    on<UpdateReceiptVoucherSyncStatus>(_onUpdateReceiptVoucherSyncStatus);
    on<SyncAllData>(_onSyncAllData);
  }

  Future<void> _onLoadSummaryData(
    LoadSummaryData event,
    Emitter<SummaryState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SummaryStatus.loading));

      // Get regular invoices
      final invoices = await _getInvoicesUseCase();

      // Get return invoices
      final returnInvoices = await _getInvoicesUseCase(returnInvoices: true);

      // Get receipt vouchers
      final receiptVouchers = await _getReceiptVouchersUseCase();

      emit(
        state.copyWith(
          status: SummaryStatus.loaded,
          invoices: invoices,
          returnInvoices: returnInvoices,
          receiptVouchers: receiptVouchers,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SummaryStatus.error,
          errorMessage: 'Failed to load summary data: $e',
        ),
      );
    }
  }

  Future<void> _onUpdateInvoiceSyncStatus(
    UpdateInvoiceSyncStatus event,
    Emitter<SummaryState> emit,
  ) async {
    try {
      // Add item to syncing items
      emit(state.copyWith(syncingItemIds: {...state.syncingItemIds, event.id}));

      // Get the API service
      final apiService = GetIt.I<ApiService>();

      // Get the invoice table
      final invoiceTable = GetIt.I<InvoiceTable>();

      // Get the invoice
      final invoiceId = int.parse(event.id);
      final invoices = await invoiceTable.db.query(
        InvoiceTable.tableName,
        where: 'id = ?',
        whereArgs: [invoiceId],
      );

      if (invoices.isEmpty) {
        // Remove item from syncing items
        emit(
          state.copyWith(
            errorMessage: 'Invoice not found',
            syncingItemIds:
                state.syncingItemIds.where((id) => id != event.id).toSet(),
          ),
        );
        return;
      }

      final invoice = invoices.first;

      // Get the invoice items
      final items = await invoiceTable.db.query(
        InvoiceTable.invoiceItemsTableName,
        where: 'invoiceId = ?',
        whereArgs: [invoiceId],
      );

      // Get the current user credentials
      final authRepository = GetIt.I<AuthRepository>();
      final currentUser = await authRepository.getCurrentUser();

      if (currentUser == null) {
        // Remove item from syncing items
        emit(
          state.copyWith(
            errorMessage: 'User not logged in',
            syncingItemIds:
                state.syncingItemIds.where((id) => id != event.id).toSet(),
          ),
        );
        return;
      }

      try {
        // Call the API to upload the invoice
        final isReturn = invoice['isReturn'] == 1;
        final customerCode = invoice['customerId'].toString();
        final customerName = invoice['customerName'].toString();
        final customerAddress = invoice['customerAddress']?.toString() ?? '';
        final invoiceReference = invoice['invoiceNumber'].toString();
        final comments = invoice['comment']?.toString() ?? '';

        // Prepare items for upload
        final itemsForUpload =
            items
                .map(
                  (item) => {
                    'sItem_cd': item['itemCode'].toString(),
                    'sDescription': item['description'].toString(),
                    'sSellUnit_cd': item['sellUnitCode'].toString(),
                    'qty': double.parse(item['quantity'].toString()),
                    'mSellUnitPrice_amt': double.parse(
                      item['unitPrice'].toString(),
                    ),
                    'sTax_cd': item['taxCode'].toString(),
                    'taxAmount':
                        item['tax_amt'] != null
                            ? double.parse(item['tax_amt'].toString())
                            : 0.0,
                    'taxPercentage':
                        item['tax_pc'] != null
                            ? double.parse(item['tax_pc'].toString())
                            : 0.0,
                  },
                )
                .toList();

        String invoiceNumber;

        if (isReturn) {
          // Upload return invoice
          invoiceNumber = await apiService.uploadCM(
            userid: currentUser.userid,
            workspace: currentUser.workspace,
            password: currentUser.password,
            customerCode: customerCode,
            customerName: customerName,
            customerAddress: customerAddress,
            invoiceReference: invoiceReference,
            comments: comments,
            items: itemsForUpload,
          );
        } else {
          // Upload invoice
          invoiceNumber = await apiService.uploadInvoice(
            userid: currentUser.userid,
            workspace: currentUser.workspace,
            password: currentUser.password,
            customerCode: customerCode,
            customerName: customerName,
            customerAddress: customerAddress,
            invoiceReference: invoiceReference,
            comments: comments,
            items: itemsForUpload,
          );
        }

        // Update the invoice sync status in the database
        await invoiceTable.updateSyncStatus(invoiceId, 1);

        // Update the state to show success
        emit(
          state.copyWith(
            successMessage: 'Invoice #$invoiceNumber synced successfully',
            invoices: await _getInvoicesUseCase(),
            returnInvoices: await _getInvoicesUseCase(returnInvoices: true),
            syncingItemIds:
                state.syncingItemIds.where((id) => id != event.id).toSet(),
          ),
        );
      } catch (e) {
        // Handle API error - Remove item from syncing items
        emit(
          state.copyWith(
            errorMessage: 'Failed to sync invoice: ${e.toString()}',
            syncingItemIds:
                state.syncingItemIds.where((id) => id != event.id).toSet(),
          ),
        );
      }
    } catch (e) {
      // General error handling - Remove item from syncing items
      emit(
        state.copyWith(
          errorMessage: 'Failed to sync invoice: ${e.toString()}',
          syncingItemIds:
              state.syncingItemIds.where((id) => id != event.id).toSet(),
        ),
      );
    }
  }

  Future<void> _onUpdateReceiptVoucherSyncStatus(
    UpdateReceiptVoucherSyncStatus event,
    Emitter<SummaryState> emit,
  ) async {
    try {
      // Add item to syncing items
      emit(state.copyWith(syncingItemIds: {...state.syncingItemIds, event.id}));

      // Get the API service
      final apiService = GetIt.I<ApiService>();

      // Get the receipt voucher table
      final receiptVoucherTable = GetIt.I<ReceiptVoucherTable>();

      // Get the receipt voucher
      final receiptVoucherId = int.parse(event.id);
      final vouchers = await receiptVoucherTable.db.query(
        ReceiptVoucherTable.tableName,
        where: 'id = ?',
        whereArgs: [receiptVoucherId],
      );

      if (vouchers.isEmpty) {
        // Remove item from syncing items
        emit(
          state.copyWith(
            errorMessage: 'Receipt voucher not found',
            syncingItemIds:
                state.syncingItemIds.where((id) => id != event.id).toSet(),
          ),
        );
        return;
      }

      final voucher = vouchers.first;

      // Get the current user credentials
      final authRepository = GetIt.I<AuthRepository>();
      final currentUser = await authRepository.getCurrentUser();

      if (currentUser == null) {
        // Remove item from syncing items
        emit(
          state.copyWith(
            errorMessage: 'User not logged in',
            syncingItemIds:
                state.syncingItemIds.where((id) => id != event.id).toSet(),
          ),
        );
        return;
      }

      try {
        // Call the API to upload the receipt voucher
        final customerCode = voucher['customer_cd'] as String;
        final paidAmount = voucher['paid_amt'] as double;
        final description = voucher['description'] as String? ?? '';
        final paymentType = int.parse(voucher['payment_type'].toString());

        // Upload the receipt voucher
        final result = await apiService.uploadReceiptVoucher(
          userid: currentUser.userid,
          workspace: currentUser.workspace,
          password: currentUser.password,
          customerCode: customerCode,
          paidAmount: paidAmount,
          description: description,
          paymentmethod: paymentType,
        );

        if (result['success'] == true) {
          // Update the receipt voucher sync status in the database
          await receiptVoucherTable.updateSyncStatus(receiptVoucherId, 1);

          // Update the state to show success and remove from syncing items
          final receiptNumber =
              result['number']?.toString() ?? receiptVoucherId.toString();
          emit(
            state.copyWith(
              successMessage: 'Receipt #$receiptNumber synced successfully',
              receiptVouchers: await _getReceiptVouchersUseCase(),
              syncingItemIds:
                  state.syncingItemIds.where((id) => id != event.id).toSet(),
            ),
          );
        } else {
          // Handle API error - Remove item from syncing items
          final errorMessage = result['error'] ?? 'Unknown error';
          emit(
            state.copyWith(
              errorMessage: 'Failed to sync receipt voucher: $errorMessage',
              syncingItemIds:
                  state.syncingItemIds.where((id) => id != event.id).toSet(),
            ),
          );
        }
      } catch (e) {
        // Handle API error - Remove item from syncing items
        emit(
          state.copyWith(
            errorMessage: 'Failed to sync receipt voucher: ${e.toString()}',
            syncingItemIds:
                state.syncingItemIds.where((id) => id != event.id).toSet(),
          ),
        );
      }
    } catch (e) {
      // General error handling - Remove item from syncing items
      emit(
        state.copyWith(
          errorMessage: 'Failed to sync receipt voucher: ${e.toString()}',
          syncingItemIds:
              state.syncingItemIds.where((id) => id != event.id).toSet(),
        ),
      );
    }
  }

  Future<void> _onSyncAllData(
    SyncAllData event,
    Emitter<SummaryState> emit,
  ) async {
    try {
      // Set status to loading for sync UI feedback
      emit(state.copyWith(status: SummaryStatus.loading));

      // Get all unsynced invoices and receipt vouchers
      final unsyncedInvoices =
          state.invoices
              .where((invoice) => !invoice.isSynced)
              .map((invoice) => invoice.id)
              .toList();

      final unsyncedReturnInvoices =
          state.returnInvoices
              .where((invoice) => !invoice.isSynced)
              .map((invoice) => invoice.id)
              .toList();

      final unsyncedVouchers =
          state.receiptVouchers
              .where((voucher) => !voucher.isSynced)
              .map((voucher) => voucher.id)
              .toList();

      // Initialize success and error counters
      int successCount = 0;
      int errorCount = 0;

      // Sync regular invoices
      for (final id in unsyncedInvoices) {
        try {
          // Add to syncing items set
          emit(state.copyWith(syncingItemIds: {...state.syncingItemIds, id}));

          // Trigger sync
          add(UpdateInvoiceSyncStatus(id: id));

          // Simple delay to prevent overwhelming the server with requests
          await Future.delayed(const Duration(milliseconds: 300));

          successCount++;
        } catch (e) {
          errorCount++;
        }
      }

      // Sync return invoices
      for (final id in unsyncedReturnInvoices) {
        try {
          // Add to syncing items set
          emit(state.copyWith(syncingItemIds: {...state.syncingItemIds, id}));

          // Trigger sync
          add(UpdateInvoiceSyncStatus(id: id));

          // Simple delay to prevent overwhelming the server
          await Future.delayed(const Duration(milliseconds: 300));

          successCount++;
        } catch (e) {
          errorCount++;
        }
      }

      // Sync receipt vouchers
      for (final id in unsyncedVouchers) {
        try {
          // Add to syncing items set
          emit(state.copyWith(syncingItemIds: {...state.syncingItemIds, id}));

          // Trigger sync
          add(UpdateReceiptVoucherSyncStatus(id: id));

          // Simple delay to prevent overwhelming the server
          await Future.delayed(const Duration(milliseconds: 300));

          successCount++;
        } catch (e) {
          errorCount++;
        }
      }

      // Reload data when done
      add(const LoadSummaryData());

      // Show summary message
      final totalAttempted =
          unsyncedInvoices.length +
          unsyncedReturnInvoices.length +
          unsyncedVouchers.length;
      if (totalAttempted > 0) {
        if (errorCount == 0) {
          emit(
            state.copyWith(
              successMessage: 'All $totalAttempted items synced successfully',
              status: SummaryStatus.loaded,
            ),
          );
        } else {
          emit(
            state.copyWith(
              successMessage: '$successCount items synced, $errorCount failed',
              status: SummaryStatus.loaded,
            ),
          );
        }
      } else {
        // Nothing to sync
        emit(state.copyWith(status: SummaryStatus.loaded));
      }
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: 'Error syncing data: ${e.toString()}',
          status: SummaryStatus.loaded,
        ),
      );
    }
  }
}
