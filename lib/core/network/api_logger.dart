import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiLogger extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('\n🌐 API Request:');
      print('URL: ${options.uri}');
      print('Method: ${options.method}');
      print('Headers: ${options.headers}');
      if (options.method == 'GET') {
        print('Query Parameters: ${options.queryParameters}');
      } else {
        print('Body: ${options.data}');
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print('\n✅ API Response:');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers.map}');
      print('Body: ${response.data}');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('\n❌ API Error:');
      print('URL: ${err.requestOptions.uri}');
      print('Status Code: ${err.response?.statusCode}');
      print('Error Message: ${err.message}');
      print('Error Data: ${err.response?.data}');
      print('Stack Trace: ${err.stackTrace}');
    }
    super.onError(err, handler);
  }
}
