import 'package:dio/dio.dart';
import 'dio_client.dart';
import 'api_endpoints.dart';

class ApiService {
  final DioClient _dioClient;

  ApiService(this._dioClient);

  /// Checks user credentials against the server
  /// 
  /// Returns the response data if successful, throws an error otherwise
  Future<Map<String, dynamic>> checkUser({
    required String userid,
    required String workspace,
    required String password,
  }) async {
    try {
      final response = await _dioClient.get(
        ApiEndpoints.buildUrl(ApiEndpoints.checkUser),
        queryParameters: {
          ApiParameters.userid: userid,
          ApiParameters.workspace: workspace,
          ApiParameters.password: password,
        },
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to check user credentials',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw 'Invalid credentials';
      } else if (e.response?.statusCode == 404) {
        throw 'User not found';
      } else {
        throw 'Failed to connect to server: ${e.message}';
      }
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }
}
