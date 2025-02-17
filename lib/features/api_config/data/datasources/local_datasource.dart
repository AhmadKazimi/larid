import 'package:larid/database/database_helper.dart';
import 'package:logging/logging.dart';

class ApiConfigLocalDataSource {
  static ApiConfigLocalDataSource? _instance;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final _logger = Logger('ApiConfigLocalDataSource');

  ApiConfigLocalDataSource._() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  factory ApiConfigLocalDataSource() {
    _instance ??= ApiConfigLocalDataSource._();
    return _instance!;
  }

  Future<void> saveBaseUrl(String baseUrl) async {
    try {
      _logger.info('Attempting to save base URL: $baseUrl');
      final users = await _dbHelper.queryAll('users');
      
      if (users.isEmpty) {
        _logger.info('No existing user found, creating new record');
        final result = await _dbHelper.insert('users', {
          'workspace': '',
          'password': '',
          'baseUrl': baseUrl,
          'userid': ''
        });
        
        if (result == -1) {
          _logger.severe('Failed to insert base URL into database');
          throw Exception('Failed to insert base URL');
        }
        _logger.info('Successfully created new user record with base URL');
      } else {
        _logger.info('Updating existing user record with new base URL');
        final result = await _dbHelper.update(
          'users',
          {'baseUrl': baseUrl},
          'userid = ?',
          [users.first['userid']],
        );
        
        if (result == -1) {
          _logger.severe('Failed to update base URL in database');
          throw Exception('Failed to update base URL');
        }
        _logger.info('Successfully updated base URL for existing user');
      }
    } catch (e) {
      _logger.severe('Error in saveBaseUrl: $e');
      rethrow;
    }
  }

  Future<String?> getBaseUrl() async {
    try {
      _logger.info('Attempting to retrieve base URL');
      final users = await _dbHelper.queryAll('users');
      
      if (users.isEmpty) {
        _logger.info('No user record found, returning null base URL');
        return null;
      }
      
      final baseUrl = users.first['baseUrl'] as String;
      _logger.info('Successfully retrieved base URL: $baseUrl');
      return baseUrl;
    } catch (e) {
      _logger.severe('Error in getBaseUrl: $e');
      return null;
    }
  }
}
