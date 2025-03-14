import 'package:dio/dio.dart';
import 'api_client.dart';
import 'api_endpoints.dart';

class ApiService {
  final DioClient _dioClient;
  String? _warehouse;

  ApiService(this._dioClient);

  // Method to set warehouse value
  void setWarehouse(String warehouse) {
    _warehouse = warehouse;
  }

  // Method to get current warehouse value
  String? get warehouse => _warehouse;

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
        ApiParameters.warehouse: _warehouse,
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

  Future<List<Map<String, dynamic>>> getCompanyInfo({
    required String userid,
    required String workspace,
    required String password,
  }) async {
    try {
      final response = await _dioClient.get(
        ApiEndpoints.getCompanyInfo,
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

  Future<Map<String, dynamic>> uploadReceiptVoucher({
    required String userid,
    required String workspace,
    required String password,
    required String customerCode,
    required double paidAmount,
    required String description,
    required int paymentmethod,
  }) async {
    try {
      final response = await _dioClient.get(
        ApiEndpoints.buildUrl(ApiEndpoints.uploadPayment),
        queryParameters: {
          ApiParameters.userid: userid,
          ApiParameters.workspace: workspace,
          ApiParameters.password: password,
          'customer_cd': customerCode,
          'paid_amt': paidAmount,
          'description': description,
          'paymentmethod': paymentmethod,
        },
      );

      if (response.data is List && response.data.isNotEmpty) {
        final data = response.data[0];
        if (data.containsKey('number')) {
          return {'success': true, 'number': data['number']};
        } else if (data.containsKey('ERROR')) {
          return {'success': false, 'error': data['ERROR']};
        }
      }
      return {'success': false, 'error': 'Unknown error'};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  /// Uploads an invoice to the server
  /// Returns the invoice number on success, throws an exception with appropriate message on failure
  Future<String> uploadInvoice({
    // Auth parameters
    required String userid,
    required String workspace,
    required String password,

    // Customer details
    required String customerCode,
    required String customerName,
    required String customerAddress,
    required String invoiceReference,
    String? comments,

    // Invoice items
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      // Ensure warehouse is set
      if (_warehouse == null || _warehouse!.isEmpty) {
        throw Exception('Warehouse must be set before uploading invoice');
      }

      // Prepare the request JSON body
      final Map<String, dynamic> requestBody = {
        "customer": {
          "code": customerCode,
          "name": customerName,
          "address": customerAddress,
          "reference": invoiceReference,
          "comments": comments ?? "",
        },
        "items":
            items.asMap().entries.map((entry) {
              final int index = entry.key;
              final item = entry.value;

              return {
                "index": index + 1, // itemIndex starts from 1
                "code": item['sItem_cd'],
                "description": item['sDescription'],
                "unit": item['sSellUnit_cd'],
                "qty": item['qty'],
                "price": item['mSellUnitPrice_amt'],
                "total_price": item['mSellUnitPrice_amt'] * item['qty'],
                "tax_cd": item['sTax_cd'],
                "tax_amt": item['taxAmount'] ?? 0.0,
                "tax_pc": item['taxPercentage'] ?? 0.0,
              };
            }).toList(),
      };

      // Log the request for debugging
      print('Upload Invoice Request: ${requestBody.toString()}');

      // Make the API call with auth parameters in headers
      final response = await _dioClient.post(
        ApiEndpoints.buildUrl(ApiEndpoints.uploadInvoice),
        options: Options(
          headers: {
            ApiParameters.userid: userid,
            ApiParameters.workspace: workspace,
            ApiParameters.password: password,
            ApiParameters.warehouse: _warehouse,
          },
        ),
        data: requestBody,
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data;

        // Check if we have an error in the response
        if (responseData.isNotEmpty &&
            responseData[0] is Map<String, dynamic>) {
          final Map<String, dynamic> firstItem = responseData[0];

          // Check for error code
          if (firstItem.containsKey('ERROR')) {
            final String errorCode = firstItem['ERROR'];
            final String errorMessage = _getErrorMessageForCode(errorCode);
            throw Exception(errorMessage);
          }

          // Check for success (invoice number)
          if (firstItem.containsKey('number')) {
            return firstItem['number'];
          }
        }

        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to upload invoice: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  // Helper method to get error message based on error code
  String _getErrorMessageForCode(String errorCode) {
    switch (errorCode) {
      case '-201':
        return 'Payment upload failed';
      case '-401':
        return 'Invoice upload failed';
      case '-601':
        return 'No items provided';
      case '-602':
        return 'No customers provided';
      case '-500':
        return 'Data not completed';
      case '-501':
        return 'Invalid company';
      case '-502':
        return 'Invalid customer';
      case '-503':
        return 'Invalid item';
      case '-504':
        return 'Invalid unit';
      case '-505':
        return 'Invalid tax';
      case '-9000':
        return 'Exception failure';
      case '-700':
        return 'Paid amount exceeds total amount';
      case '-1':
        return 'User does not exist';
      case '-603':
        return 'No default location';
      case '-604':
        return 'No sales tax';
      default:
        return 'Unknown error: $errorCode';
    }
  }

  /// Uploads a return invoice (Credit Memo) to the server
  /// Returns the CM number on success, throws an exception with appropriate message on failure
  Future<String> uploadCM({
    // Auth parameters
    required String userid,
    required String workspace,
    required String password,

    // Customer details
    required String customerCode,
    required String customerName,
    required String customerAddress,
    required String invoiceReference,
    String? comments,

    // Invoice items
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      // Ensure warehouse is set
      if (_warehouse == null || _warehouse!.isEmpty) {
        throw Exception(
          'Warehouse must be set before uploading return invoice',
        );
      }

      // Prepare the request JSON body (same structure as uploadInvoice)
      final Map<String, dynamic> requestBody = {
        "customer": {
          "code": customerCode,
          "name": customerName,
          "address": customerAddress,
          "reference": invoiceReference,
          "comments": comments ?? "",
        },
        "items":
            items.asMap().entries.map((entry) {
              final int index = entry.key;
              final item = entry.value;

              return {
                "index": index + 1, // itemIndex starts from 1
                "code": item['sItem_cd'],
                "description": item['sDescription'],
                "unit": item['sSellUnit_cd'],
                "qty": item['qty'],
                "price": item['mSellUnitPrice_amt'],
                "total_price": item['mSellUnitPrice_amt'] * item['qty'],
                "tax_cd": item['sTax_cd'],
                "tax_amt": item['taxAmount'] ?? 0.0,
                "tax_pc": item['taxPercentage'] ?? 0.0,
              };
            }).toList(),
      };

      // Log the request for debugging
      print('Upload CM (Return Invoice) Request: ${requestBody.toString()}');

      // Make the API call with auth parameters in headers
      final response = await _dioClient.post(
        ApiEndpoints.buildUrl(ApiEndpoints.uploadCM),
        options: Options(
          headers: {
            ApiParameters.userid: userid,
            ApiParameters.workspace: workspace,
            ApiParameters.password: password,
            ApiParameters.warehouse: _warehouse,
          },
        ),
        data: requestBody,
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data;

        // Check if we have an error in the response
        if (responseData.isNotEmpty &&
            responseData[0] is Map<String, dynamic>) {
          final Map<String, dynamic> firstItem = responseData[0];

          // Check for error code
          if (firstItem.containsKey('ERROR')) {
            final String errorCode = firstItem['ERROR'];
            final String errorMessage = _getErrorMessageForCode(errorCode);
            throw Exception(errorMessage);
          }

          // Check for success (invoice number)
          if (firstItem.containsKey('number')) {
            return firstItem['number'];
          }
        }

        throw Exception('Invalid response format');
      } else {
        throw Exception(
          'Failed to upload return invoice: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }
}
