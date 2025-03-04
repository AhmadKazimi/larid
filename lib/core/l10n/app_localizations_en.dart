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
  String get searchForClient => 'Search for client...';

  @override
  String get sessionEnded => 'Session ended';

  @override
  String get endSession => 'End Session';

  @override
  String get endSessionConfirmation => 'Are you sure you want to end the current session?';

  @override
  String get end => 'End';

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
  String get startVisit => 'Start Visit';

  @override
  String get cannotOpenGoogleMaps => 'Cannot open Google Maps';

  @override
  String get startSession => 'Start Session';

  @override
  String get noActiveSessionMessage => 'You don\'t have an active session. Would you like to start a new one?';

  @override
  String get cancel => 'Cancel';

  @override
  String get sessionDuration => 'Session Duration';

  @override
  String get minutes => 'Minutes';

  @override
  String get hours => 'Hours';

  @override
  String get days => 'Days';

  @override
  String get months => 'Months';

  @override
  String get years => 'Years';

  @override
  String get noLocationAvailable => 'No location available for this customer';

  @override
  String get invalidCoordinates => 'Invalid coordinates format';

  @override
  String get todayCustomers => 'Today\'s Customers';

  @override
  String get notExists => 'Not exists';

  @override
  String get todayCustomersTab => 'Today\'s Customers';

  @override
  String get customersTab => 'Customers';

  @override
  String get customerDetails => 'Customer Details';

  @override
  String get activities => 'Activities';

  @override
  String get createInvoice => 'Create Invoice';

  @override
  String get createNewInvoiceOrReturn => 'Create a new invoice or return';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get captureAndSavePhoto => 'Capture and save photos';

  @override
  String get receiptVoucher => 'Receipt Voucher';

  @override
  String get createReceiptVoucher => 'Create a receipt voucher';

  @override
  String get noExist => 'Not Available';

  @override
  String get startCustomerVisit => 'Start Customer Visit';

  @override
  String visitStartedAt(String time) {
    return 'Visit started at: $time';
  }

  @override
  String get visitSessionInfo => 'You can perform multiple activities during this visit session. The session will end only when you click \"End Visit Session\" button.';

  @override
  String get endVisitSession => 'End Visit Session';

  @override
  String get visitSessionEnded => 'Visit session ended';

  @override
  String get visitSessionStarted => 'Visit session started successfully';

  @override
  String activeVisitWith(String customerName) {
    return 'Active visit with $customerName';
  }

  @override
  String get activeVisit => 'Active Visit';

  @override
  String get continueVisiting => 'CONTINUE';

  @override
  String otherCustomerActiveVisit(String customerName) {
    return 'There is already an active visit for $customerName. Please end that visit first.';
  }

  @override
  String get invoice => 'Invoice';

  @override
  String get subTotal => 'Subtotal';

  @override
  String get discount => 'Discount';

  @override
  String get total => 'Total';

  @override
  String get salesTax => 'Sales Tax';

  @override
  String get grandTotal => 'Grand Total';

  @override
  String get returnItems => 'Returns';

  @override
  String get summary => 'Summary';

  @override
  String get netSubTotal => 'Net Subtotal';

  @override
  String get netDiscount => 'Net Discount';

  @override
  String get netTotal => 'Net Total';

  @override
  String get netSalesTax => 'Net Sales Tax';

  @override
  String get netGrandTotal => 'Net Grand Total';

  @override
  String get addComment => 'Add comment';

  @override
  String get submit => 'Submit';

  @override
  String get print => 'Print';

  @override
  String get addItem => 'Add Item';

  @override
  String get returnItem => 'Return Item';
}
