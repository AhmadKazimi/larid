import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../features/sync/domain/entities/customer_entity.dart';

part 'customer_search_state.freezed.dart';

@freezed
class CustomerSearchState with _$CustomerSearchState {
  const factory CustomerSearchState.initial() = _Initial;
  const factory CustomerSearchState.loading() = _Loading;
  const factory CustomerSearchState.loaded({
    required List<CustomerEntity> customers,
  }) = _Loaded;
  const factory CustomerSearchState.error({required String message}) = _Error;
}
