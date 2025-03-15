import 'package:equatable/equatable.dart';
import 'package:larid/features/summary/domain/entities/summary_item_entity.dart';

enum SummaryStatus { initial, loading, loaded, error }

class SummaryState extends Equatable {
  final SummaryStatus status;
  final List<SummaryItemEntity> invoices;
  final List<SummaryItemEntity> returnInvoices;
  final List<SummaryItemEntity> receiptVouchers;
  final String? errorMessage;
  final String? successMessage;
  final Set<String>
  syncingItemIds; // Track items that are currently being synced

  const SummaryState({
    this.status = SummaryStatus.initial,
    this.invoices = const [],
    this.returnInvoices = const [],
    this.receiptVouchers = const [],
    this.errorMessage,
    this.successMessage,
    this.syncingItemIds = const {},
  });

  SummaryState copyWith({
    SummaryStatus? status,
    List<SummaryItemEntity>? invoices,
    List<SummaryItemEntity>? returnInvoices,
    List<SummaryItemEntity>? receiptVouchers,
    String? errorMessage,
    String? successMessage,
    Set<String>? syncingItemIds,
  }) {
    return SummaryState(
      status: status ?? this.status,
      invoices: invoices ?? this.invoices,
      returnInvoices: returnInvoices ?? this.returnInvoices,
      receiptVouchers: receiptVouchers ?? this.receiptVouchers,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      syncingItemIds: syncingItemIds ?? this.syncingItemIds,
    );
  }

  // Check if a specific item is currently syncing
  bool isItemSyncing(String id) => syncingItemIds.contains(id);

  // Get total number of items
  int get totalItems =>
      invoices.length + returnInvoices.length + receiptVouchers.length;

  // Get number of synced items
  int get syncedItems =>
      invoices.where((invoice) => invoice.isSynced).length +
      returnInvoices.where((invoice) => invoice.isSynced).length +
      receiptVouchers.where((voucher) => voucher.isSynced).length;

  // Get sync percentage
  double get syncPercentage =>
      totalItems > 0 ? (syncedItems / totalItems) * 100 : 0;

  @override
  List<Object?> get props => [
    status,
    invoices,
    returnInvoices,
    receiptVouchers,
    errorMessage,
    successMessage,
    syncingItemIds,
  ];
}
