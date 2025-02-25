import '../entities/customer_search_entity.dart';
import '../repositories/customer_search_repository.dart';

class SearchTodayCustomersUseCase {
  final CustomerSearchRepository repository;

  SearchTodayCustomersUseCase(this.repository);

  Future<CustomerSearchResult> call(String query) {
    return repository.searchTodayCustomers(query);
  }
}
