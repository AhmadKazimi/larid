import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/customer_entity.dart';

part 'sync_state.freezed.dart';

@freezed
class ApiCallState with _$ApiCallState {
  const factory ApiCallState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    String? errorCode,
    String? errorMessage,
    List<CustomerEntity>? data,
  }) = _ApiCallState;
}

@freezed
class SyncState with _$SyncState {
  const factory SyncState({
    @Default(ApiCallState()) ApiCallState customersState,
    @Default(ApiCallState()) ApiCallState salesRepState,
  }) = _SyncState;
}
