abstract class ApiConfigRepository {
  Future<void> saveBaseUrl(String baseUrl);
  Future<String?> getBaseUrl();
}
