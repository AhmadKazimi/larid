import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _isSyncedKey = 'is_synced';
  static const String _companyLogoPathKey = 'company_logo_path';
  static const String _languageKey = 'language';
  static SharedPreferences? _prefs;

  // Photo capture storage keys prefixes
  static const String _beforeImagePathPrefix = 'before_image_path_';
  static const String _afterImagePathPrefix = 'after_image_path_';
  static const String _beforeImageSyncedPrefix = 'before_image_synced_';
  static const String _afterImageSyncedPrefix = 'after_image_synced_';
  static const String _beforeImageFilenamePrefix = 'before_image_filename_';
  static const String _afterImageFilenamePrefix = 'after_image_filename_';

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

  static Future<void> clear() async {
    await _prefs?.remove(_isLoggedInKey);
    await _prefs?.remove(_isSyncedKey);
  }

  static Future<void> clearUserData() async {
    await clear();
  }

  static Future<void> setCompanyLogoPath(String path) async {
    await _prefs?.setString(_companyLogoPathKey, path);
  }

  static String? getCompanyLogoPath() {
    return _prefs?.getString(_companyLogoPathKey);
  }

  static Future<void> setLanguage(String languageCode) async {
    await _prefs?.setString(_languageKey, languageCode);
  }

  static String? getLanguage() {
    return _prefs?.getString(_languageKey) ?? 'ar';
  }

  // Photo capture storage methods

  // Store before image path for a customer
  static Future<void> setBeforeImagePath(
    String customerCode,
    String path,
  ) async {
    await _prefs?.setString('$_beforeImagePathPrefix$customerCode', path);
  }

  // Get before image path for a customer
  static String? getBeforeImagePath(String customerCode) {
    return _prefs?.getString('$_beforeImagePathPrefix$customerCode');
  }

  // Store after image path for a customer
  static Future<void> setAfterImagePath(
    String customerCode,
    String path,
  ) async {
    await _prefs?.setString('$_afterImagePathPrefix$customerCode', path);
  }

  // Get after image path for a customer
  static String? getAfterImagePath(String customerCode) {
    return _prefs?.getString('$_afterImagePathPrefix$customerCode');
  }

  // Store before image sync state for a customer
  static Future<void> setBeforeImageSynced(
    String customerCode,
    bool synced,
  ) async {
    await _prefs?.setBool('$_beforeImageSyncedPrefix$customerCode', synced);
  }

  // Get before image sync state for a customer
  static bool getBeforeImageSynced(String customerCode) {
    return _prefs?.getBool('$_beforeImageSyncedPrefix$customerCode') ?? false;
  }

  // Store after image sync state for a customer
  static Future<void> setAfterImageSynced(
    String customerCode,
    bool synced,
  ) async {
    await _prefs?.setBool('$_afterImageSyncedPrefix$customerCode', synced);
  }

  // Get after image sync state for a customer
  static bool getAfterImageSynced(String customerCode) {
    return _prefs?.getBool('$_afterImageSyncedPrefix$customerCode') ?? false;
  }

  // Store before image filename (from server) for a customer
  static Future<void> setBeforeImageFilename(
    String customerCode,
    String filename,
  ) async {
    await _prefs?.setString(
      '$_beforeImageFilenamePrefix$customerCode',
      filename,
    );
  }

  // Get before image filename for a customer
  static String? getBeforeImageFilename(String customerCode) {
    return _prefs?.getString('$_beforeImageFilenamePrefix$customerCode');
  }

  // Store after image filename (from server) for a customer
  static Future<void> setAfterImageFilename(
    String customerCode,
    String filename,
  ) async {
    await _prefs?.setString(
      '$_afterImageFilenamePrefix$customerCode',
      filename,
    );
  }

  // Get after image filename for a customer
  static String? getAfterImageFilename(String customerCode) {
    return _prefs?.getString('$_afterImageFilenamePrefix$customerCode');
  }

  // Clear all photo data for a customer
  static Future<void> clearPhotoData(String customerCode) async {
    await _prefs?.remove('$_beforeImagePathPrefix$customerCode');
    await _prefs?.remove('$_afterImagePathPrefix$customerCode');
    await _prefs?.remove('$_beforeImageSyncedPrefix$customerCode');
    await _prefs?.remove('$_afterImageSyncedPrefix$customerCode');
    await _prefs?.remove('$_beforeImageFilenamePrefix$customerCode');
    await _prefs?.remove('$_afterImageFilenamePrefix$customerCode');
  }
}
