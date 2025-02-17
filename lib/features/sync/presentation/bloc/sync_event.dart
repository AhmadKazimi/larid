import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_event.freezed.dart';

@freezed
class SyncEvent with _$SyncEvent {
  const factory SyncEvent.syncCustomers({
    required String userid,
    required String workspace,
    required String password,
  }) = _SyncCustomers;
}
