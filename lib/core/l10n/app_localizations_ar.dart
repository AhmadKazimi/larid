// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get welcomeBack => 'مرحباً بك';

  @override
  String get signInToContinue => 'ادخل بيانات الدخول الخاصة بك';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get pleaseEnterEmail => 'الرجاء إدخال البريد الإلكتروني';

  @override
  String get pleaseEnterValidEmail => 'الرجاء إدخال بريد إلكتروني صحيح';

  @override
  String get pleaseEnterPassword => 'الرجاء إدخال كلمة المرور';

  @override
  String get passwordMustBe6Chars => 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';

  @override
  String get apiConfiguration => 'رابط الدومين الخاص بالعمل';

  @override
  String get enterApiBaseUrl => 'ادخل الرابط';

  @override
  String get baseUrl => 'الرابط';

  @override
  String get baseUrlHint => 'https://cloud.larid.net';

  @override
  String get pleaseEnterUrl => 'يرجى ادخال رابط دومين العمل';

  @override
  String get pleaseEnterValidUrl => 'الرجاء إدخال عنوان URL صحيح يبدأ بـ http:// أو https://';

  @override
  String get saveAndContinue => 'حفظ ومتابعة';

  @override
  String get home => 'الرئيسية';

  @override
  String get welcomeToLarid => 'مرحباً بك في نظام ليرد';

  @override
  String get goToLogin => 'الذهاب لتسجيل الدخول';

  @override
  String get workspace => 'مساحة العمل';

  @override
  String get pleaseEnterWorkspace => 'الرجاء إدخال مساحة العمل';

  @override
  String get userId => 'اسم المستخدم';

  @override
  String get pleaseEnterUserId => 'الرجاء إدخال اسم المستخدم';

  @override
  String get sync => 'مزامنة';

  @override
  String get syncStatus => 'حالة المزامنة';

  @override
  String get customers => 'قائمة عملاء المندوب';

  @override
  String get salesRepCustomers => 'قائمة عملاء زيارات اليوم';

  @override
  String get prices => 'قائمة الاسعار';

  @override
  String get inventoryItems => 'قائمة اصناف المخزون';

  @override
  String get inventoryUnits => 'قائمة وحدات المخزون';

  @override
  String get salesTaxes => 'ضرائب المبيعات';

  @override
  String get warehouse => 'المستودع';

  @override
  String get companyInfo => 'بيانات الشركة';

  @override
  String get syncAllData => 'مزامنة جميع البيانات';

  @override
  String recordsSynced(int count) {
    return 'تمت مزامنة $count سجل';
  }

  @override
  String get start => 'بدء';

  @override
  String get syncError => 'خطأ في المزامنة';

  @override
  String get syncSuccess => 'تمت المزامنة بنجاح';

  @override
  String get syncInProgress => 'جاري المزامنة';

  @override
  String get syncComplete => 'اكتملت المزامنة';

  @override
  String get syncFailed => 'فشلت المزامنة';

  @override
  String get retrySync => 'إعادة محاولة المزامنة';

  @override
  String syncProgress(int progress) {
    return '$progress%';
  }

  @override
  String get makeSureInternetConnected => 'تأكد من اتصالك بالإنترنت';

  @override
  String get dontClosePage => 'لا تغلق هذه الصفحة حتى تكتمل المزامنة';

  @override
  String get searchForClient => 'البحث عن عميل';

  @override
  String get sessionEnded => 'تم إنهاء الزيارة';

  @override
  String get endSession => 'إنهاء الزيارة';

  @override
  String get endSessionConfirmation => 'هل أنت متأكد من أنك تريد إنهاء الزيارة الحالية؟';

  @override
  String get end => 'إنهاء';

  @override
  String get map => 'الخريطة';

  @override
  String get customerCode => 'رمز العميل';

  @override
  String get address => 'العنوان';

  @override
  String get phone => 'الهاتف';

  @override
  String get distance => 'المسافة';

  @override
  String distanceWithValue(String distance) {
    return '$distance كم';
  }

  @override
  String distanceWithTime(String distance, int duration) {
    return '$distance كم (~$duration دقيقة)';
  }

  @override
  String approximateDistance(String distance) {
    return '$distance كم (تقريباً)';
  }

  @override
  String straightLineDistance(String distance) {
    return '$distance كم (خط مستقيم)';
  }

  @override
  String get loadingDistance => 'جاري الحساب...';

  @override
  String get locationServicesRequired => 'خدمات الموقع مطلوبة لاستخدام الخريطة';

  @override
  String get locationPermissionRequired => 'إذن الموقع مطلوب لعرض موقعك على الخريطة';

  @override
  String get getDirections => 'الحصول على الاتجاهات';

  @override
  String get startVisit => 'بدء زيارة';

  @override
  String get cannotOpenGoogleMaps => 'لا يمكن فتح خرائط جوجل';

  @override
  String get startSession => 'بدء زيارة جديدة ';

  @override
  String get noActiveSessionMessage => 'لا توجد زيارة  نشطة. هل تريد بدء زيارة جديدة؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get sessionDuration => 'مدة الزيارة';

  @override
  String get minutes => 'دقيقة';

  @override
  String get hours => 'ساعة';

  @override
  String get days => 'يوم';

  @override
  String get months => 'شهر';

  @override
  String get years => 'سنة';

  @override
  String get noLocationAvailable => 'لا يوجد موقع متاح لهذا العميل';

  @override
  String get invalidCoordinates => 'تنسيق إحداثيات غير صالح';

  @override
  String get todayCustomers => 'عملاء اليوم';

  @override
  String get notExists => 'غير موجود';

  @override
  String get visitRestriction => 'قيود الزيارة';

  @override
  String get alreadyVisitedToday => 'لقد قمت بزيارة هذا العميل اليوم. يرجى العودة غداً.';

  @override
  String get ok => 'موافق';

  @override
  String get todayCustomersTab => 'عملاء اليوم';

  @override
  String get customersTab => 'العملاء';

  @override
  String get customerDetails => 'تفاصيل العميل';

  @override
  String get activities => 'الانشطة المتاحة';

  @override
  String get createInvoice => 'إنشاء فاتورة';

  @override
  String get createNewInvoiceOrReturn => 'إنشاء فاتورة جديدة أو مرتجع';

  @override
  String get takePhoto => 'التقاط صورة';

  @override
  String get captureAndSavePhoto => 'التقاط وحفظ الصور';

  @override
  String get receiptVoucher => 'سند قبض';

  @override
  String get createReceiptVoucher => 'إنشاء سند قبض';

  @override
  String get noExist => 'غير متوفر';

  @override
  String get startCustomerVisit => 'بدء زيارة العميل';

  @override
  String get receiptDetails => 'تفاصيل سند القبض';

  @override
  String get amount => 'المبلغ';

  @override
  String get pleaseEnterAmount => 'الرجاء إدخال المبلغ';

  @override
  String get pleaseEnterValidNumber => 'الرجاء إدخال رقم صحيح';

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get pleaseSelectPaymentMethod => 'الرجاء اختيار طريقة الدفع';

  @override
  String get notes => 'ملاحظات';

  @override
  String get saveReceiptVoucher => 'حفظ سند القبض';

  @override
  String get cash => 'نقداً';

  @override
  String get check => 'شيك';

  @override
  String get bankTransfer => 'تحويل بنكي';

  @override
  String get creditCard => 'فيزا كارد';

  @override
  String get masterCard => 'ماستر كارد';

  @override
  String visitStartedAt(String time) {
    return 'بدأت الزيارة في: $time';
  }

  @override
  String get visitSessionInfo => 'يمكنك تنفيذ أنشطة متعددة خلال  الزيارة الحالية. ستنتهي الزيارة فقط عند النقر على زر \"إنهاء زيارة\".';

  @override
  String get endVisitSession => 'إنهاء  الزيارة';

  @override
  String get visitSessionEnded => 'تم إنهاء الزيارة';

  @override
  String get visitSessionStarted => 'تم بدء الزيارة بنجاح';

  @override
  String activeVisitWith(String customerName) {
    return 'زيارة نشطة مع $customerName';
  }

  @override
  String get activeVisit => 'زيارة نشطة';

  @override
  String get continueVisiting => 'متابعة';

  @override
  String otherCustomerActiveVisit(String customerName) {
    return 'هناك بالفعل زيارة نشطة لـ $customerName. يرجى إنهاء تلك الزيارة أولاً.';
  }

  @override
  String get invoice => 'الفاتورة';

  @override
  String get subTotal => 'الأجمالي بدون ضريبة';

  @override
  String get discount => 'الخصم';

  @override
  String get total => 'اجمالي ';

  @override
  String get salesTax => 'اجمالي الضريبة';

  @override
  String get grandTotal => 'الأجمالي';

  @override
  String get returnItems => 'المرتجعات';

  @override
  String get summary => 'ملخص';

  @override
  String get netSubTotal => 'صافي المجموع الفرعي';

  @override
  String get netDiscount => 'صافي الخصم';

  @override
  String get netTotal => 'صافي المجموع';

  @override
  String get netSalesTax => 'صافي ضريبة المبيعات';

  @override
  String get netGrandTotal => 'صافي الأجمالي';

  @override
  String get addComment => 'إضافة ملاحظات';

  @override
  String get submit => 'حفظ';

  @override
  String get print => 'طباعة';

  @override
  String get addItem => 'إضافة مادة';

  @override
  String get returnItem => 'إنشاء مرتجع';

  @override
  String get items => 'المواد';

  @override
  String get search => 'بحث';

  @override
  String get searchHint => 'البحث بالرمز أو الوصف';

  @override
  String get quantity => 'الكمية';

  @override
  String get price => 'السعر';

  @override
  String get saveItems => 'اضافة المواد';

  @override
  String get cancelItems => 'إلغاء';

  @override
  String get noItemsFound => 'لم يتم العثور على مواد';

  @override
  String get loadingItems => 'جاري تحميل المواد...';

  @override
  String get loadMore => 'تحميل المزيد';

  @override
  String itemsSelected(int count) {
    return 'تم اختيار $count مادة';
  }

  @override
  String get invoiceItems => 'مواد الفاتورة';

  @override
  String get paymentType => 'طريقة الدفع';

  @override
  String get credit => 'ائتمان';

  @override
  String get cheque => 'شيك';

  @override
  String get invoiceDetails => 'تفاصيل الفاتورة';

  @override
  String get returnDetails => 'تفاصيل المرتجع';

  @override
  String get invoiceSavedSuccessfully => 'تم حفظ الفاتورة بنجاح';

  @override
  String get returnSavedSuccessfully => 'تم حفظ المرتجع بنجاح';

  @override
  String get invoiceDeletedSuccessfully => 'تم حذف الفاتورة بنجاح';

  @override
  String get deleteInvoice => 'حذف الفاتورة';

  @override
  String get deleteConfirmation => 'هل أنت متأكد من حذف الفاتورة';

  @override
  String get printInvoice => 'طباعة الفاتورة';

  @override
  String get returnInvoice => 'فاتورة المرتجعات';

  @override
  String get generatingPdf => 'جاري إنشاء ملف PDF...';

  @override
  String get errorGeneratingPdf => 'خطأ في إنشاء ملف PDF';

  @override
  String get noPdfFileToShare => 'لا يوجد ملف PDF للمشاركة';

  @override
  String get share => 'مشاركة';

  @override
  String get sharingInvoice => 'مشاركة الفاتورة';

  @override
  String get sharingReturnInvoice => 'مشاركة فاتورة المرتجعات';

  @override
  String get customerInformation => 'معلومات العميل';

  @override
  String get customerName => 'اسم العميل';

  @override
  String get date => 'التاريخ';

  @override
  String get time => 'الوقت';

  @override
  String get comment => 'ملاحظات';

  @override
  String get description => 'الوصف';

  @override
  String get unitPrice => 'سعر الوحدة';

  @override
  String get itemCode => 'رمز المنتج';

  @override
  String get thankYouForYourBusiness => 'شكراً لتعاملكم معنا!';

  @override
  String get invoiceNumber => 'رقم الفاتورة';

  @override
  String get newInvoice => 'فاتورة جديدة';

  @override
  String get noInvoiceToDelete => 'لا توجد فاتورة للحذف';

  @override
  String get uploadingInvoice => 'جاري ترحيل الفاتورة...';

  @override
  String get savingInvoice => 'جاري حفظ الفاتورة...';

  @override
  String get userNotLoggedIn => 'المستخدم غير مسجل الدخول';

  @override
  String get noItemsToUpload => 'لا توجد مواد للرفع';

  @override
  String get failedToGenerateInvoiceNumber => 'فشل في إنشاء رقم الفاتورة للمرتجع. يرجى المحاولة مرة أخرى.';

  @override
  String get success => 'نجاح';

  @override
  String invoiceUploadedSuccessfully(String number) {
    return 'تم ترحيل الفاتورة بنجاح. رقم الفاتورة #$number';
  }

  @override
  String get error => 'خطأ';

  @override
  String errorUploadingInvoice(String message) {
    return 'خطأ: $message';
  }

  @override
  String tax(String percentage, String amount) {
    return 'ضريبة $percentage%: $amount';
  }

  @override
  String currency(String amount, String symbol) {
    return '$amount';
  }

  @override
  String quantityTimesPrice(String price, String quantity) {
    return '$price × $quantity';
  }

  @override
  String get customerNotFound => 'العميل غير موجود';

  @override
  String get noNumber => 'لا يوجد رقم';

  @override
  String get regular => 'عادي';

  @override
  String get returnType => 'مرتجع';

  @override
  String unsynchronizedInvoices(String type, int count) {
    return 'فواتير $type غير متزامنة لهذا العميل: $count';
  }

  @override
  String usingMostRecentInvoice(String type) {
    return 'استخدام أحدث فاتورة $type لهذا العميل';
  }

  @override
  String get itemMissingFields => 'المادة يفتقد إلى الحقول المطلوبة، يتم تخطيه';

  @override
  String itemNotFound(String code) {
    return 'المادة $code غير موجود في المخزون، يتم تخطيه';
  }

  @override
  String itemFound(String description) {
    return 'تم العثور على مواد في المخزون: $description';
  }

  @override
  String unitPriceFromDatabase(String price, String converted) {
    return 'سعر الوحدة من قاعدة البيانات: $price (تم تحويله إلى: $converted)';
  }

  @override
  String calculatedTotalPrice(String price) {
    return 'إجمالي السعر المحسوب: $price';
  }

  @override
  String addedToReturnItems(String code, int quantity) {
    return 'تمت إضافة مواد إلى المرتجعات: $code, الكمية: $quantity';
  }

  @override
  String addedToRegularItems(String code, int quantity) {
    return 'تمت إضافة مواد إلى الفاتورة العادية: $code, الكمية: $quantity';
  }

  @override
  String errorProcessingItem(String error) {
    return 'خطأ في معالجة المادة: $error';
  }

  @override
  String createdItemsSummary(int regular, int returns) {
    return 'تم إنشاء $regular مادة عادي و $returns مادة المرتجع';
  }

  @override
  String get receiptVoucherSaved => 'تم حفظ سند القبض بنجاح';

  @override
  String get errorSavingReceiptVoucher => 'خطأ في حفظ سند القبض';

  @override
  String get savingReceiptVoucher => 'جاري حفظ سند القبض';

  @override
  String get beforePicture => 'الصورة قبل';

  @override
  String get afterPicture => 'الصورة بعد';

  @override
  String get cameraPermissionRequired => 'إذن الكاميرا مطلوب لالتقاط الصور';

  @override
  String get errorTakingPhoto => 'خطأ في التقاط الصورة. يرجى المحاولة مرة أخرى.';

  @override
  String get tapToTakePhoto => 'انقر لالتقاط صورة';

  @override
  String get takingPicture => 'التقاط صورة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutConfirmation => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get yes => 'نعم';

  @override
  String get companyLogo => 'شعار الشركة';

  @override
  String get tapToAddLogo => 'انقر لإضافة شعار';

  @override
  String get logoUpdated => 'تم تحديث الشعار بنجاح';

  @override
  String get errorUpdatingLogo => 'خطأ في تحديث الشعار';

  @override
  String get language => 'اللغة';

  @override
  String get languageChanged => 'تم تغيير اللغة بنجاح';

  @override
  String get logoutError => 'Failed to logout. Please try again.';

  @override
  String get synced => 'تمت المزامنة';

  @override
  String get syncNow => 'مزامنة';

  @override
  String get vouchers => 'سندات القبض';

  @override
  String get salesData => 'بيانات المبيعات';

  @override
  String get today => 'اليوم';

  @override
  String syncingItem(String title) {
    return 'جاري مزامنة $title...';
  }

  @override
  String get syncingData => 'جاري مزامنة البيانات...';

  @override
  String itemsSynced(int synced, int total) {
    return 'تمت مزامنة $synced من $total عنصر';
  }

  @override
  String get dateFormat => 'Date Format: dd/MM/yyyy HH:mm';

  @override
  String formattedDate(String day, String month, String year, String hour, String minute) {
    return '$day/$month/$year $hour:$minute';
  }
}
