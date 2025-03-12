// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get signInToContinue => 'سجل دخول للمتابعة';

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
  String get apiConfiguration => 'إعدادات API';

  @override
  String get enterApiBaseUrl => 'أدخل عنوان API الأساسي';

  @override
  String get baseUrl => 'العنوان الأساسي';

  @override
  String get baseUrlHint => 'https://api.example.com';

  @override
  String get pleaseEnterUrl => 'الرجاء إدخال عنوان URL';

  @override
  String get pleaseEnterValidUrl => 'الرجاء إدخال عنوان URL صحيح يبدأ بـ http:// أو https://';

  @override
  String get saveAndContinue => 'حفظ ومتابعة';

  @override
  String get home => 'الرئيسية';

  @override
  String get welcomeToLarid => 'مرحباً بك في لاريد';

  @override
  String get goToLogin => 'الذهاب لتسجيل الدخول';

  @override
  String get workspace => 'مساحة العمل';

  @override
  String get pleaseEnterWorkspace => 'الرجاء إدخال مساحة العمل';

  @override
  String get userId => 'معرف المستخدم';

  @override
  String get pleaseEnterUserId => 'الرجاء إدخال معرف المستخدم';

  @override
  String get sync => 'مزامنة';

  @override
  String get syncStatus => 'حالة المزامنة';

  @override
  String get customers => 'العملاء';

  @override
  String get salesRepCustomers => 'عملاء مندوب المبيعات';

  @override
  String get prices => 'الأسعار';

  @override
  String get inventoryItems => 'عناصر المخزون';

  @override
  String get inventoryUnits => 'وحدات المخزون';

  @override
  String get salesTaxes => 'ضرائب المبيعات';

  @override
  String get syncAllData => 'مزامنة جميع البيانات';

  @override
  String recordsSynced(Object count) {
    return 'تمت مزامنة $count سجل';
  }

  @override
  String get start => 'بدء';

  @override
  String get makeSureInternetConnected => 'تأكد من اتصالك بالإنترنت';

  @override
  String get dontClosePage => 'لا تغلق هذه الصفحة حتى تكتمل المزامنة';

  @override
  String get searchForClient => 'البحث عن عميل';

  @override
  String get sessionEnded => 'تم إنهاء الجلسة';

  @override
  String get endSession => 'إنهاء الجلسة';

  @override
  String get endSessionConfirmation => 'هل أنت متأكد من أنك تريد إنهاء الجلسة الحالية؟';

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
  String get startSession => 'بدء جلسة عمل';

  @override
  String get noActiveSessionMessage => 'لا توجد جلسة عمل نشطة. هل تريد بدء جلسة جديدة؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get sessionDuration => 'مدة الجلسة';

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
  String get activities => 'الأنشطة';

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
  String visitStartedAt(String time) {
    return 'بدأت الزيارة في: $time';
  }

  @override
  String get visitSessionInfo => 'يمكنك تنفيذ أنشطة متعددة خلال جلسة الزيارة هذه. ستنتهي الجلسة فقط عند النقر على زر \"إنهاء جلسة الزيارة\".';

  @override
  String get endVisitSession => 'إنهاء جلسة الزيارة';

  @override
  String get visitSessionEnded => 'تم إنهاء جلسة الزيارة';

  @override
  String get visitSessionStarted => 'تم بدء جلسة الزيارة بنجاح';

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
  String get total => 'اجمالي الضريبة';

  @override
  String get salesTax => 'اجمالي الضريبة';

  @override
  String get grandTotal => 'الأجمالي';

  @override
  String get returnItems => 'المرتجعات';

  @override
  String get summary => 'الملخص';

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
  String get addComment => 'إضافة تعليق';

  @override
  String get submit => 'حفظ';

  @override
  String get print => 'طباعة';

  @override
  String get addItem => 'إضافة عنصر';

  @override
  String get returnItem => 'إرجاع عنصر';

  @override
  String get items => 'العناصر';

  @override
  String get search => 'بحث';

  @override
  String get searchHint => 'البحث بالرمز أو الوصف';

  @override
  String get quantity => 'الكمية';

  @override
  String get price => 'السعر';

  @override
  String get saveItems => 'حفظ العناصر';

  @override
  String get cancelItems => 'إلغاء';

  @override
  String get noItemsFound => 'لم يتم العثور على عناصر';

  @override
  String get loadingItems => 'جاري تحميل العناصر...';

  @override
  String get loadMore => 'تحميل المزيد';

  @override
  String itemsSelected(int count) {
    return 'تم اختيار $count عنصر';
  }

  @override
  String get invoiceItems => 'عناصر الفاتورة';

  @override
  String get paymentType => 'طريقة الدفع';

  @override
  String get cash => 'نقداً';

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
}
