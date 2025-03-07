import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_event.freezed.dart';

@freezed
class SyncEvent with _$SyncEvent {
  const factory SyncEvent.syncCustomers() = _SyncCustomers;
  const factory SyncEvent.syncSalesRepCustomers() = _SyncSalesRepCustomers;
  const factory SyncEvent.syncPrices() = _SyncPrices;
  const factory SyncEvent.syncInventoryItems() = _SyncInventoryItems;
  const factory SyncEvent.syncInventoryUnits() = _SyncInventoryUnits;
  const factory SyncEvent.syncSalesTaxes() = _SyncSalesTaxes;
  const factory SyncEvent.syncUserWarehouse() = _SyncUserWarehouse;
}
