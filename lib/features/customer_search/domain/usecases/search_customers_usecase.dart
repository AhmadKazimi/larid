import '../entities/customer_search_entity.dart';
import '../repositories/customer_search_repository.dart';

class SearchCustomersUseCase {
  final CustomerSearchRepository repository;

  SearchCustomersUseCase(this.repository);

  Future<CustomerSearchResult> call(String query) {
    return repository.searchCustomers(query);
  }
}
