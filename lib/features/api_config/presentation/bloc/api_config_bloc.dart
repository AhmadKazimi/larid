import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:larid/features/api_config/domain/repositories/api_config_repository.dart';

part 'api_config_event.dart';
part 'api_config_state.dart';
part 'api_config_bloc.freezed.dart';

class ApiConfigBloc extends Bloc<ApiConfigEvent, ApiConfigState> {
  final ApiConfigRepository repository;

  ApiConfigBloc({required this.repository}) : super(const ApiConfigState.initial()) {
    on<_SaveBaseUrl>(_onSaveBaseUrl);
    on<_CheckBaseUrl>(_onCheckBaseUrl);
  }

  Future<void> _onSaveBaseUrl(_SaveBaseUrl event, Emitter<ApiConfigState> emit) async {
    emit(const ApiConfigState.loading());
    try {
      await repository.saveBaseUrl(event.baseUrl);
      emit(const ApiConfigState.saved());
    } catch (e) {
      emit(ApiConfigState.error(e.toString()));
    }
  }

  Future<void> _onCheckBaseUrl(_CheckBaseUrl event, Emitter<ApiConfigState> emit) async {
    emit(const ApiConfigState.loading());
    try {
      final baseUrl = await repository.getBaseUrl();
      if (baseUrl != null && baseUrl.isNotEmpty) {
        emit(ApiConfigState.exists(baseUrl));
      } else {
        emit(const ApiConfigState.notExists());
      }
    } catch (e) {
      emit(ApiConfigState.error(e.toString()));
    }
  }
}
