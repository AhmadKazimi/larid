import 'package:larid/features/api_config/data/datasources/local_datasource.dart';
import 'package:larid/features/api_config/domain/repositories/api_config_repository.dart';

class ApiConfigRepositoryImpl implements ApiConfigRepository {
  final ApiConfigLocalDataSource localDataSource;

  ApiConfigRepositoryImpl({required this.localDataSource});

  @override
  Future<String?> getBaseUrl() async {
    return await localDataSource.getBaseUrl();
  }

  @override
  Future<void> saveBaseUrl(String baseUrl) async {
    await localDataSource.saveBaseUrl(baseUrl);
  }
}
