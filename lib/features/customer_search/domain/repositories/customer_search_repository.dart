import '../entities/customer_search_entity.dart';

abstract class CustomerSearchRepository {
  Future<CustomerSearchResult> searchCustomers(String query);
  Future<CustomerSearchResult> searchTodayCustomers(String query);
  Future<CustomerSearchResult> getAllCustomers();
}
