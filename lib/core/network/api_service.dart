import 'package:dio/dio.dart';
import 'api_client.dart';
import 'api_endpoints.dart';

class ApiService {
  final DioClient _dioClient;

  ApiService(this._dioClient);


  /// Checks user credentials against the server
  /// Returns true if authentication is successful (response is "1"),
  /// throws an error otherwise
  Future<bool> checkUser({
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
        // Convert response data to string to handle both string and int responses
        final responseData = response.data.toString();
        if (responseData == "1") {
          return true;
        } else {
          throw 'Invalid credentials';
        }
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

  Future<List<Map<String, dynamic>>> getCustomers({
    required String userid,
    required String workspace,
    required String password,
  }) async {
    try {
      final response = await _dioClient.get(
        ApiEndpoints.buildUrl(ApiEndpoints.getCustomers),
        queryParameters: {
          ApiParameters.userid: userid,
          ApiParameters.workspace: workspace,
          ApiParameters.password: password,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.cast<Map<String, dynamic>>();
      }
      throw Exception('Failed to get customers');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getSalesrepRouteCustomers({
    required String userid,
    required String workspace,
    required String password,
  }) async {
    try {
      final response = await _dioClient.get(
        ApiEndpoints.buildUrl(ApiEndpoints.getSalesrepRouteCustomers),
        queryParameters: {
          ApiParameters.userid: userid,
          ApiParameters.workspace: workspace,
          ApiParameters.password: password,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.cast<Map<String, dynamic>>();
      }
      throw Exception('Failed to get salesrep route customers');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getCustomersPriceList({
    required String userid,
    required String workspace,
    required String password,
  }) async {
    final response = await _dioClient.get(
      ApiEndpoints.getCustomersPriceList,
      queryParameters: {
        ApiParameters.userid: userid,
        ApiParameters.workspace: workspace,
        ApiParameters.password: password,
      },
    );
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<List<Map<String, dynamic>>> getInventoryItems({
    required String userid,
    required String workspace,
    required String password,
  }) async {
    final response = await _dioClient.get(
      ApiEndpoints.getInventoryItems,
      queryParameters: {
        ApiParameters.userid: userid,
        ApiParameters.workspace: workspace,
        ApiParameters.password: password,
        ApiParameters.warehouse: 'MAIN',
      },
    );
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<List<Map<String, dynamic>>> getInventoryUnits({
    required String userid,
    required String workspace,
    required String password,
  }) async {
    try {   
      final response = await _dioClient.get(
        ApiEndpoints.getInventoryUnits,
        queryParameters: {
          ApiParameters.userid: userid,
          ApiParameters.workspace: workspace,
          ApiParameters.password: password,
        },
      );
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> getSalesTaxes({
    required String userid,
    required String workspace,
    required String password,
  }) async {
    try {   
      final response = await _dioClient.get(
        ApiEndpoints.getSalesTaxes,
        queryParameters: {
          ApiParameters.userid: userid,
          ApiParameters.workspace: workspace,
          ApiParameters.password: password,
        },
      );
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

}
