import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _isSyncedKey = 'is_synced';
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setLoggedIn(bool value) async {
    await _prefs?.setBool(_isLoggedInKey, value);
  }

  static bool isLoggedIn() {
    return _prefs?.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> setSynced(bool value) async {
    await _prefs?.setBool(_isSyncedKey, value);
  }

  static bool isSynced() {
    return _prefs?.getBool(_isSyncedKey) ?? false;
  }

  static Future<void> clearLoginState() async {
    await _prefs?.remove(_isLoggedInKey);
    await _prefs?.remove(_isSyncedKey);
  }
}
