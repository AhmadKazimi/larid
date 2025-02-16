import 'package:larid/database/database_helper.dart';

class ApiConfigLocalDataSource {
  static final ApiConfigLocalDataSource instance = ApiConfigLocalDataSource._init();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  ApiConfigLocalDataSource._init();

  Future<void> saveBaseUrl(String baseUrl) async {
    try {
      final users = await _dbHelper.queryAll('users');
      
      if (users.isEmpty) {
        final result = await _dbHelper.insert('users', {
          'workspace': '',
          'password': '',
          'baseUrl': baseUrl,
          'userid': '',  
        });
        
        if (result == -1) {
          throw Exception('Failed to insert base URL');
        }
      } else {
        final result = await _dbHelper.update(
          'users',
          {'baseUrl': baseUrl},
          'id = ?',
          [users.first['id']],
        );
        
        if (result == -1) {
          throw Exception('Failed to update base URL');
        }
      }
    } catch (e) {
      print('Error in saveBaseUrl: $e');
      rethrow;
    }
  }

  Future<String?> getBaseUrl() async {
    try {
      final users = await _dbHelper.queryAll('users');
      
      if (users.isEmpty) return null;
      return users.first['baseUrl'] as String;
    } catch (e) {
      print('Error in getBaseUrl: $e');
      return null;
    }
  }
}
