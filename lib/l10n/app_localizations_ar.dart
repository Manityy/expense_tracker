// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'فلوسي';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navExpenses => 'المصاريف';

  @override
  String get navAnalytics => 'التحليلات';

  @override
  String get navSubscriptions => 'الاشتراكات';

  @override
  String get navProfile => 'الملف';

  @override
  String welcomeGreeting(String name) {
    return 'أهلا، $name';
  }

  @override
  String get welcomeSubtitle => 'فلوسك في يدك';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get appearance => 'المظهر';

  @override
  String get darkMode => 'الوضع الليلي';

  @override
  String get language => 'اللغة';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageArabic => 'العربية';

  @override
  String get themeSystem => 'حسب النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get monthlyIncome => 'الدخل الشهري';

  @override
  String get remainingThisMonth => 'الباقي هذا الشهر';

  @override
  String get spentThisMonth => 'المصروف هذا الشهر';

  @override
  String get accountSettings => 'الحساب';

  @override
  String get achievements => 'الإنجازات';

  @override
  String get logOut => 'تسجيل الخروج';

  @override
  String get logOutConfirmTitle => 'تسجيل الخروج؟';

  @override
  String get logOutConfirmMessage =>
      'يجب تسجيل الدخول مجدداً للوصول إلى بياناتك.';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get save => 'حفظ';

  @override
  String get change => 'تغيير';

  @override
  String get all => 'الكل';

  @override
  String get unableToLoadProfile => 'تعذّر تحميل الملف';

  @override
  String get userNotFound => 'لم يتم العثور على المستخدم';

  @override
  String get profileNotFound => 'الملف غير موجود';

  @override
  String get updateSalary => 'تحديث الراتب';

  @override
  String get manageMonthlyIncome => 'إدارة دخلك الشهري';

  @override
  String get categoryBudgets => 'ميزانيات الفئات';

  @override
  String get categoryBudgetsSubtitle => 'تحديد حدود الإنفاق لكل فئة';

  @override
  String get exportExpenses => 'تصدير المصاريف';

  @override
  String get exportExpensesSubtitle => 'تحميل CSV لجميع مصاريفك';

  @override
  String get noExpensesToExport => 'لا توجد مصاريف للتصدير';

  @override
  String get savingsGoal => 'هدف الادّخار';

  @override
  String savingsGoalSet(String amount) {
    return 'الهدف: $amount د.ت';
  }

  @override
  String get savingsGoalUnset => 'حدّد هدف ادّخار';

  @override
  String get myChallenges => 'تحدّياتي';

  @override
  String challengesCompleted(int count) {
    return '$count مكتملة';
  }

  @override
  String get challengesEmpty => 'أكمل التحديات لكسب الشارات';

  @override
  String get recentTransactions => 'آخر المعاملات';

  @override
  String get noExpensesYet => 'لا مصاريف بعد. اضغط + للإضافة.';

  @override
  String get noExpensesYetShort => 'لا مصاريف بعد';

  @override
  String get noExpensesYetSubtitle => 'تابع مصاريفك بإضافة أول مصروف.';

  @override
  String get endOfMonthForecast => 'توقعات نهاية الشهر';

  @override
  String get savingsGoalTitle => 'هدف الادّخار';

  @override
  String get goal => 'الهدف';

  @override
  String get current => 'الحالي';

  @override
  String get goalAchieved => 'تم تحقيق الهدف!';

  @override
  String get keepSaving => 'واصل الادّخار!';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get welcomeBack => 'أهلا بيك';

  @override
  String get signInSubtitle => 'فلوسي — سجّل الدخول لمتابعة مصاريفك';

  @override
  String get joinFlousi => 'انضم إلى فلوسي';

  @override
  String get registerSubtitle => 'فلوسي — ابدأ التتبع بالدينار';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get sendLink => 'إرسال الرابط';

  @override
  String get passwordResetSent =>
      'تم إرسال بريد إعادة التعيين. تحقق من صندوق الوارد.';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get myExpenses => 'مصاريفي';

  @override
  String get addExpense => 'إضافة مصروف';

  @override
  String get editExpense => 'تعديل المصروف';

  @override
  String get deleteExpense => 'حذف المصروف';

  @override
  String get deleteExpenseConfirm => 'هل تريد حذف هذا المصروف؟';

  @override
  String get searchExpenses => 'البحث في المصاريف...';

  @override
  String errorLoadingExpenses(String error) {
    return 'خطأ في التحميل: $error';
  }

  @override
  String get analytics => 'التحليلات';

  @override
  String get unableToLoadAnalytics => 'تعذّر تحميل التحليلات';

  @override
  String get analyticsEmptySubtitle => 'ابدأ التتبع لفتح التحليلات.';

  @override
  String noExpensesInMonth(String month) {
    return 'لا مصاريف في $month';
  }

  @override
  String get pickAnotherMonth => 'اختر شهراً آخر أو أضف مصروفاً.';

  @override
  String get spent => 'المصروف';

  @override
  String get remaining => 'الباقي';

  @override
  String get ofIncome => 'من الدخل';

  @override
  String get transactions => 'المعاملات';

  @override
  String get byCategory => 'حسب الفئة';

  @override
  String percentOfSpending(String percent) {
    return '$percent% من الإنفاق';
  }

  @override
  String get sixMonthSpending => 'إنفاق 6 أشهر';

  @override
  String get fullMonthlyHistory => 'السجل الشهري الكامل';

  @override
  String get fullMonthlyHistorySubtitle => 'الاتجاهات والمتوسطات والمقارنة';

  @override
  String get monthlyTrend => 'الاتجاه الشهري';

  @override
  String get noSpendingHistory => 'لا سجل إنفاق بعد';

  @override
  String get noSpendingHistorySubtitle => 'أضف مصاريف لرؤية اتجاهاتك الشهرية.';

  @override
  String get vsLastMonth => 'مقارنة بالشهر الماضي';

  @override
  String get sixMonthAverage => 'متوسط 6 أشهر';

  @override
  String get allMonths => 'كل الأشهر';

  @override
  String vsPrevious(String change) {
    return '$change مقارنة بالسابق';
  }

  @override
  String get subscriptions => 'الاشتراكات';

  @override
  String get addSubscription => 'إضافة اشتراك';

  @override
  String get editSubscription => 'تعديل الاشتراك';

  @override
  String get deleteSubscription => 'حذف الاشتراك';

  @override
  String get deleteSubscriptionConfirm => 'هل تريد حذف هذا الاشتراك؟';

  @override
  String errorLoadingSubscriptions(String error) {
    return 'خطأ في التحميل: $error';
  }

  @override
  String get subscriptionNameHint => 'مثال: Netflix، كراء، إنترنت';

  @override
  String get fillAllFields => 'يرجى ملء جميع الحقول';

  @override
  String get validAmountRequired => 'يرجى إدخال مبلغ صحيح';

  @override
  String dayOfMonth(int day) {
    return 'يوم $day';
  }

  @override
  String get amount => 'المبلغ';

  @override
  String get title => 'العنوان';

  @override
  String get category => 'الفئة';

  @override
  String get date => 'التاريخ';

  @override
  String get expenseTitleHint => 'مثال: مشتريات Carrefour';

  @override
  String get takePhoto => 'التقاط صورة';

  @override
  String get chooseFromGallery => 'اختيار من المعرض';

  @override
  String get receiptPhoto => 'صورة الوصل';

  @override
  String get flousiCategorizing => 'فلوسي يصنّف...';

  @override
  String get salary => 'الراتب';

  @override
  String get saveSalary => 'حفظ الراتب';

  @override
  String get salarySaved => 'تم حفظ الراتب';

  @override
  String get setYourSalary => 'تحديد راتبك';

  @override
  String get saveGoal => 'حفظ الهدف';

  @override
  String get noLimit => 'بدون حد';

  @override
  String get budgetsSaved => 'تم حفظ الميزانيات بنجاح!';

  @override
  String errorLoadingBudgets(String error) {
    return 'خطأ في التحميل: $error';
  }

  @override
  String errorSavingBudgets(String error) {
    return 'خطأ في الحفظ: $error';
  }

  @override
  String get savingsChallenges => 'تحديات الادّخار';

  @override
  String get categoryBudgetsTitle => 'ميزانيات الفئات';

  @override
  String get noCategoryBudgets =>
      'لا ميزانيات محددة. اضبط الحدود من الملف الشخصي!';

  @override
  String get setupCategoryBudgets => 'إعداد الميزانيات';

  @override
  String budgetExceededBy(String amount) {
    return 'تجاوز بـ $amount د.ت!';
  }

  @override
  String get budgetEightyPercent => '80%+ مُنفَق';

  @override
  String get flousiAiAssistant => 'مساعد فلوسي AI';

  @override
  String get flousiAiSubtitle =>
      'تحتاج مساعدة؟ اسأل فلوسي AI لنصائح مالية شخصية.';

  @override
  String get chatWithAi => 'محادثة مع AI';

  @override
  String get askFlousi => 'اسأل فلوسي...';

  @override
  String get flousiThinking => 'فلوسي يفكّر...';

  @override
  String get deleteChat => 'حذف المحادثة';

  @override
  String deleteChatConfirm(String title) {
    return 'حذف \"$title\"؟ لا يمكن التراجع.';
  }

  @override
  String get deletingChat => 'جاري الحذف...';

  @override
  String get aiConversationsEmpty =>
      'اسأل فلوسي AI عن نصائح الادّخار وتحليل مصاريفك!';

  @override
  String get usageExceeded => 'تحذير: تجاوزت دخلك الشهري';

  @override
  String usagePercent(String percent) {
    return 'استخدمت $percent% من دخلك الشهري';
  }

  @override
  String forecastOnPace(String amount, int days) {
    return 'على هذا المعدل: ~$amount د.ت متبقية ($days أيام)';
  }

  @override
  String forecastOverspend(String amount) {
    return 'على هذا المعدل: تجاوز ~$amount د.ت';
  }

  @override
  String dailyAverage(String amount) {
    return 'المتوسط اليومي: $amount د.ت';
  }

  @override
  String onboardingWelcome(String name) {
    return 'أهلا في فلوسي، $name!';
  }

  @override
  String get onboardingTagline => 'فلوسي — barra flousk';

  @override
  String get onboardingIntro =>
      'لنضبط ملفك في 3 خطوات لتفعيل لوحة التحكم والميزانيات والرؤى.';

  @override
  String get continueBtn => 'متابعة';

  @override
  String get finishSetup => 'إنهاء الإعداد';

  @override
  String get skipBudgetSetup => 'تخطي الميزانيات الآن';

  @override
  String get validIncomeRequired => 'يرجى إدخال دخل شهري صحيح';

  @override
  String get monthlyIncomeSetup => 'الدخل الشهري';

  @override
  String get monthlyIncomeSetupHint =>
      'يساعد فلوسي على حساب ما يتبقى لك كل شهر.';

  @override
  String get savingsGoalSetup => 'هدف الادّخار';

  @override
  String get savingsGoalSetupHint => 'اختياري — تابع تقدمك في الصفحة الرئيسية.';

  @override
  String get monthlySavingsTarget => 'هدف ادّخار شهري';

  @override
  String get catRent => 'الكراء';

  @override
  String get catBills => 'الفواتير';

  @override
  String get catFood => 'المأكول';

  @override
  String get catGroceries => 'البقالة';

  @override
  String get catTransport => 'النقل';

  @override
  String get catEntertainment => 'الترفيه';

  @override
  String get catHealthcare => 'الصحة';

  @override
  String get catEducation => 'التعليم';

  @override
  String get catShopping => 'التسوق';

  @override
  String get catSavings => 'الادّخار';

  @override
  String get catOther => 'أخرى';

  @override
  String insightBudgetExceededTitle(String category) {
    return 'تجاوز ميزانية $category';
  }

  @override
  String insightBudgetExceededMsg(String spent, String limit, String category) {
    return 'أنفقت $spent د.ت من $limit د.ت لـ $category. حاول تقليل المصاريف غير الضرورية.';
  }

  @override
  String insightBudgetWarningTitle(String category, String percent) {
    return 'ميزانية $category عند $percent%';
  }

  @override
  String insightBudgetWarningMsg(String left, String category) {
    return 'تبقى فقط $left د.ت لميزانية $category هذا الشهر.';
  }

  @override
  String get insightHighPaceTitle => 'إيقاع إنفاق مرتفع';

  @override
  String insightHighPaceMsg(String daily, String over) {
    return 'بهذا المعدل (~$daily د.ت/يوم)، قد تنتهي الشهر بتجاوز $over د.ت.';
  }

  @override
  String insightTopCategoryTitle(String category) {
    return 'أعلى إنفاق: $category';
  }

  @override
  String insightTopCategoryMsg(String category, String amount, String percent) {
    return '$category أكبر فئة بـ $amount د.ت ($percent% من الإنفاق).';
  }

  @override
  String get insightFreshStartTitle => 'بداية جديدة هذا الشهر';

  @override
  String get insightFreshStartMsg =>
      'لا مصاريف مسجّلة. أضف أول مصروف لرؤى مخصصة.';

  @override
  String get insightOnTrackTitle => 'على المسار الصحيح';

  @override
  String insightOnTrackMsg(String amount) {
    return 'قد تنتهي بـ ~$amount د.ت متبقية بهذا الإيقاع.';
  }

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String get lastSixMonths => 'آخر 6 أشهر';

  @override
  String get noMatchingExpenses => 'لا مصاريف مطابقة';

  @override
  String expensesCount(int count) {
    return '$count مصروف';
  }

  @override
  String get expenseTitleLabel => 'عنوان المصروف';

  @override
  String get updateExpense => 'تحديث المصروف';

  @override
  String get saveExpense => 'حفظ المصروف';

  @override
  String get expenseUpdated => 'تم تحديث المصروف';

  @override
  String get expenseSaved => 'تم حفظ المصروف بنجاح';

  @override
  String get receiptAttached => 'تم إرفاق الوصل';

  @override
  String get attachReceiptPhoto => 'إرفاق صورة الوصل';

  @override
  String get subscriptionTitleLabel => 'الاشتراك / العنوان';

  @override
  String get dayOfMonthDue => 'يوم الاستحقاق';

  @override
  String get subscriptionUpdated => 'تم تحديث الاشتراك';

  @override
  String get subscriptionAdded => 'تمت إضافة الاشتراك بنجاح';

  @override
  String get updateSubscription => 'تحديث الاشتراك';

  @override
  String get noSubscriptionsYet => 'لا اشتراكات متكررة بعد';

  @override
  String get noSubscriptionsSubtitle =>
      'اضغط «إضافة اشتراك» لجدولة المدفوعات المتكررة.';

  @override
  String get dueToday => 'مستحق اليوم';

  @override
  String get dueTomorrow => 'مستحق غداً';

  @override
  String dueInDays(int days) {
    return 'مستحق خلال $days أيام';
  }

  @override
  String dayOfMonthDetail(int day) {
    return 'يوم $day من الشهر';
  }

  @override
  String deleteSubscriptionNamed(String title) {
    return 'إزالة الدفع المتكرر لـ \"$title\"؟';
  }

  @override
  String get newChat => 'محادثة جديدة';

  @override
  String get noChatsYet => 'لا محادثات بعد';
}
