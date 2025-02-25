import '../../../../database/customer_table.dart';
import '../../domain/entities/customer_search_entity.dart';
import '../../domain/repositories/customer_search_repository.dart';

class CustomerSearchRepositoryImpl implements CustomerSearchRepository {
  final CustomerTable customerTable;

  CustomerSearchRepositoryImpl({required this.customerTable});

  @override
  Future<CustomerSearchResult> searchCustomers(String query) async {
    final customers = await customerTable.searchCustomers(query);
    return CustomerSearchResult(customers: customers);
  }

  @override
  Future<CustomerSearchResult> searchTodayCustomers(String query) async {
    final customers = await customerTable.searchSalesRepCustomers(query);
    return CustomerSearchResult(customers: customers);
  }

  @override
  Future<CustomerSearchResult> getAllCustomers() async {
    final customers = await customerTable.getAllCustomers();
    return CustomerSearchResult(customers: customers);
  }
}
