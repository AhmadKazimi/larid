import '../entities/customer_search_entity.dart';
import '../repositories/customer_search_repository.dart';

class GetAllCustomersUseCase {
  final CustomerSearchRepository repository;

  GetAllCustomersUseCase(this.repository);

  Future<CustomerSearchResult> call() {
    return repository.getAllCustomers();
  }
}
