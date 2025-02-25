import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../features/sync/domain/entities/customer_entity.dart';

part 'customer_search_entity.freezed.dart';

@freezed
class CustomerSearchResult with _$CustomerSearchResult {
  const factory CustomerSearchResult({
    required List<CustomerEntity> customers,
  }) = _CustomerSearchResult;
}
