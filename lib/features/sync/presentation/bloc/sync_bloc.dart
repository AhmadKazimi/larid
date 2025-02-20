import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/api_response.dart';
import '../../domain/usecases/sync_customers_usecase.dart';
import '../../domain/usecases/sync_sales_rep_customers_usecase.dart';
import 'sync_event.dart';
import 'sync_state.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final SyncCustomersUseCase _syncCustomersUseCase;
  final SyncSalesRepCustomersUseCase _syncSalesRepCustomersUseCase;

  SyncBloc({
    required SyncCustomersUseCase syncCustomersUseCase,
    required SyncSalesRepCustomersUseCase syncSalesRepCustomersUseCase,
  })  : _syncCustomersUseCase = syncCustomersUseCase,
        _syncSalesRepCustomersUseCase = syncSalesRepCustomersUseCase,
        super(const SyncState()) {
    on<SyncEvent>((event, emit) async {
      await event.when(
        syncCustomers: () => _onSyncCustomers(emit),
        syncSalesRepCustomers: () => _onSyncSalesRepCustomers(emit),
      );
    });
  }

  Future<void> _onSyncCustomers(Emitter<SyncState> emit) async {
    try {
      // Set loading state
      emit(state.copyWith(
        customersState: state.customersState.copyWith(isLoading: true),
      ));

      final response = await _syncCustomersUseCase();
      
      if (response.isSuccess) {
        emit(state.copyWith(
          customersState: ApiCallState(
            isLoading: false,
            isSuccess: true,
            data: response.data,
          ),
        ));
      } else {
        emit(state.copyWith(
          customersState: ApiCallState(
            isLoading: false,
            isSuccess: false,
            errorCode: response.errorCode,
            errorMessage: response.message,
          ),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        customersState: ApiCallState(
          isLoading: false,
          isSuccess: false,
          errorCode: '-9000',
          errorMessage: e.toString(),
        ),
      ));
    }
  }

  Future<void> _onSyncSalesRepCustomers(Emitter<SyncState> emit) async {
    try {
      // Set loading state
      emit(state.copyWith(
        salesRepState: state.salesRepState.copyWith(isLoading: true),
      ));

      final response = await _syncSalesRepCustomersUseCase();
      
      if (response.isSuccess) {
        emit(state.copyWith(
          salesRepState: ApiCallState(
            isLoading: false,
            isSuccess: true,
            data: response.data,
          ),
        ));
      } else {
        emit(state.copyWith(
          salesRepState: ApiCallState(
            isLoading: false,
            isSuccess: false,
            errorCode: response.errorCode,
            errorMessage: response.message,
          ),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        salesRepState: ApiCallState(
          isLoading: false,
          isSuccess: false,
          errorCode: '-9000',
          errorMessage: e.toString(),
        ),
      ));
    }
  }
}
