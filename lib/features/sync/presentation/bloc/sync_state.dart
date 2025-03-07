import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/customer_entity.dart';
import '../../domain/entities/inventory/inventory_item_entity.dart';
import '../../domain/entities/inventory/inventory_unit_entity.dart';
import '../../domain/entities/prices/prices_entity.dart';
import '../../domain/entities/sales_tax_entity.dart';
import '../../domain/entities/warehouse/warehouse_entity.dart';

part 'sync_state.freezed.dart';

@freezed
class ApiCallState<T> with _$ApiCallState<T> {
  const factory ApiCallState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    String? errorCode,
    String? errorMessage,
    List<T>? data,
  }) = _ApiCallState;

  const ApiCallState._();

  bool get hasError => errorCode != null;
}

@freezed
class SyncState with _$SyncState {
  const SyncState._();

  const factory SyncState({
    @Default(ApiCallState()) ApiCallState<CustomerEntity> customersState,
    @Default(ApiCallState()) ApiCallState<CustomerEntity> salesRepState,
    @Default(ApiCallState()) ApiCallState<PriceEntity> pricesState,
    @Default(ApiCallState())
    ApiCallState<InventoryItemEntity> inventoryItemsState,
    @Default(ApiCallState())
    ApiCallState<InventoryUnitEntity> inventoryUnitsState,
    @Default(ApiCallState()) ApiCallState<SalesTaxEntity> salesTaxesState,
    @Default(ApiCallState()) ApiCallState<WarehouseEntity> warehouseState,
  }) = _SyncState;

  bool get isAllSynced =>
      customersState.isSuccess &&
      salesRepState.isSuccess &&
      pricesState.isSuccess &&
      inventoryItemsState.isSuccess &&
      inventoryUnitsState.isSuccess &&
      salesTaxesState.isSuccess &&
      warehouseState.isSuccess;
}
