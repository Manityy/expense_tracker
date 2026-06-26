import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Flousi'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get navExpenses;

  /// No description provided for @navAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get navAnalytics;

  /// No description provided for @navSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subs'**
  String get navSubscriptions;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @welcomeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Ahlan, {name}'**
  String welcomeGreeting(String name);

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Flousk fi yedek'**
  String get welcomeSubtitle;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @monthlyIncome.
  ///
  /// In en, this message translates to:
  /// **'Monthly Income'**
  String get monthlyIncome;

  /// No description provided for @remainingThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Remaining this month'**
  String get remainingThisMonth;

  /// No description provided for @spentThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Spent this month'**
  String get spentThisMonth;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSettings;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @logOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get logOutConfirmTitle;

  /// No description provided for @logOutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'You will need to sign in again to access your data.'**
  String get logOutConfirmMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @unableToLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Unable to load profile'**
  String get unableToLoadProfile;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User document not found'**
  String get userNotFound;

  /// No description provided for @profileNotFound.
  ///
  /// In en, this message translates to:
  /// **'Profile not found'**
  String get profileNotFound;

  /// No description provided for @updateSalary.
  ///
  /// In en, this message translates to:
  /// **'Update Salary'**
  String get updateSalary;

  /// No description provided for @manageMonthlyIncome.
  ///
  /// In en, this message translates to:
  /// **'Manage your monthly income'**
  String get manageMonthlyIncome;

  /// No description provided for @categoryBudgets.
  ///
  /// In en, this message translates to:
  /// **'Category Budgets'**
  String get categoryBudgets;

  /// No description provided for @categoryBudgetsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set spending limits per category'**
  String get categoryBudgetsSubtitle;

  /// No description provided for @exportExpenses.
  ///
  /// In en, this message translates to:
  /// **'Export Expenses'**
  String get exportExpenses;

  /// No description provided for @exportExpensesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Download CSV of all your expenses'**
  String get exportExpensesSubtitle;

  /// No description provided for @noExpensesToExport.
  ///
  /// In en, this message translates to:
  /// **'No expenses to export'**
  String get noExpensesToExport;

  /// No description provided for @savingsGoal.
  ///
  /// In en, this message translates to:
  /// **'Savings Goal'**
  String get savingsGoal;

  /// No description provided for @savingsGoalSet.
  ///
  /// In en, this message translates to:
  /// **'Goal: {amount} DT'**
  String savingsGoalSet(String amount);

  /// No description provided for @savingsGoalUnset.
  ///
  /// In en, this message translates to:
  /// **'Set a savings target'**
  String get savingsGoalUnset;

  /// No description provided for @myChallenges.
  ///
  /// In en, this message translates to:
  /// **'My Challenges'**
  String get myChallenges;

  /// No description provided for @challengesCompleted.
  ///
  /// In en, this message translates to:
  /// **'{count} completed'**
  String challengesCompleted(int count);

  /// No description provided for @challengesEmpty.
  ///
  /// In en, this message translates to:
  /// **'Complete challenges to earn badges'**
  String get challengesEmpty;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No description provided for @noExpensesYet.
  ///
  /// In en, this message translates to:
  /// **'No expenses yet. Tap + to add one.'**
  String get noExpensesYet;

  /// No description provided for @noExpensesYetShort.
  ///
  /// In en, this message translates to:
  /// **'No expenses yet'**
  String get noExpensesYetShort;

  /// No description provided for @noExpensesYetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track your spending by adding your first expense.'**
  String get noExpensesYetSubtitle;

  /// No description provided for @endOfMonthForecast.
  ///
  /// In en, this message translates to:
  /// **'End-of-month forecast'**
  String get endOfMonthForecast;

  /// No description provided for @savingsGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Savings Goal'**
  String get savingsGoalTitle;

  /// No description provided for @goal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goal;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @goalAchieved.
  ///
  /// In en, this message translates to:
  /// **'Goal achieved!'**
  String get goalAchieved;

  /// No description provided for @keepSaving.
  ///
  /// In en, this message translates to:
  /// **'Keep saving!'**
  String get keepSaving;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAccount;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Ahlan bik'**
  String get welcomeBack;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Flousi — Sign in to track your spending'**
  String get signInSubtitle;

  /// No description provided for @joinFlousi.
  ///
  /// In en, this message translates to:
  /// **'Join Flousi'**
  String get joinFlousi;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Flousi — Start tracking in DT'**
  String get registerSubtitle;

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

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @sendLink.
  ///
  /// In en, this message translates to:
  /// **'Send link'**
  String get sendLink;

  /// No description provided for @passwordResetSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent. Check your inbox.'**
  String get passwordResetSent;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @myExpenses.
  ///
  /// In en, this message translates to:
  /// **'My Expenses'**
  String get myExpenses;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpense;

  /// No description provided for @editExpense.
  ///
  /// In en, this message translates to:
  /// **'Edit Expense'**
  String get editExpense;

  /// No description provided for @deleteExpense.
  ///
  /// In en, this message translates to:
  /// **'Delete Expense'**
  String get deleteExpense;

  /// No description provided for @deleteExpenseConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this expense?'**
  String get deleteExpenseConfirm;

  /// No description provided for @searchExpenses.
  ///
  /// In en, this message translates to:
  /// **'Search expenses...'**
  String get searchExpenses;

  /// No description provided for @errorLoadingExpenses.
  ///
  /// In en, this message translates to:
  /// **'Error loading expenses: {error}'**
  String errorLoadingExpenses(String error);

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @unableToLoadAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Unable to load analytics'**
  String get unableToLoadAnalytics;

  /// No description provided for @analyticsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start tracking to unlock analytics.'**
  String get analyticsEmptySubtitle;

  /// No description provided for @noExpensesInMonth.
  ///
  /// In en, this message translates to:
  /// **'No expenses in {month}'**
  String noExpensesInMonth(String month);

  /// No description provided for @pickAnotherMonth.
  ///
  /// In en, this message translates to:
  /// **'Pick another month or add an expense.'**
  String get pickAnotherMonth;

  /// No description provided for @spent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get spent;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @ofIncome.
  ///
  /// In en, this message translates to:
  /// **'Of income'**
  String get ofIncome;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @byCategory.
  ///
  /// In en, this message translates to:
  /// **'By category'**
  String get byCategory;

  /// No description provided for @percentOfSpending.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of spending'**
  String percentOfSpending(String percent);

  /// No description provided for @sixMonthSpending.
  ///
  /// In en, this message translates to:
  /// **'6-month spending'**
  String get sixMonthSpending;

  /// No description provided for @fullMonthlyHistory.
  ///
  /// In en, this message translates to:
  /// **'Full monthly history'**
  String get fullMonthlyHistory;

  /// No description provided for @fullMonthlyHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Trends, averages & month-over-month'**
  String get fullMonthlyHistorySubtitle;

  /// No description provided for @monthlyTrend.
  ///
  /// In en, this message translates to:
  /// **'Monthly Trend'**
  String get monthlyTrend;

  /// No description provided for @noSpendingHistory.
  ///
  /// In en, this message translates to:
  /// **'No spending history yet'**
  String get noSpendingHistory;

  /// No description provided for @noSpendingHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add expenses to see your monthly trends here.'**
  String get noSpendingHistorySubtitle;

  /// No description provided for @vsLastMonth.
  ///
  /// In en, this message translates to:
  /// **'vs last month'**
  String get vsLastMonth;

  /// No description provided for @sixMonthAverage.
  ///
  /// In en, this message translates to:
  /// **'6-mo average'**
  String get sixMonthAverage;

  /// No description provided for @allMonths.
  ///
  /// In en, this message translates to:
  /// **'All months'**
  String get allMonths;

  /// No description provided for @vsPrevious.
  ///
  /// In en, this message translates to:
  /// **'{change} vs previous'**
  String vsPrevious(String change);

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions;

  /// No description provided for @addSubscription.
  ///
  /// In en, this message translates to:
  /// **'Add Subscription'**
  String get addSubscription;

  /// No description provided for @editSubscription.
  ///
  /// In en, this message translates to:
  /// **'Edit Subscription'**
  String get editSubscription;

  /// No description provided for @deleteSubscription.
  ///
  /// In en, this message translates to:
  /// **'Delete Subscription'**
  String get deleteSubscription;

  /// No description provided for @deleteSubscriptionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this subscription?'**
  String get deleteSubscriptionConfirm;

  /// No description provided for @errorLoadingSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Error loading subscriptions: {error}'**
  String errorLoadingSubscriptions(String error);

  /// No description provided for @subscriptionNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Netflix, Rent, Internet'**
  String get subscriptionNameHint;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields'**
  String get fillAllFields;

  /// No description provided for @validAmountRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get validAmountRequired;

  /// No description provided for @dayOfMonth.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String dayOfMonth(int day);

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @expenseTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Carrefour groceries'**
  String get expenseTitleHint;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @receiptPhoto.
  ///
  /// In en, this message translates to:
  /// **'Receipt photo'**
  String get receiptPhoto;

  /// No description provided for @flousiCategorizing.
  ///
  /// In en, this message translates to:
  /// **'Flousi is categorizing...'**
  String get flousiCategorizing;

  /// No description provided for @salary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get salary;

  /// No description provided for @saveSalary.
  ///
  /// In en, this message translates to:
  /// **'Save Salary'**
  String get saveSalary;

  /// No description provided for @salarySaved.
  ///
  /// In en, this message translates to:
  /// **'Salary saved'**
  String get salarySaved;

  /// No description provided for @setYourSalary.
  ///
  /// In en, this message translates to:
  /// **'Set Your Salary'**
  String get setYourSalary;

  /// No description provided for @saveGoal.
  ///
  /// In en, this message translates to:
  /// **'Save Goal'**
  String get saveGoal;

  /// No description provided for @noLimit.
  ///
  /// In en, this message translates to:
  /// **'No limit'**
  String get noLimit;

  /// No description provided for @budgetsSaved.
  ///
  /// In en, this message translates to:
  /// **'Category budgets saved successfully!'**
  String get budgetsSaved;

  /// No description provided for @errorLoadingBudgets.
  ///
  /// In en, this message translates to:
  /// **'Error loading budgets: {error}'**
  String errorLoadingBudgets(String error);

  /// No description provided for @errorSavingBudgets.
  ///
  /// In en, this message translates to:
  /// **'Error saving budgets: {error}'**
  String errorSavingBudgets(String error);

  /// No description provided for @savingsChallenges.
  ///
  /// In en, this message translates to:
  /// **'Savings Challenges'**
  String get savingsChallenges;

  /// No description provided for @categoryBudgetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Category Budgets'**
  String get categoryBudgetsTitle;

  /// No description provided for @noCategoryBudgets.
  ///
  /// In en, this message translates to:
  /// **'No category budgets set. Setup budget limits in your Profile to track category progress!'**
  String get noCategoryBudgets;

  /// No description provided for @setupCategoryBudgets.
  ///
  /// In en, this message translates to:
  /// **'Setup Category Budgets'**
  String get setupCategoryBudgets;

  /// No description provided for @budgetExceededBy.
  ///
  /// In en, this message translates to:
  /// **'Exceeded by {amount} DT!'**
  String budgetExceededBy(String amount);

  /// No description provided for @budgetEightyPercent.
  ///
  /// In en, this message translates to:
  /// **'80%+ spent'**
  String get budgetEightyPercent;

  /// No description provided for @flousiAiAssistant.
  ///
  /// In en, this message translates to:
  /// **'Flousi AI Assistant'**
  String get flousiAiAssistant;

  /// No description provided for @flousiAiSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Need help managing your money? Ask Flousi AI for personalized financial advice.'**
  String get flousiAiSubtitle;

  /// No description provided for @chatWithAi.
  ///
  /// In en, this message translates to:
  /// **'Chat with AI'**
  String get chatWithAi;

  /// No description provided for @askFlousi.
  ///
  /// In en, this message translates to:
  /// **'Ask Flousi something...'**
  String get askFlousi;

  /// No description provided for @flousiThinking.
  ///
  /// In en, this message translates to:
  /// **'Flousi is thinking...'**
  String get flousiThinking;

  /// No description provided for @deleteChat.
  ///
  /// In en, this message translates to:
  /// **'Delete Chat'**
  String get deleteChat;

  /// No description provided for @deleteChatConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"? This action cannot be undone.'**
  String deleteChatConfirm(String title);

  /// No description provided for @deletingChat.
  ///
  /// In en, this message translates to:
  /// **'Deleting chat...'**
  String get deletingChat;

  /// No description provided for @aiConversationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Ask Flousi AI for financial insights, saving strategies, or transaction analysis!'**
  String get aiConversationsEmpty;

  /// No description provided for @usageExceeded.
  ///
  /// In en, this message translates to:
  /// **'Warning: You have exceeded your monthly income'**
  String get usageExceeded;

  /// No description provided for @usagePercent.
  ///
  /// In en, this message translates to:
  /// **'You have used {percent}% of your monthly income'**
  String usagePercent(String percent);

  /// No description provided for @forecastOnPace.
  ///
  /// In en, this message translates to:
  /// **'On pace to finish with ~{amount} DT left ({days} days left)'**
  String forecastOnPace(String amount, int days);

  /// No description provided for @forecastOverspend.
  ///
  /// In en, this message translates to:
  /// **'On pace to overspend by ~{amount} DT'**
  String forecastOverspend(String amount);

  /// No description provided for @dailyAverage.
  ///
  /// In en, this message translates to:
  /// **'Daily average: {amount} DT'**
  String dailyAverage(String amount);

  /// No description provided for @onboardingWelcome.
  ///
  /// In en, this message translates to:
  /// **'Ahlan fi Flousi, {name}!'**
  String onboardingWelcome(String name);

  /// No description provided for @onboardingTagline.
  ///
  /// In en, this message translates to:
  /// **'Flousi — barra flousk'**
  String get onboardingTagline;

  /// No description provided for @onboardingIntro.
  ///
  /// In en, this message translates to:
  /// **'Let\'s set up your profile in 3 quick steps so your dashboard, budgets, and AI insights work correctly.'**
  String get onboardingIntro;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtn;

  /// No description provided for @finishSetup.
  ///
  /// In en, this message translates to:
  /// **'Finish setup'**
  String get finishSetup;

  /// No description provided for @skipBudgetSetup.
  ///
  /// In en, this message translates to:
  /// **'Skip budget setup for now'**
  String get skipBudgetSetup;

  /// No description provided for @validIncomeRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid monthly income'**
  String get validIncomeRequired;

  /// No description provided for @monthlyIncomeSetup.
  ///
  /// In en, this message translates to:
  /// **'Monthly income'**
  String get monthlyIncomeSetup;

  /// No description provided for @monthlyIncomeSetupHint.
  ///
  /// In en, this message translates to:
  /// **'This helps Flousi calculate how much you have left each month.'**
  String get monthlyIncomeSetupHint;

  /// No description provided for @savingsGoalSetup.
  ///
  /// In en, this message translates to:
  /// **'Savings goal'**
  String get savingsGoalSetup;

  /// No description provided for @savingsGoalSetupHint.
  ///
  /// In en, this message translates to:
  /// **'Optional — set a target to track progress on your home screen.'**
  String get savingsGoalSetupHint;

  /// No description provided for @monthlySavingsTarget.
  ///
  /// In en, this message translates to:
  /// **'Monthly savings target'**
  String get monthlySavingsTarget;

  /// No description provided for @catRent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get catRent;

  /// No description provided for @catBills.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get catBills;

  /// No description provided for @catFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get catFood;

  /// No description provided for @catGroceries.
  ///
  /// In en, this message translates to:
  /// **'Groceries'**
  String get catGroceries;

  /// No description provided for @catTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get catTransport;

  /// No description provided for @catEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get catEntertainment;

  /// No description provided for @catHealthcare.
  ///
  /// In en, this message translates to:
  /// **'Healthcare'**
  String get catHealthcare;

  /// No description provided for @catEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get catEducation;

  /// No description provided for @catShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get catShopping;

  /// No description provided for @catSavings.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get catSavings;

  /// No description provided for @catOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get catOther;

  /// No description provided for @insightBudgetExceededTitle.
  ///
  /// In en, this message translates to:
  /// **'{category} budget exceeded'**
  String insightBudgetExceededTitle(String category);

  /// No description provided for @insightBudgetExceededMsg.
  ///
  /// In en, this message translates to:
  /// **'You spent {spent} DT of your {limit} DT {category} limit. Try to pause non-essential {category} spending.'**
  String insightBudgetExceededMsg(String spent, String limit, String category);

  /// No description provided for @insightBudgetWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'{category} budget at {percent}%'**
  String insightBudgetWarningTitle(String category, String percent);

  /// No description provided for @insightBudgetWarningMsg.
  ///
  /// In en, this message translates to:
  /// **'Only {left} DT left in your {category} budget this month.'**
  String insightBudgetWarningMsg(String left, String category);

  /// No description provided for @insightHighPaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Spending pace is high'**
  String get insightHighPaceTitle;

  /// No description provided for @insightHighPaceMsg.
  ///
  /// In en, this message translates to:
  /// **'At your current rate (~{daily} DT/day), you may end the month {over} DT over budget.'**
  String insightHighPaceMsg(String daily, String over);

  /// No description provided for @insightTopCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Top spending: {category}'**
  String insightTopCategoryTitle(String category);

  /// No description provided for @insightTopCategoryMsg.
  ///
  /// In en, this message translates to:
  /// **'{category} is your biggest category at {amount} DT this month ({percent}% of spending).'**
  String insightTopCategoryMsg(String category, String amount, String percent);

  /// No description provided for @insightFreshStartTitle.
  ///
  /// In en, this message translates to:
  /// **'Fresh start this month'**
  String get insightFreshStartTitle;

  /// No description provided for @insightFreshStartMsg.
  ///
  /// In en, this message translates to:
  /// **'No expenses logged yet. Add your first expense to unlock personalized insights.'**
  String get insightFreshStartMsg;

  /// No description provided for @insightOnTrackTitle.
  ///
  /// In en, this message translates to:
  /// **'On track this month'**
  String get insightOnTrackTitle;

  /// No description provided for @insightOnTrackMsg.
  ///
  /// In en, this message translates to:
  /// **'You could finish with about {amount} DT remaining if you keep this pace.'**
  String insightOnTrackMsg(String amount);

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @lastSixMonths.
  ///
  /// In en, this message translates to:
  /// **'Last 6 months'**
  String get lastSixMonths;

  /// No description provided for @noMatchingExpenses.
  ///
  /// In en, this message translates to:
  /// **'No matching expenses'**
  String get noMatchingExpenses;

  /// No description provided for @expensesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} expenses'**
  String expensesCount(int count);

  /// No description provided for @expenseTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Expense title'**
  String get expenseTitleLabel;

  /// No description provided for @updateExpense.
  ///
  /// In en, this message translates to:
  /// **'Update expense'**
  String get updateExpense;

  /// No description provided for @saveExpense.
  ///
  /// In en, this message translates to:
  /// **'Save expense'**
  String get saveExpense;

  /// No description provided for @expenseUpdated.
  ///
  /// In en, this message translates to:
  /// **'Expense updated'**
  String get expenseUpdated;

  /// No description provided for @expenseSaved.
  ///
  /// In en, this message translates to:
  /// **'Expense saved successfully'**
  String get expenseSaved;

  /// No description provided for @receiptAttached.
  ///
  /// In en, this message translates to:
  /// **'Receipt attached'**
  String get receiptAttached;

  /// No description provided for @attachReceiptPhoto.
  ///
  /// In en, this message translates to:
  /// **'Attach receipt photo'**
  String get attachReceiptPhoto;

  /// No description provided for @subscriptionTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Subscription / title'**
  String get subscriptionTitleLabel;

  /// No description provided for @dayOfMonthDue.
  ///
  /// In en, this message translates to:
  /// **'Day of month due'**
  String get dayOfMonthDue;

  /// No description provided for @subscriptionUpdated.
  ///
  /// In en, this message translates to:
  /// **'Subscription updated'**
  String get subscriptionUpdated;

  /// No description provided for @subscriptionAdded.
  ///
  /// In en, this message translates to:
  /// **'Subscription added successfully'**
  String get subscriptionAdded;

  /// No description provided for @updateSubscription.
  ///
  /// In en, this message translates to:
  /// **'Update subscription'**
  String get updateSubscription;

  /// No description provided for @noSubscriptionsYet.
  ///
  /// In en, this message translates to:
  /// **'No recurring subscriptions yet'**
  String get noSubscriptionsYet;

  /// No description provided for @noSubscriptionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Add Subscription\" to schedule recurring outlays.'**
  String get noSubscriptionsSubtitle;

  /// No description provided for @dueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get dueToday;

  /// No description provided for @dueTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Due tomorrow'**
  String get dueTomorrow;

  /// No description provided for @dueInDays.
  ///
  /// In en, this message translates to:
  /// **'Due in {days} days'**
  String dueInDays(int days);

  /// No description provided for @dayOfMonthDetail.
  ///
  /// In en, this message translates to:
  /// **'Day {day} of month'**
  String dayOfMonthDetail(int day);

  /// No description provided for @deleteSubscriptionNamed.
  ///
  /// In en, this message translates to:
  /// **'Remove recurring payment for \"{title}\"?'**
  String deleteSubscriptionNamed(String title);

  /// No description provided for @newChat.
  ///
  /// In en, this message translates to:
  /// **'New chat'**
  String get newChat;

  /// No description provided for @noChatsYet.
  ///
  /// In en, this message translates to:
  /// **'No chats yet'**
  String get noChatsYet;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
