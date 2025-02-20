import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/error_codes.dart';
import '../../../../core/models/api_response.dart';
import '../../domain/entities/customer_entity.dart';
import '../../domain/entities/inventory/inventory_item_entity.dart';
import '../../domain/entities/prices/prices_entity.dart';
import '../../domain/usecases/sync_customers_usecase.dart';
import '../../domain/usecases/sync_inventory_items_usecase.dart';
import '../../domain/usecases/sync_prices_usecase.dart';
import '../../domain/usecases/sync_sales_rep_customers_usecase.dart';
import 'sync_event.dart';
import 'sync_state.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final SyncCustomersUseCase _syncCustomersUseCase;
  final SyncSalesRepCustomersUseCase _syncSalesRepCustomersUseCase;
  final SyncPricesUseCase _syncPricesUseCase;
  final SyncInventoryItemsUseCase _syncInventoryItemsUseCase;

  SyncBloc({
    required SyncCustomersUseCase syncCustomersUseCase,
    required SyncSalesRepCustomersUseCase syncSalesRepCustomersUseCase,
    required SyncPricesUseCase syncPricesUseCase,
    required SyncInventoryItemsUseCase syncInventoryItemsUseCase,
  })  : _syncCustomersUseCase = syncCustomersUseCase,
        _syncSalesRepCustomersUseCase = syncSalesRepCustomersUseCase,
        _syncPricesUseCase = syncPricesUseCase,
        _syncInventoryItemsUseCase = syncInventoryItemsUseCase,
        super(const SyncState()) {
    on<SyncEvent>((event, emit) async {
      await event.when(
        syncCustomers: () => _onSyncCustomers(emit),
        syncSalesRepCustomers: () => _onSyncSalesRepCustomers(emit),
        syncPrices: () => _onSyncPrices(emit),
        syncInventoryItems: () => _onSyncInventoryItems(emit),
      );
    });
  }

  Future<void> _onSyncCustomers(Emitter<SyncState> emit) async {
    try {
      emit(state.copyWith(
        customersState: state.customersState.copyWith(isLoading: true),
      ));

      final response = await _syncCustomersUseCase();
      
      if (response.isSuccess) {
        emit(state.copyWith(
          customersState: ApiCallState<CustomerEntity>(
            isLoading: false,
            isSuccess: true,
            data: response.data,
          ),
        ));
      } else {
        emit(state.copyWith(
          customersState: ApiCallState<CustomerEntity>(
            isLoading: false,
            isSuccess: false,
            errorCode: response.errorCode,
            errorMessage: response.message,
          ),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        customersState: ApiCallState<CustomerEntity>(
          isLoading: false,
          isSuccess: false,
          errorCode: ApiErrorCode.unknown.message,
          errorMessage: e.toString(),
        ),
      ));
    }
  }

  Future<void> _onSyncSalesRepCustomers(Emitter<SyncState> emit) async {
    try {
      emit(state.copyWith(
        salesRepState: state.salesRepState.copyWith(isLoading: true),
      ));

      final response = await _syncSalesRepCustomersUseCase();
      
      if (response.isSuccess) {
        emit(state.copyWith(
          salesRepState: ApiCallState<CustomerEntity>(
            isLoading: false,
            isSuccess: true,
            data: response.data,
          ),
        ));
      } else {
        emit(state.copyWith(
          salesRepState: ApiCallState<CustomerEntity>(
            isLoading: false,
            isSuccess: false,
            errorCode: response.errorCode,
            errorMessage: response.message,
          ),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        salesRepState: ApiCallState<CustomerEntity>(
          isLoading: false,
          isSuccess: false,
          errorCode: ApiErrorCode.unknown.message,
          errorMessage: e.toString(),
        ),
      ));
    }
  }

  Future<void> _onSyncPrices(Emitter<SyncState> emit) async {
    try {
      emit(state.copyWith(
        pricesState: state.pricesState.copyWith(isLoading: true),
      ));

      final response = await _syncPricesUseCase();
      
      if (response.isSuccess && response.data != null) {
        emit(state.copyWith(
          pricesState: ApiCallState<PriceEntity>(
            isLoading: false,
            isSuccess: true,
            data: response.data,
          ),
        ));
      } else {
        emit(state.copyWith(
          pricesState: ApiCallState<PriceEntity>(
            isLoading: false,
            isSuccess: false,
            errorCode: response.errorCode ?? ApiErrorCode.unknown.message,
            errorMessage: response.message ?? 'Unknown error occurred',
          ),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        pricesState: ApiCallState<PriceEntity>(
          isLoading: false,
          isSuccess: false,
          errorCode: ApiErrorCode.unknown.message,
          errorMessage: e.toString(),
        ),
      ));
    }
  }

  Future<void> _onSyncInventoryItems(Emitter<SyncState> emit) async {
    try {
      emit(state.copyWith(
        inventoryItemsState: state.inventoryItemsState.copyWith(isLoading: true),
      ));

      final response = await _syncInventoryItemsUseCase();
      
      if (response.isSuccess && response.data != null) {
        emit(state.copyWith(
          inventoryItemsState: ApiCallState<InventoryItemEntity>(
            isLoading: false,
            isSuccess: true,
            data: response.data,
          ),
        ));
      } else {
        emit(state.copyWith(
          inventoryItemsState: ApiCallState<InventoryItemEntity>(
            isLoading: false,
            isSuccess: false,
            errorCode: response.errorCode ?? ApiErrorCode.unknown.message,
            errorMessage: response.message ?? 'Unknown error occurred',
          ),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        inventoryItemsState: ApiCallState<InventoryItemEntity>(
          isLoading: false,
          isSuccess: false,
          errorCode: ApiErrorCode.unknown.message,
          errorMessage: e.toString(),
        ),
      ));
    }
  }
}
