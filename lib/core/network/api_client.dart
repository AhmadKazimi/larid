import 'package:dio/dio.dart';
import 'api_logger.dart';

class DioClient {
  static DioClient? _instance;
  String? baseUrl;
  late Dio _dio;

  DioClient._(); // private constructor

  static DioClient get instance {
    _instance ??= DioClient._();
    return _instance!;
  }

  static Future<void> initialize(String? initialBaseUrl) async {
    final client = DioClient.instance;
    if (initialBaseUrl != null && initialBaseUrl.isNotEmpty) {
      client.baseUrl = initialBaseUrl;
    }
    client._initializeDio();
  }

  bool get isBaseUrlSet => baseUrl != null && baseUrl!.isNotEmpty;

  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? '',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    )..interceptors.addAll([
        ApiLogger(),
      ]);

    // Add request interceptor to check base URL
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (!isBaseUrlSet) {
            return handler.reject(
              DioException(
                requestOptions: options,
                error: 'Base URL is not set',
              ),
            );
          }
          return handler.next(options);
        },
      ),
    );
  }

  void setBaseUrl(String newBaseUrl) {
    baseUrl = newBaseUrl;
    _dio.options.baseUrl = newBaseUrl;
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  void addAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}
