// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get loading => 'جارٍ التحميل';

  @override
  String get error => 'خطأ';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get organizations => 'المؤسسات';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get forbidden => 'ليست لديك صلاحية الوصول إلى هذا.';

  @override
  String get failureNetwork => 'تعذر الاتصال. تحقق من الشبكة ثم أعد المحاولة.';

  @override
  String get failureUnauthorized => 'انتهت الجلسة. سجّل الدخول مرة أخرى.';

  @override
  String get failureForbidden => 'ليست لديك صلاحية لتنفيذ هذا الإجراء.';

  @override
  String get failureValidation => 'بعض الحقول غير صالحة.';

  @override
  String get failureNotFound => 'تعذر العثور على العنصر المطلوب.';

  @override
  String get failureConflict => 'يتعارض هذا مع البيانات الحالية.';

  @override
  String get failureServer => 'حدث خطأ في الخادم. حاول مرة أخرى لاحقًا.';

  @override
  String get failureParsing => 'تعذر قراءة الاستجابة.';

  @override
  String get failureUnknown => 'حدث خطأ غير متوقع.';
}
