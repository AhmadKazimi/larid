// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInToContinue => 'Sign in to continue';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get login => 'Login';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get passwordMustBe6Chars => 'Password must be at least 6 characters';

  @override
  String get apiConfiguration => 'API Configuration';

  @override
  String get enterApiBaseUrl => 'Enter API Base URL';

  @override
  String get baseUrl => 'Base URL';

  @override
  String get baseUrlHint => 'https://api.example.com';

  @override
  String get pleaseEnterUrl => 'Please enter a URL';

  @override
  String get pleaseEnterValidUrl => 'Please enter a valid URL starting with http:// or https://';

  @override
  String get saveAndContinue => 'Save & Continue';

  @override
  String get home => 'Home';

  @override
  String get welcomeToLarid => 'Welcome to Larid';

  @override
  String get goToLogin => 'Go to Login';

  @override
  String get workspace => 'Workspace';

  @override
  String get pleaseEnterWorkspace => 'Please enter workspace';

  @override
  String get userId => 'User ID';

  @override
  String get pleaseEnterUserId => 'Please enter user ID';

  @override
  String get sync => 'Sync';

  @override
  String get syncStatus => 'Sync Status';

  @override
  String get customers => 'Customers';

  @override
  String get salesRepCustomers => 'Sales Rep Customers';

  @override
  String get prices => 'Prices';

  @override
  String get inventoryItems => 'Inventory Items';

  @override
  String get inventoryUnits => 'Inventory Units';

  @override
  String get salesTaxes => 'Sales Taxes';

  @override
  String get syncAllData => 'Sync All Data';

  @override
  String recordsSynced(Object count) {
    return '$count records synced';
  }

  @override
  String get start => 'Start';

  @override
  String get makeSureInternetConnected => 'Make sure you are connected to the internet';

  @override
  String get dontClosePage => 'Don\'t close this page until sync is complete';

  @override
  String get map => 'Map';

  @override
  String get customerCode => 'Customer Code';

  @override
  String get address => 'Address';

  @override
  String get phone => 'Phone';

  @override
  String get locationServicesRequired => 'Location services are required to use the map';

  @override
  String get locationPermissionRequired => 'Location permission is required to show your location on the map';

  @override
  String get getDirections => 'Get Directions';

  @override
  String get cannotOpenGoogleMaps => 'Cannot open Google Maps';

  @override
  String get startSession => 'Start Session';

  @override
  String get noActiveSessionMessage => 'You don\'t have an active session. Would you like to start a new one?';

  @override
  String get cancel => 'Cancel';
}
