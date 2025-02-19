import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/sync_customers_usecase.dart';
import 'sync_event.dart';
import 'sync_state.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final SyncCustomersUseCase _syncCustomersUseCase;

  SyncBloc({required SyncCustomersUseCase syncCustomersUseCase})
    : _syncCustomersUseCase = syncCustomersUseCase,
      super(const SyncState.initial()) {
    on<SyncEvent>((event, emit) async {
      try {
        emit(const SyncState.loading());
        
        final customers = await _syncCustomersUseCase();
        emit(SyncState.success(customers));
      } catch (e) {
        emit(SyncState.error(e.toString()));
      }
    });
  }
}
