import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../database/customer_table.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../features/sync/domain/entities/customer_entity.dart';
import 'customer_search_event.dart';
import 'customer_search_state.dart';

class CustomerSearchBloc extends Bloc<CustomerSearchEvent, CustomerSearchState> {
  final CustomerTable _customerTable = getIt<CustomerTable>();
  Timer? _debounce;
  
  // Cache for customers
  List<CustomerEntity> _allCustomersCache = [];
  List<CustomerEntity> _todayCustomersCache = [];
  String _lastSearchQuery = '';

  CustomerSearchBloc() : super(const CustomerSearchState.initial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SwitchCustomerList>(_onSwitchCustomerList);
  }

  Future<void> _onSwitchCustomerList(
    SwitchCustomerList event,
    Emitter<CustomerSearchState> emit,
  ) async {
    emit(const CustomerSearchState.loading());
    
    try {
      List<CustomerEntity> customers;
      
      if (event.showTodayCustomers) {
        // Initialize today's customers cache if empty
        if (_todayCustomersCache.isEmpty) {
          _todayCustomersCache = await _customerTable.searchSalesRepCustomers('');
        }
        customers = _todayCustomersCache;
      } else {
        // Initialize all customers cache if empty
        if (_allCustomersCache.isEmpty) {
          _allCustomersCache = await _customerTable.searchCustomers('');
        }
        customers = _allCustomersCache;
      }
      
      if (!emit.isDone) {
        emit(CustomerSearchState.loaded(customers: customers));
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(CustomerSearchState.error(message: e.toString()));
      }
    }
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<CustomerSearchState> emit,
  ) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    // If query is empty and we have cache, use it
    if (event.query.isEmpty) {
      return _onSwitchCustomerList(
        SwitchCustomerList(showTodayCustomers: event.searchInToday),
        emit,
      );
    }

    emit(const CustomerSearchState.loading());
    _lastSearchQuery = event.query;
    
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
    _allCustomersCache = [];
    _todayCustomersCache = [];
    return super.close();
  }
}
