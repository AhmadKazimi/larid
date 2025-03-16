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
  String get warehouse => 'Warehouse';

  @override
  String get companyInfo => 'Company Info';

  @override
  String get syncAllData => 'Sync All Data';

  @override
  String recordsSynced(int count) {
    return '$count records synced';
  }

  @override
  String get start => 'Start';

  @override
  String get syncError => 'Sync Error';

  @override
  String get syncSuccess => 'Sync Successful';

  @override
  String get syncInProgress => 'Sync in Progress';

  @override
  String get syncComplete => 'Sync Complete';

  @override
  String get syncFailed => 'Sync Failed';

  @override
  String get retrySync => 'Retry Sync';

  @override
  String syncProgress(int progress) {
    return '$progress%';
  }

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
  String get distance => 'Distance';

  @override
  String distanceWithValue(String distance) {
    return '$distance km';
  }

  @override
  String distanceWithTime(String distance, int duration) {
    return '$distance km (~$duration min)';
  }

  @override
  String approximateDistance(String distance) {
    return '$distance km (approximate)';
  }

  @override
  String straightLineDistance(String distance) {
    return '$distance km (straight line)';
  }

  @override
  String get loadingDistance => 'Calculating...';

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
  String get visitRestriction => 'Visit Restriction';

  @override
  String get alreadyVisitedToday => 'You already visited this customer today. Please come back tomorrow.';

  @override
  String get ok => 'OK';

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
  String get receiptDetails => 'Receipt Details';

  @override
  String get amount => 'Amount';

  @override
  String get pleaseEnterAmount => 'Please enter an amount';

  @override
  String get pleaseEnterValidNumber => 'Please enter a valid number';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get pleaseSelectPaymentMethod => 'Please select a payment method';

  @override
  String get notes => 'Notes';

  @override
  String get saveReceiptVoucher => 'Save Receipt Voucher';

  @override
  String get cash => 'Cash';

  @override
  String get check => 'Check';

  @override
  String get bankTransfer => 'Bank Transfer';

  @override
  String get creditCard => 'Credit Card';

  @override
  String get masterCard => 'Master Card';

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

  @override
  String get items => 'Items';

  @override
  String get search => 'Search';

  @override
  String get searchHint => 'Search by code or description';

  @override
  String get quantity => 'Quantity';

  @override
  String get price => 'Price';

  @override
  String get saveItems => 'Save Items';

  @override
  String get cancelItems => 'Cancel';

  @override
  String get noItemsFound => 'No items found';

  @override
  String get loadingItems => 'Loading items...';

  @override
  String get loadMore => 'Load More';

  @override
  String itemsSelected(int count) {
    return '$count items selected';
  }

  @override
  String get invoiceItems => 'Invoice Items';

  @override
  String get paymentType => 'Payment Type';

  @override
  String get credit => 'Credit';

  @override
  String get cheque => 'Cheque';

  @override
  String get invoiceDetails => 'Invoice Details';

  @override
  String get returnDetails => 'Return Details';

  @override
  String get invoiceSavedSuccessfully => 'Invoice saved successfully';

  @override
  String get returnSavedSuccessfully => 'Return saved successfully';

  @override
  String get invoiceDeletedSuccessfully => 'Invoice deleted successfully';

  @override
  String get deleteInvoice => 'Delete Invoice';

  @override
  String get deleteConfirmation => 'Are you sure to delete the invoice';

  @override
  String get printInvoice => 'Print Invoice';

  @override
  String get returnInvoice => 'Return Invoice';

  @override
  String get generatingPdf => 'Generating PDF...';

  @override
  String get errorGeneratingPdf => 'Error generating PDF';

  @override
  String get noPdfFileToShare => 'No PDF file to share';

  @override
  String get share => 'Share';

  @override
  String get sharingInvoice => 'Sharing Invoice';

  @override
  String get sharingReturnInvoice => 'Sharing Return';

  @override
  String get customerInformation => 'Customer Information';

  @override
  String get customerName => 'Customer Name';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get comment => 'Comment';

  @override
  String get description => 'Description';

  @override
  String get unitPrice => 'Unit Price';

  @override
  String get itemCode => 'Item Code';

  @override
  String get thankYouForYourBusiness => 'Thank you for your business!';

  @override
  String get invoiceNumber => 'Invoice #';

  @override
  String get newInvoice => 'New Invoice';

  @override
  String get noInvoiceToDelete => 'No invoice to delete';

  @override
  String get uploadingInvoice => 'Uploading invoice...';

  @override
  String get savingInvoice => 'Saving invoice...';

  @override
  String get userNotLoggedIn => 'User not logged in';

  @override
  String get noItemsToUpload => 'No items to upload';

  @override
  String get failedToGenerateInvoiceNumber => 'Failed to generate invoice number for return. Please try submitting first.';

  @override
  String get success => 'Success';

  @override
  String invoiceUploadedSuccessfully(String number) {
    return 'Invoice uploaded successfully. Invoice #$number';
  }

  @override
  String get error => 'Error';

  @override
  String errorUploadingInvoice(String message) {
    return 'Error: $message';
  }

  @override
  String tax(String percentage, String amount) {
    return 'Tax $percentage%: $amount';
  }

  @override
  String currency(String amount, String symbol) {
    return '$amount $symbol';
  }

  @override
  String quantityTimesPrice(String price, String quantity) {
    return '$price × $quantity';
  }

  @override
  String get customerNotFound => 'Customer not found';

  @override
  String get noNumber => 'no number';

  @override
  String get regular => 'Regular';

  @override
  String get returnType => 'Return';

  @override
  String unsynchronizedInvoices(String type, int count) {
    return 'Unsynchronized $type invoices for this customer: $count';
  }

  @override
  String usingMostRecentInvoice(String type) {
    return 'Using the most recent $type invoice for this customer';
  }

  @override
  String get itemMissingFields => 'Item missing required fields, skipping';

  @override
  String itemNotFound(String code) {
    return 'Item $code not found in inventory, skipping';
  }

  @override
  String itemFound(String description) {
    return 'Item found in inventory: $description';
  }

  @override
  String unitPriceFromDatabase(String price, String converted) {
    return 'Unit price from database: $price (converted to: $converted)';
  }

  @override
  String calculatedTotalPrice(String price) {
    return 'Calculated total price: $price';
  }

  @override
  String addedToReturnItems(String code, int quantity) {
    return 'Added to RETURN items: $code, quantity: $quantity';
  }

  @override
  String addedToRegularItems(String code, int quantity) {
    return 'Added to REGULAR items: $code, quantity: $quantity';
  }

  @override
  String errorProcessingItem(String error) {
    return 'ERROR processing item: $error';
  }

  @override
  String createdItemsSummary(int regular, int returns) {
    return 'Created $regular regular items and $returns return items';
  }

  @override
  String get receiptVoucherSaved => 'Receipt voucher saved successfully';

  @override
  String get errorSavingReceiptVoucher => 'Error saving receipt voucher';

  @override
  String get savingReceiptVoucher => 'Saving voucher receipt';

  @override
  String get beforePicture => 'Before Picture';

  @override
  String get afterPicture => 'After Picture';

  @override
  String get cameraPermissionRequired => 'Camera permission is required to take photos';

  @override
  String get errorTakingPhoto => 'Error taking photo. Please try again.';

  @override
  String get tapToTakePhoto => 'Tap to take photo';

  @override
  String get takingPicture => 'Taking Picture';

  @override
  String get settings => 'Settings';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmation => 'Are you sure you want to log out?';

  @override
  String get yes => 'Yes';

  @override
  String get companyLogo => 'Company Logo';

  @override
  String get tapToAddLogo => 'Tap to add logo';

  @override
  String get logoUpdated => 'Logo updated successfully';

  @override
  String get errorUpdatingLogo => 'Error updating logo';

  @override
  String get language => 'Language';

  @override
  String get languageChanged => 'Language changed successfully';

  @override
  String get synced => 'Synced';

  @override
  String get syncNow => 'Sync';

  @override
  String get vouchers => 'Vouchers';

  @override
  String get salesData => 'Sales Data';

  @override
  String get today => 'Today';

  @override
  String syncingItem(String title) {
    return 'Syncing $title...';
  }

  @override
  String get syncingData => 'Syncing data...';

  @override
  String itemsSynced(int synced, int total) {
    return '$synced of $total items synced';
  }
}
