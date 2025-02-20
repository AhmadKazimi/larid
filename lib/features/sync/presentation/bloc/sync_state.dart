import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/customer_entity.dart';
import '../../domain/entities/inventory/inventory_item_entity.dart';
import '../../domain/entities/inventory/inventory_unit_entity.dart';
import '../../domain/entities/prices/prices_entity.dart';

part 'sync_state.freezed.dart';

@freezed
class ApiCallState<T> with _$ApiCallState<T> {
  const factory ApiCallState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    String? errorCode,
    String? errorMessage,
    List<T>? data,
  }) = _ApiCallState<T>;
}

@freezed
class SyncState with _$SyncState {
  const factory SyncState({
    @Default(ApiCallState<CustomerEntity>()) ApiCallState<CustomerEntity> customersState,
    @Default(ApiCallState<CustomerEntity>()) ApiCallState<CustomerEntity> salesRepState,
    @Default(ApiCallState<PriceEntity>()) ApiCallState<PriceEntity> pricesState,
    @Default(ApiCallState<InventoryItemEntity>()) ApiCallState<InventoryItemEntity> inventoryItemsState,
    @Default(ApiCallState<InventoryUnitEntity>()) ApiCallState<InventoryUnitEntity> inventoryUnitsState,
  }) = _SyncState;
}
