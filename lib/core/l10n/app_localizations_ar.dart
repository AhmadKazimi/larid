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
}
