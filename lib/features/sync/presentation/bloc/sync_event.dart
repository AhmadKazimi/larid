import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_event.freezed.dart';

@freezed
class SyncEvent with _$SyncEvent {
  const factory SyncEvent.syncCustomers() = _SyncCustomers;
  const factory SyncEvent.syncSalesRepCustomers() = _SyncSalesRepCustomers;
}
