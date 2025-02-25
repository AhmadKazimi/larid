import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../database/customer_table.dart';
import '../../../../core/di/service_locator.dart';
import 'customer_search_event.dart';
import 'customer_search_state.dart';

class CustomerSearchBloc extends Bloc<CustomerSearchEvent, CustomerSearchState> {
  final CustomerTable _customerTable = getIt<CustomerTable>();
  Timer? _debounce;

  CustomerSearchBloc() : super(const CustomerSearchState.initial()) {
    on<LoadInitialData>(_onLoadInitialData);
    on<SearchQueryChanged>(_onSearchQueryChanged);
  }

  Future<void> _onLoadInitialData(
    LoadInitialData event,
    Emitter<CustomerSearchState> emit,
  ) async {
    try {
      emit(const CustomerSearchState.loading());
      final customers = await _customerTable.getAllCustomers();
      emit(CustomerSearchState.loaded(customers: customers));
    } catch (e) {
      emit(CustomerSearchState.error(message: e.toString()));
    }
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<CustomerSearchState> emit,
  ) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    emit(const CustomerSearchState.loading());
    
    try {
      final customers = event.searchInToday
        ? await _customerTable.searchSalesRepCustomers(event.query)
        : await _customerTable.searchCustomers(event.query);
      
      if (!emit.isDone) {
        emit(CustomerSearchState.loaded(customers: customers));
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(CustomerSearchState.error(message: e.toString()));
      }
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
