part of 'api_config_bloc.dart';

@freezed
class ApiConfigEvent with _$ApiConfigEvent {
  const factory ApiConfigEvent.saveBaseUrl(String baseUrl) = _SaveBaseUrl;
  const factory ApiConfigEvent.checkBaseUrl() = _CheckBaseUrl;
}
