import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:larid/core/di/service_locator.dart';
import 'package:larid/features/api_config/domain/repositories/api_config_repository.dart';
import 'package:logging/logging.dart';
import '../../../../core/router/app_router.dart';

part 'api_config_event.dart';
part 'api_config_state.dart';
part 'api_config_bloc.freezed.dart';

class ApiConfigBloc extends Bloc<ApiConfigEvent, ApiConfigState> {
  final ApiConfigRepository repository;
  final _logger = Logger('ApiConfigBloc');

  ApiConfigBloc({required this.repository}) : super(const ApiConfigState.initial()) {
    on<_SaveBaseUrl>(_onSaveBaseUrl);
    on<_CheckBaseUrl>(_onCheckBaseUrl);
  }

  Future<void> _onSaveBaseUrl(_SaveBaseUrl event, Emitter<ApiConfigState> emit) async {
    emit(const ApiConfigState.loading());
    try {
      _logger.info('Saving base URL: ${event.baseUrl}');
      
      // Save base URL to database
      await repository.saveBaseUrl(event.baseUrl);
      
      // Update network components
      await updateDioClientBaseUrl(event.baseUrl);
  
      
      _logger.info('Base URL saved successfully');
      emit(const ApiConfigState.saved());
    } catch (e) {
      _logger.severe('Error saving base URL: $e');
      emit(ApiConfigState.error(e.toString()));
    }
  }

  Future<void> _onCheckBaseUrl(_CheckBaseUrl event, Emitter<ApiConfigState> emit) async {
    emit(const ApiConfigState.loading());
    try {
      _logger.info('Checking base URL');
      final baseUrl = await repository.getBaseUrl();
      
      if (baseUrl != null && baseUrl.isNotEmpty) {
        _logger.info('Base URL exists: $baseUrl');
        emit(ApiConfigState.exists(baseUrl));
      } else {
        _logger.info('Base URL does not exist');
        emit(const ApiConfigState.notExists());
      }
    } catch (e) {
      _logger.severe('Error checking base URL: $e');
      emit(ApiConfigState.error(e.toString()));
    }
  }
}
