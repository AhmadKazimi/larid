part of 'api_config_bloc.dart';

@freezed
class ApiConfigState with _$ApiConfigState {
  const factory ApiConfigState.initial() = _Initial;
  const factory ApiConfigState.loading() = _Loading;
  const factory ApiConfigState.exists(String baseUrl) = _Exists;
  const factory ApiConfigState.notExists() = _NotExists;
  const factory ApiConfigState.saved() = _Saved;
  const factory ApiConfigState.error(String message) = _Error;
}
