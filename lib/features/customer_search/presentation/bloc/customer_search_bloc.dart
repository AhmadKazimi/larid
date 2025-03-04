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
  
  // Cache for customers - making these public so they can be accessed in the UI
  List<CustomerEntity> _allCustomersCache = [];
  List<CustomerEntity> _todayCustomersCache = [];
  String _lastSearchQuery = '';
  bool _isLoading = false;

  // Public getters for the cache
  List<CustomerEntity> get allCustomersCache => _allCustomersCache;
  List<CustomerEntity> get todayCustomersCache => _todayCustomersCache;

  CustomerSearchBloc() : super(const CustomerSearchState.initial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SwitchCustomerList>(_onSwitchCustomerList);
  }

  Future<void> _onSwitchCustomerList(
    SwitchCustomerList event,
    Emitter<CustomerSearchState> emit,
  ) async {
    // Prevent duplicate loading states if already loading
    if (_isLoading) return;
    _isLoading = true;
    
    // Check if we already have cached data to show immediately
    List<CustomerEntity> cachedCustomers = event.showTodayCustomers 
        ? _todayCustomersCache 
        : _allCustomersCache;
        
    // If we have cached data, show it immediately without loading state
    if (cachedCustomers.isNotEmpty) {
      emit(CustomerSearchState.loaded(customers: cachedCustomers));
      // Only fetch fresh data if cache is older than 30 seconds
      if (!_needsRefresh(event.showTodayCustomers)) {
        _isLoading = false;
        return;
      }
    } else {
      // No cached data, show loading state
      emit(const CustomerSearchState.loading());
    }
    
    try {
      List<CustomerEntity> customers;
      
      if (event.showTodayCustomers) {
        // Refresh today's customers data
        _todayCustomersCache = await _customerTable.searchSalesRepCustomers('');
        customers = _todayCustomersCache;
        _updateRefreshTime(true);
      } else {
        // Refresh all customers data
        _allCustomersCache = await _customerTable.searchCustomers('');
        customers = _allCustomersCache;
        _updateRefreshTime(false);
      }
      
      if (!emit.isDone) {
        emit(CustomerSearchState.loaded(customers: customers));
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(CustomerSearchState.error(message: e.toString()));
      }
    } finally {
      _isLoading = false;
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

    // Prevent duplicate loading states if already loading
    if (_isLoading) return;
    _isLoading = true;
    
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
    } finally {
      _isLoading = false;
    }
  }

  // Track when each cache was last refreshed
  DateTime _lastTodayCustomersRefresh = DateTime(1970);
  DateTime _lastAllCustomersRefresh = DateTime(1970);
  
  // Check if data needs refreshing (older than 30 seconds)
  bool _needsRefresh(bool isTodayCustomers) {
    final now = DateTime.now();
    if (isTodayCustomers) {
      return now.difference(_lastTodayCustomersRefresh).inSeconds > 30;
    } else {
      return now.difference(_lastAllCustomersRefresh).inSeconds > 30;
    }
  }
  
  // Update last refresh time
  void _updateRefreshTime(bool isTodayCustomers) {
    final now = DateTime.now();
    if (isTodayCustomers) {
      _lastTodayCustomersRefresh = now;
    } else {
      _lastAllCustomersRefresh = now;
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
