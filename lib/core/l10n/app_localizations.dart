import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinue;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @passwordMustBe6Chars.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMustBe6Chars;

  /// No description provided for @apiConfiguration.
  ///
  /// In en, this message translates to:
  /// **'API Configuration'**
  String get apiConfiguration;

  /// No description provided for @enterApiBaseUrl.
  ///
  /// In en, this message translates to:
  /// **'Enter API Base URL'**
  String get enterApiBaseUrl;

  /// No description provided for @baseUrl.
  ///
  /// In en, this message translates to:
  /// **'Base URL'**
  String get baseUrl;

  /// No description provided for @baseUrlHint.
  ///
  /// In en, this message translates to:
  /// **'https://api.example.com'**
  String get baseUrlHint;

  /// No description provided for @pleaseEnterUrl.
  ///
  /// In en, this message translates to:
  /// **'Please enter a URL'**
  String get pleaseEnterUrl;

  /// No description provided for @pleaseEnterValidUrl.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid URL starting with http:// or https://'**
  String get pleaseEnterValidUrl;

  /// No description provided for @saveAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Save & Continue'**
  String get saveAndContinue;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @welcomeToLarid.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Larid'**
  String get welcomeToLarid;

  /// No description provided for @goToLogin.
  ///
  /// In en, this message translates to:
  /// **'Go to Login'**
  String get goToLogin;

  /// No description provided for @workspace.
  ///
  /// In en, this message translates to:
  /// **'Workspace'**
  String get workspace;

  /// No description provided for @pleaseEnterWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Please enter workspace'**
  String get pleaseEnterWorkspace;

  /// No description provided for @userId.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get userId;

  /// No description provided for @pleaseEnterUserId.
  ///
  /// In en, this message translates to:
  /// **'Please enter user ID'**
  String get pleaseEnterUserId;

  /// No description provided for @sync.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get sync;

  /// No description provided for @syncStatus.
  ///
  /// In en, this message translates to:
  /// **'Sync Status'**
  String get syncStatus;

  /// No description provided for @customers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customers;

  /// No description provided for @salesRepCustomers.
  ///
  /// In en, this message translates to:
  /// **'Sales Rep Customers'**
  String get salesRepCustomers;

  /// No description provided for @prices.
  ///
  /// In en, this message translates to:
  /// **'Prices'**
  String get prices;

  /// No description provided for @inventoryItems.
  ///
  /// In en, this message translates to:
  /// **'Inventory Items'**
  String get inventoryItems;

  /// No description provided for @inventoryUnits.
  ///
  /// In en, this message translates to:
  /// **'Inventory Units'**
  String get inventoryUnits;

  /// No description provided for @salesTaxes.
  ///
  /// In en, this message translates to:
  /// **'Sales Taxes'**
  String get salesTaxes;

  /// No description provided for @warehouse.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get warehouse;

  /// No description provided for @companyInfo.
  ///
  /// In en, this message translates to:
  /// **'Company Info'**
  String get companyInfo;

  /// No description provided for @syncAllData.
  ///
  /// In en, this message translates to:
  /// **'Sync All Data'**
  String get syncAllData;

  /// No description provided for @recordsSynced.
  ///
  /// In en, this message translates to:
  /// **'{count} records synced'**
  String recordsSynced(int count);

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @syncError.
  ///
  /// In en, this message translates to:
  /// **'Sync Error'**
  String get syncError;

  /// No description provided for @syncSuccess.
  ///
  /// In en, this message translates to:
  /// **'Sync Successful'**
  String get syncSuccess;

  /// No description provided for @syncInProgress.
  ///
  /// In en, this message translates to:
  /// **'Sync in Progress'**
  String get syncInProgress;

  /// No description provided for @syncComplete.
  ///
  /// In en, this message translates to:
  /// **'Sync Complete'**
  String get syncComplete;

  /// No description provided for @syncFailed.
  ///
  /// In en, this message translates to:
  /// **'Sync Failed'**
  String get syncFailed;

  /// No description provided for @retrySync.
  ///
  /// In en, this message translates to:
  /// **'Retry Sync'**
  String get retrySync;

  /// No description provided for @syncProgress.
  ///
  /// In en, this message translates to:
  /// **'{progress}%'**
  String syncProgress(int progress);

  /// No description provided for @makeSureInternetConnected.
  ///
  /// In en, this message translates to:
  /// **'Make sure you are connected to the internet'**
  String get makeSureInternetConnected;

  /// No description provided for @dontClosePage.
  ///
  /// In en, this message translates to:
  /// **'Don\'t close this page until sync is complete'**
  String get dontClosePage;

  /// No description provided for @searchForClient.
  ///
  /// In en, this message translates to:
  /// **'Search for client...'**
  String get searchForClient;

  /// No description provided for @sessionEnded.
  ///
  /// In en, this message translates to:
  /// **'Session ended'**
  String get sessionEnded;

  /// No description provided for @endSession.
  ///
  /// In en, this message translates to:
  /// **'End Session'**
  String get endSession;

  /// No description provided for @endSessionConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to end the current session?'**
  String get endSessionConfirmation;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @customerCode.
  ///
  /// In en, this message translates to:
  /// **'Customer Code'**
  String get customerCode;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @distanceWithValue.
  ///
  /// In en, this message translates to:
  /// **'{distance} km'**
  String distanceWithValue(String distance);

  /// No description provided for @distanceWithTime.
  ///
  /// In en, this message translates to:
  /// **'{distance} km (~{duration} min)'**
  String distanceWithTime(String distance, int duration);

  /// No description provided for @approximateDistance.
  ///
  /// In en, this message translates to:
  /// **'{distance} km (approximate)'**
  String approximateDistance(String distance);

  /// No description provided for @straightLineDistance.
  ///
  /// In en, this message translates to:
  /// **'{distance} km (straight line)'**
  String straightLineDistance(String distance);

  /// No description provided for @loadingDistance.
  ///
  /// In en, this message translates to:
  /// **'Calculating...'**
  String get loadingDistance;

  /// No description provided for @locationServicesRequired.
  ///
  /// In en, this message translates to:
  /// **'Location services are required to use the map'**
  String get locationServicesRequired;

  /// No description provided for @locationPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Location permission is required to show your location on the map'**
  String get locationPermissionRequired;

  /// No description provided for @getDirections.
  ///
  /// In en, this message translates to:
  /// **'Get Directions'**
  String get getDirections;

  /// No description provided for @startVisit.
  ///
  /// In en, this message translates to:
  /// **'Start Visit'**
  String get startVisit;

  /// No description provided for @cannotOpenGoogleMaps.
  ///
  /// In en, this message translates to:
  /// **'Cannot open Google Maps'**
  String get cannotOpenGoogleMaps;

  /// No description provided for @startSession.
  ///
  /// In en, this message translates to:
  /// **'Start Session'**
  String get startSession;

  /// No description provided for @noActiveSessionMessage.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have an active session. Would you like to start a new one?'**
  String get noActiveSessionMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @sessionDuration.
  ///
  /// In en, this message translates to:
  /// **'Session Duration'**
  String get sessionDuration;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'Months'**
  String get months;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'Years'**
  String get years;

  /// No description provided for @noLocationAvailable.
  ///
  /// In en, this message translates to:
  /// **'No location available for this customer'**
  String get noLocationAvailable;

  /// No description provided for @invalidCoordinates.
  ///
  /// In en, this message translates to:
  /// **'Invalid coordinates format'**
  String get invalidCoordinates;

  /// No description provided for @todayCustomers.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Customers'**
  String get todayCustomers;

  /// No description provided for @notExists.
  ///
  /// In en, this message translates to:
  /// **'Not exists'**
  String get notExists;

  /// No description provided for @visitRestriction.
  ///
  /// In en, this message translates to:
  /// **'Visit Restriction'**
  String get visitRestriction;

  /// No description provided for @alreadyVisitedToday.
  ///
  /// In en, this message translates to:
  /// **'You already visited this customer today. Please come back tomorrow.'**
  String get alreadyVisitedToday;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @todayCustomersTab.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Customers'**
  String get todayCustomersTab;

  /// No description provided for @customersTab.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customersTab;

  /// No description provided for @customerDetails.
  ///
  /// In en, this message translates to:
  /// **'Customer Details'**
  String get customerDetails;

  /// No description provided for @activities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get activities;

  /// No description provided for @createInvoice.
  ///
  /// In en, this message translates to:
  /// **'Create Invoice'**
  String get createInvoice;

  /// No description provided for @createNewInvoiceOrReturn.
  ///
  /// In en, this message translates to:
  /// **'Create a new invoice or return'**
  String get createNewInvoiceOrReturn;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @captureAndSavePhoto.
  ///
  /// In en, this message translates to:
  /// **'Capture and save photos'**
  String get captureAndSavePhoto;

  /// No description provided for @receiptVoucher.
  ///
  /// In en, this message translates to:
  /// **'Receipt Voucher'**
  String get receiptVoucher;

  /// No description provided for @createReceiptVoucher.
  ///
  /// In en, this message translates to:
  /// **'Create a receipt voucher'**
  String get createReceiptVoucher;

  /// No description provided for @noExist.
  ///
  /// In en, this message translates to:
  /// **'Not Available'**
  String get noExist;

  /// No description provided for @startCustomerVisit.
  ///
  /// In en, this message translates to:
  /// **'Start Customer Visit'**
  String get startCustomerVisit;

  /// No description provided for @receiptDetails.
  ///
  /// In en, this message translates to:
  /// **'Receipt Details'**
  String get receiptDetails;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @pleaseEnterAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter an amount'**
  String get pleaseEnterAmount;

  /// No description provided for @pleaseEnterValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get pleaseEnterValidNumber;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @pleaseSelectPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Please select a payment method'**
  String get pleaseSelectPaymentMethod;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @saveReceiptVoucher.
  ///
  /// In en, this message translates to:
  /// **'Save Receipt Voucher'**
  String get saveReceiptVoucher;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @check.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get check;

  /// No description provided for @bankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get bankTransfer;

  /// No description provided for @creditCard.
  ///
  /// In en, this message translates to:
  /// **'Credit Card'**
  String get creditCard;

  /// No description provided for @masterCard.
  ///
  /// In en, this message translates to:
  /// **'Master Card'**
  String get masterCard;

  /// No description provided for @visitStartedAt.
  ///
  /// In en, this message translates to:
  /// **'Visit started at: {time}'**
  String visitStartedAt(String time);

  /// No description provided for @visitSessionInfo.
  ///
  /// In en, this message translates to:
  /// **'You can perform multiple activities during this visit session. The session will end only when you click \"End Visit Session\" button.'**
  String get visitSessionInfo;

  /// No description provided for @endVisitSession.
  ///
  /// In en, this message translates to:
  /// **'End Visit Session'**
  String get endVisitSession;

  /// No description provided for @visitSessionEnded.
  ///
  /// In en, this message translates to:
  /// **'Visit session ended'**
  String get visitSessionEnded;

  /// No description provided for @visitSessionStarted.
  ///
  /// In en, this message translates to:
  /// **'Visit session started successfully'**
  String get visitSessionStarted;

  /// No description provided for @activeVisitWith.
  ///
  /// In en, this message translates to:
  /// **'Active visit with {customerName}'**
  String activeVisitWith(String customerName);

  /// No description provided for @activeVisit.
  ///
  /// In en, this message translates to:
  /// **'Active Visit'**
  String get activeVisit;

  /// No description provided for @continueVisiting.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE'**
  String get continueVisiting;

  /// No description provided for @otherCustomerActiveVisit.
  ///
  /// In en, this message translates to:
  /// **'There is already an active visit for {customerName}. Please end that visit first.'**
  String otherCustomerActiveVisit(String customerName);

  /// No description provided for @invoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoice;

  /// No description provided for @subTotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subTotal;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @salesTax.
  ///
  /// In en, this message translates to:
  /// **'Sales Tax'**
  String get salesTax;

  /// No description provided for @grandTotal.
  ///
  /// In en, this message translates to:
  /// **'Grand Total'**
  String get grandTotal;

  /// No description provided for @returnItems.
  ///
  /// In en, this message translates to:
  /// **'Returns'**
  String get returnItems;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @netSubTotal.
  ///
  /// In en, this message translates to:
  /// **'Net Subtotal'**
  String get netSubTotal;

  /// No description provided for @netDiscount.
  ///
  /// In en, this message translates to:
  /// **'Net Discount'**
  String get netDiscount;

  /// No description provided for @netTotal.
  ///
  /// In en, this message translates to:
  /// **'Net Total'**
  String get netTotal;

  /// No description provided for @netSalesTax.
  ///
  /// In en, this message translates to:
  /// **'Net Sales Tax'**
  String get netSalesTax;

  /// No description provided for @netGrandTotal.
  ///
  /// In en, this message translates to:
  /// **'Net Grand Total'**
  String get netGrandTotal;

  /// No description provided for @addComment.
  ///
  /// In en, this message translates to:
  /// **'Add comment'**
  String get addComment;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItem;

  /// No description provided for @returnItem.
  ///
  /// In en, this message translates to:
  /// **'Return Item'**
  String get returnItem;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by code or description'**
  String get searchHint;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @saveItems.
  ///
  /// In en, this message translates to:
  /// **'Save Items'**
  String get saveItems;

  /// No description provided for @cancelItems.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelItems;

  /// No description provided for @noItemsFound.
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get noItemsFound;

  /// No description provided for @loadingItems.
  ///
  /// In en, this message translates to:
  /// **'Loading items...'**
  String get loadingItems;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get loadMore;

  /// No description provided for @itemsSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} items selected'**
  String itemsSelected(int count);

  /// No description provided for @invoiceItems.
  ///
  /// In en, this message translates to:
  /// **'Invoice Items'**
  String get invoiceItems;

  /// No description provided for @paymentType.
  ///
  /// In en, this message translates to:
  /// **'Payment Type'**
  String get paymentType;

  /// No description provided for @credit.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get credit;

  /// No description provided for @cheque.
  ///
  /// In en, this message translates to:
  /// **'Cheque'**
  String get cheque;

  /// No description provided for @invoiceDetails.
  ///
  /// In en, this message translates to:
  /// **'Invoice Details'**
  String get invoiceDetails;

  /// No description provided for @returnDetails.
  ///
  /// In en, this message translates to:
  /// **'Return Details'**
  String get returnDetails;

  /// No description provided for @invoiceSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Invoice saved successfully'**
  String get invoiceSavedSuccessfully;

  /// No description provided for @returnSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Return saved successfully'**
  String get returnSavedSuccessfully;

  /// No description provided for @invoiceDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Invoice deleted successfully'**
  String get invoiceDeletedSuccessfully;

  /// No description provided for @deleteInvoice.
  ///
  /// In en, this message translates to:
  /// **'Delete Invoice'**
  String get deleteInvoice;

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to delete the invoice'**
  String get deleteConfirmation;

  /// No description provided for @printInvoice.
  ///
  /// In en, this message translates to:
  /// **'Print Invoice'**
  String get printInvoice;

  /// No description provided for @returnInvoice.
  ///
  /// In en, this message translates to:
  /// **'Return Invoice'**
  String get returnInvoice;

  /// No description provided for @generatingPdf.
  ///
  /// In en, this message translates to:
  /// **'Generating PDF...'**
  String get generatingPdf;

  /// No description provided for @errorGeneratingPdf.
  ///
  /// In en, this message translates to:
  /// **'Error generating PDF'**
  String get errorGeneratingPdf;

  /// No description provided for @noPdfFileToShare.
  ///
  /// In en, this message translates to:
  /// **'No PDF file to share'**
  String get noPdfFileToShare;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @sharingInvoice.
  ///
  /// In en, this message translates to:
  /// **'Sharing Invoice'**
  String get sharingInvoice;

  /// No description provided for @sharingReturnInvoice.
  ///
  /// In en, this message translates to:
  /// **'Sharing Return'**
  String get sharingReturnInvoice;

  /// No description provided for @customerInformation.
  ///
  /// In en, this message translates to:
  /// **'Customer Information'**
  String get customerInformation;

  /// No description provided for @customerName.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customerName;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @unitPrice.
  ///
  /// In en, this message translates to:
  /// **'Unit Price'**
  String get unitPrice;

  /// No description provided for @itemCode.
  ///
  /// In en, this message translates to:
  /// **'Item Code'**
  String get itemCode;

  /// No description provided for @thankYouForYourBusiness.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your business!'**
  String get thankYouForYourBusiness;

  /// No description provided for @invoiceNumber.
  ///
  /// In en, this message translates to:
  /// **'Invoice #'**
  String get invoiceNumber;

  /// No description provided for @newInvoice.
  ///
  /// In en, this message translates to:
  /// **'New Invoice'**
  String get newInvoice;

  /// No description provided for @noInvoiceToDelete.
  ///
  /// In en, this message translates to:
  /// **'No invoice to delete'**
  String get noInvoiceToDelete;

  /// No description provided for @uploadingInvoice.
  ///
  /// In en, this message translates to:
  /// **'Uploading invoice...'**
  String get uploadingInvoice;

  /// No description provided for @userNotLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'User not logged in'**
  String get userNotLoggedIn;

  /// No description provided for @noItemsToUpload.
  ///
  /// In en, this message translates to:
  /// **'No items to upload'**
  String get noItemsToUpload;

  /// No description provided for @failedToGenerateInvoiceNumber.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate invoice number for return. Please try submitting first.'**
  String get failedToGenerateInvoiceNumber;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @invoiceUploadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Invoice uploaded successfully. Invoice #{number}'**
  String invoiceUploadedSuccessfully(String number);

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @errorUploadingInvoice.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorUploadingInvoice(String message);

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Tax {percentage}%: {amount}'**
  String tax(String percentage, String amount);

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'{amount} {symbol}'**
  String currency(String amount, String symbol);

  /// No description provided for @quantityTimesPrice.
  ///
  /// In en, this message translates to:
  /// **'{price} × {quantity}'**
  String quantityTimesPrice(String price, String quantity);

  /// No description provided for @customerNotFound.
  ///
  /// In en, this message translates to:
  /// **'Customer not found'**
  String get customerNotFound;

  /// No description provided for @noNumber.
  ///
  /// In en, this message translates to:
  /// **'no number'**
  String get noNumber;

  /// No description provided for @regular.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get regular;

  /// No description provided for @returnType.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get returnType;

  /// No description provided for @unsynchronizedInvoices.
  ///
  /// In en, this message translates to:
  /// **'Unsynchronized {type} invoices for this customer: {count}'**
  String unsynchronizedInvoices(String type, int count);

  /// No description provided for @usingMostRecentInvoice.
  ///
  /// In en, this message translates to:
  /// **'Using the most recent {type} invoice for this customer'**
  String usingMostRecentInvoice(String type);

  /// No description provided for @itemMissingFields.
  ///
  /// In en, this message translates to:
  /// **'Item missing required fields, skipping'**
  String get itemMissingFields;

  /// No description provided for @itemNotFound.
  ///
  /// In en, this message translates to:
  /// **'Item {code} not found in inventory, skipping'**
  String itemNotFound(String code);

  /// No description provided for @itemFound.
  ///
  /// In en, this message translates to:
  /// **'Item found in inventory: {description}'**
  String itemFound(String description);

  /// No description provided for @unitPriceFromDatabase.
  ///
  /// In en, this message translates to:
  /// **'Unit price from database: {price} (converted to: {converted})'**
  String unitPriceFromDatabase(String price, String converted);

  /// No description provided for @calculatedTotalPrice.
  ///
  /// In en, this message translates to:
  /// **'Calculated total price: {price}'**
  String calculatedTotalPrice(String price);

  /// No description provided for @addedToReturnItems.
  ///
  /// In en, this message translates to:
  /// **'Added to RETURN items: {code}, quantity: {quantity}'**
  String addedToReturnItems(String code, int quantity);

  /// No description provided for @addedToRegularItems.
  ///
  /// In en, this message translates to:
  /// **'Added to REGULAR items: {code}, quantity: {quantity}'**
  String addedToRegularItems(String code, int quantity);

  /// No description provided for @errorProcessingItem.
  ///
  /// In en, this message translates to:
  /// **'ERROR processing item: {error}'**
  String errorProcessingItem(String error);

  /// No description provided for @createdItemsSummary.
  ///
  /// In en, this message translates to:
  /// **'Created {regular} regular items and {returns} return items'**
  String createdItemsSummary(int regular, int returns);

  /// No description provided for @receiptVoucherSaved.
  ///
  /// In en, this message translates to:
  /// **'Receipt voucher saved successfully'**
  String get receiptVoucherSaved;

  /// No description provided for @errorSavingReceiptVoucher.
  ///
  /// In en, this message translates to:
  /// **'Error saving receipt voucher'**
  String get errorSavingReceiptVoucher;

  /// No description provided for @savingReceiptVoucher.
  ///
  /// In en, this message translates to:
  /// **'Saving voucher receipt'**
  String get savingReceiptVoucher;

  /// No description provided for @beforePicture.
  ///
  /// In en, this message translates to:
  /// **'Before Picture'**
  String get beforePicture;

  /// No description provided for @afterPicture.
  ///
  /// In en, this message translates to:
  /// **'After Picture'**
  String get afterPicture;

  /// No description provided for @cameraPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required to take photos'**
  String get cameraPermissionRequired;

  /// No description provided for @errorTakingPhoto.
  ///
  /// In en, this message translates to:
  /// **'Error taking photo. Please try again.'**
  String get errorTakingPhoto;

  /// No description provided for @tapToTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap to take photo'**
  String get tapToTakePhoto;

  /// No description provided for @takingPicture.
  ///
  /// In en, this message translates to:
  /// **'Taking Picture'**
  String get takingPicture;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirmation;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @companyLogo.
  ///
  /// In en, this message translates to:
  /// **'Company Logo'**
  String get companyLogo;

  /// No description provided for @tapToAddLogo.
  ///
  /// In en, this message translates to:
  /// **'Tap to add logo'**
  String get tapToAddLogo;

  /// No description provided for @logoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Logo updated successfully'**
  String get logoUpdated;

  /// No description provided for @errorUpdatingLogo.
  ///
  /// In en, this message translates to:
  /// **'Error updating logo'**
  String get errorUpdatingLogo;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully'**
  String get languageChanged;

  /// No description provided for @synced.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get synced;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get syncNow;

  /// No description provided for @vouchers.
  ///
  /// In en, this message translates to:
  /// **'Vouchers'**
  String get vouchers;

  /// No description provided for @salesData.
  ///
  /// In en, this message translates to:
  /// **'Sales Data'**
  String get salesData;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Message shown when syncing a specific item
  ///
  /// In en, this message translates to:
  /// **'Syncing {title}...'**
  String syncingItem(String title);

  /// Message shown when syncing all data
  ///
  /// In en, this message translates to:
  /// **'Syncing data...'**
  String get syncingData;

  /// Status of synced items
  ///
  /// In en, this message translates to:
  /// **'{synced} of {total} items synced'**
  String itemsSynced(int synced, int total);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
