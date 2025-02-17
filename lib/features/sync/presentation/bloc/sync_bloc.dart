import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/sync_customers_usecase.dart';
import 'sync_event.dart';
import 'sync_state.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final SyncCustomersUseCase _syncCustomersUseCase;

  SyncBloc({required SyncCustomersUseCase syncCustomersUseCase})
    : _syncCustomersUseCase = syncCustomersUseCase,
      super(const SyncState.initial()) {
    on<SyncEvent>(_onSyncCustomers);
  }

  Future<void> _onSyncCustomers(
    SyncEvent event,
    Emitter<SyncState> emit,
  ) async {
    try {
      emit(const SyncState.loading());
      
      await event.when(
        syncCustomers: (userid, workspace, password) async {
          final customers = await _syncCustomersUseCase(
            userid: userid,
            workspace: workspace,
            password: password,
          );
          
          emit(SyncState.success(customers));
        },
      );
    } catch (e) {
      emit(SyncState.error(e.toString()));
    }
  }
}
