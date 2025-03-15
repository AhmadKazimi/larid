import 'package:equatable/equatable.dart';

abstract class SummaryEvent extends Equatable {
  const SummaryEvent();

  @override
  List<Object?> get props => [];
}

class LoadSummaryData extends SummaryEvent {
  const LoadSummaryData();
}

class UpdateInvoiceSyncStatus extends SummaryEvent {
  final String id;

  const UpdateInvoiceSyncStatus({required this.id});

  @override
  List<Object?> get props => [id];
}

class UpdateReceiptVoucherSyncStatus extends SummaryEvent {
  final String id;

  const UpdateReceiptVoucherSyncStatus({required this.id});

  @override
  List<Object?> get props => [id];
}

class SyncAllData extends SummaryEvent {
  const SyncAllData();
}
