import 'dart:convert';

class ApiResponse<T> {
  final T? data;
  final String? errorCode;
  final String? message;

  ApiResponse({
    this.data,
    this.errorCode,
    this.message,
  });

  bool get isSuccess => errorCode == null || errorCode == '0';

  factory ApiResponse.fromJson(String str, T Function(Map<String, dynamic>) fromJson) {
    final jsonData = json.decode(str);
    
    // Handle array response with error
    if (jsonData is List && jsonData.isNotEmpty && jsonData[0] is Map) {
      final firstItem = jsonData[0];
      if (firstItem.containsKey('ERROR')) {
        return ApiResponse(
          errorCode: firstItem['ERROR']?.toString(),
          message: 'Error occurred during sync',
        );
      }
    }
    
    // Handle error response
    if (jsonData is Map) {
      if (jsonData.containsKey('ERROR')) {
        return ApiResponse(
          errorCode: jsonData['ERROR']?.toString(),
          message: jsonData['Message'] ?? 'Error occurred during sync',
        );
      }
      
      if (jsonData.containsKey('Message') && jsonData['Message'] == 'An error has occurred.') {
        return ApiResponse(
          errorCode: '-9000',
          message: jsonData['Message'],
        );
      }
    }
    
    // Handle success response
    try {
      final data = fromJson(jsonData is List ? {'items': jsonData} : jsonData);
      return ApiResponse(data: data);
    } catch (e) {
      return ApiResponse(
        errorCode: '-9000',
        message: 'Failed to parse response: ${e.toString()}',
      );
    }
  }
}
