import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/customer_entity.dart';

part 'sync_state.freezed.dart';

@freezed
class SyncState with _$SyncState {
  const factory SyncState.initial() = _Initial;
  const factory SyncState.loading() = _Loading;
  const factory SyncState.success(List<CustomerEntity> customers) = _Success;
  const factory SyncState.error(String message) = _Error;
}
