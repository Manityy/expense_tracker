// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flousi';

  @override
  String get navHome => 'Home';

  @override
  String get navExpenses => 'Expenses';

  @override
  String get navAnalytics => 'Analytics';

  @override
  String get navSubscriptions => 'Subs';

  @override
  String get navProfile => 'Profile';

  @override
  String welcomeGreeting(String name) {
    return 'Ahlan, $name';
  }

  @override
  String get welcomeSubtitle => 'Flousk fi yedek';

  @override
  String get profile => 'Profile';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageArabic => 'العربية';

  @override
  String get themeSystem => 'System default';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get monthlyIncome => 'Monthly Income';

  @override
  String get remainingThisMonth => 'Remaining this month';

  @override
  String get spentThisMonth => 'Spent this month';

  @override
  String get accountSettings => 'Account';

  @override
  String get achievements => 'Achievements';

  @override
  String get logOut => 'Log out';

  @override
  String get logOutConfirmTitle => 'Log out?';

  @override
  String get logOutConfirmMessage =>
      'You will need to sign in again to access your data.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get change => 'Change';

  @override
  String get all => 'All';

  @override
  String get unableToLoadProfile => 'Unable to load profile';

  @override
  String get userNotFound => 'User document not found';

  @override
  String get profileNotFound => 'Profile not found';

  @override
  String get updateSalary => 'Update Salary';

  @override
  String get manageMonthlyIncome => 'Manage your monthly income';

  @override
  String get categoryBudgets => 'Category Budgets';

  @override
  String get categoryBudgetsSubtitle => 'Set spending limits per category';

  @override
  String get exportExpenses => 'Export Expenses';

  @override
  String get exportExpensesSubtitle => 'Download CSV of all your expenses';

  @override
  String get noExpensesToExport => 'No expenses to export';

  @override
  String get savingsGoal => 'Savings Goal';

  @override
  String savingsGoalSet(String amount) {
    return 'Goal: $amount DT';
  }

  @override
  String get savingsGoalUnset => 'Set a savings target';

  @override
  String get myChallenges => 'My Challenges';

  @override
  String challengesCompleted(int count) {
    return '$count completed';
  }

  @override
  String get challengesEmpty => 'Complete challenges to earn badges';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get noExpensesYet => 'No expenses yet. Tap + to add one.';

  @override
  String get noExpensesYetShort => 'No expenses yet';

  @override
  String get noExpensesYetSubtitle =>
      'Track your spending by adding your first expense.';

  @override
  String get endOfMonthForecast => 'End-of-month forecast';

  @override
  String get savingsGoalTitle => 'Savings Goal';

  @override
  String get goal => 'Goal';

  @override
  String get current => 'Current';

  @override
  String get goalAchieved => 'Goal achieved!';

  @override
  String get keepSaving => 'Keep saving!';

  @override
  String get signIn => 'Sign in';

  @override
  String get createAccount => 'Create an account';

  @override
  String get welcomeBack => 'Ahlan bik';

  @override
  String get signInSubtitle => 'Flousi — Sign in to track your spending';

  @override
  String get joinFlousi => 'Join Flousi';

  @override
  String get registerSubtitle => 'Flousi — Start tracking in DT';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get fullName => 'Full Name';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get sendLink => 'Send link';

  @override
  String get passwordResetSent =>
      'Password reset email sent. Check your inbox.';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get myExpenses => 'My Expenses';

  @override
  String get addExpense => 'Add Expense';

  @override
  String get editExpense => 'Edit Expense';

  @override
  String get deleteExpense => 'Delete Expense';

  @override
  String get deleteExpenseConfirm =>
      'Are you sure you want to delete this expense?';

  @override
  String get searchExpenses => 'Search expenses...';

  @override
  String errorLoadingExpenses(String error) {
    return 'Error loading expenses: $error';
  }

  @override
  String get analytics => 'Analytics';

  @override
  String get unableToLoadAnalytics => 'Unable to load analytics';

  @override
  String get analyticsEmptySubtitle => 'Start tracking to unlock analytics.';

  @override
  String noExpensesInMonth(String month) {
    return 'No expenses in $month';
  }

  @override
  String get pickAnotherMonth => 'Pick another month or add an expense.';

  @override
  String get spent => 'Spent';

  @override
  String get remaining => 'Remaining';

  @override
  String get ofIncome => 'Of income';

  @override
  String get transactions => 'Transactions';

  @override
  String get byCategory => 'By category';

  @override
  String percentOfSpending(String percent) {
    return '$percent% of spending';
  }

  @override
  String get sixMonthSpending => '6-month spending';

  @override
  String get fullMonthlyHistory => 'Full monthly history';

  @override
  String get fullMonthlyHistorySubtitle =>
      'Trends, averages & month-over-month';

  @override
  String get monthlyTrend => 'Monthly Trend';

  @override
  String get noSpendingHistory => 'No spending history yet';

  @override
  String get noSpendingHistorySubtitle =>
      'Add expenses to see your monthly trends here.';

  @override
  String get vsLastMonth => 'vs last month';

  @override
  String get sixMonthAverage => '6-mo average';

  @override
  String get allMonths => 'All months';

  @override
  String vsPrevious(String change) {
    return '$change vs previous';
  }

  @override
  String get subscriptions => 'Subscriptions';

  @override
  String get addSubscription => 'Add Subscription';

  @override
  String get editSubscription => 'Edit Subscription';

  @override
  String get deleteSubscription => 'Delete Subscription';

  @override
  String get deleteSubscriptionConfirm =>
      'Are you sure you want to delete this subscription?';

  @override
  String errorLoadingSubscriptions(String error) {
    return 'Error loading subscriptions: $error';
  }

  @override
  String get subscriptionNameHint => 'e.g. Netflix, Rent, Internet';

  @override
  String get fillAllFields => 'Please fill in all fields';

  @override
  String get validAmountRequired => 'Please enter a valid amount';

  @override
  String dayOfMonth(int day) {
    return 'Day $day';
  }

  @override
  String get amount => 'Amount';

  @override
  String get title => 'Title';

  @override
  String get category => 'Category';

  @override
  String get date => 'Date';

  @override
  String get expenseTitleHint => 'e.g., Carrefour groceries';

  @override
  String get takePhoto => 'Take photo';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get receiptPhoto => 'Receipt photo';

  @override
  String get flousiCategorizing => 'Flousi is categorizing...';

  @override
  String get salary => 'Salary';

  @override
  String get saveSalary => 'Save Salary';

  @override
  String get salarySaved => 'Salary saved';

  @override
  String get setYourSalary => 'Set Your Salary';

  @override
  String get saveGoal => 'Save Goal';

  @override
  String get noLimit => 'No limit';

  @override
  String get budgetsSaved => 'Category budgets saved successfully!';

  @override
  String errorLoadingBudgets(String error) {
    return 'Error loading budgets: $error';
  }

  @override
  String errorSavingBudgets(String error) {
    return 'Error saving budgets: $error';
  }

  @override
  String get savingsChallenges => 'Savings Challenges';

  @override
  String get categoryBudgetsTitle => 'Category Budgets';

  @override
  String get noCategoryBudgets =>
      'No category budgets set. Setup budget limits in your Profile to track category progress!';

  @override
  String get setupCategoryBudgets => 'Setup Category Budgets';

  @override
  String budgetExceededBy(String amount) {
    return 'Exceeded by $amount DT!';
  }

  @override
  String get budgetEightyPercent => '80%+ spent';

  @override
  String get flousiAiAssistant => 'Flousi AI Assistant';

  @override
  String get flousiAiSubtitle =>
      'Need help managing your money? Ask Flousi AI for personalized financial advice.';

  @override
  String get chatWithAi => 'Chat with AI';

  @override
  String get askFlousi => 'Ask Flousi something...';

  @override
  String get flousiThinking => 'Flousi is thinking...';

  @override
  String get deleteChat => 'Delete Chat';

  @override
  String deleteChatConfirm(String title) {
    return 'Are you sure you want to delete \"$title\"? This action cannot be undone.';
  }

  @override
  String get deletingChat => 'Deleting chat...';

  @override
  String get aiConversationsEmpty =>
      'Ask Flousi AI for financial insights, saving strategies, or transaction analysis!';

  @override
  String get usageExceeded => 'Warning: You have exceeded your monthly income';

  @override
  String usagePercent(String percent) {
    return 'You have used $percent% of your monthly income';
  }

  @override
  String forecastOnPace(String amount, int days) {
    return 'On pace to finish with ~$amount DT left ($days days left)';
  }

  @override
  String forecastOverspend(String amount) {
    return 'On pace to overspend by ~$amount DT';
  }

  @override
  String dailyAverage(String amount) {
    return 'Daily average: $amount DT';
  }

  @override
  String onboardingWelcome(String name) {
    return 'Ahlan fi Flousi, $name!';
  }

  @override
  String get onboardingTagline => 'Flousi — barra flousk';

  @override
  String get onboardingIntro =>
      'Let\'s set up your profile in 3 quick steps so your dashboard, budgets, and AI insights work correctly.';

  @override
  String get continueBtn => 'Continue';

  @override
  String get finishSetup => 'Finish setup';

  @override
  String get skipBudgetSetup => 'Skip budget setup for now';

  @override
  String get validIncomeRequired => 'Please enter a valid monthly income';

  @override
  String get monthlyIncomeSetup => 'Monthly income';

  @override
  String get monthlyIncomeSetupHint =>
      'This helps Flousi calculate how much you have left each month.';

  @override
  String get savingsGoalSetup => 'Savings goal';

  @override
  String get savingsGoalSetupHint =>
      'Optional — set a target to track progress on your home screen.';

  @override
  String get monthlySavingsTarget => 'Monthly savings target';

  @override
  String get catRent => 'Rent';

  @override
  String get catBills => 'Bills';

  @override
  String get catFood => 'Food';

  @override
  String get catGroceries => 'Groceries';

  @override
  String get catTransport => 'Transport';

  @override
  String get catEntertainment => 'Entertainment';

  @override
  String get catHealthcare => 'Healthcare';

  @override
  String get catEducation => 'Education';

  @override
  String get catShopping => 'Shopping';

  @override
  String get catSavings => 'Savings';

  @override
  String get catOther => 'Other';

  @override
  String insightBudgetExceededTitle(String category) {
    return '$category budget exceeded';
  }

  @override
  String insightBudgetExceededMsg(String spent, String limit, String category) {
    return 'You spent $spent DT of your $limit DT $category limit. Try to pause non-essential $category spending.';
  }

  @override
  String insightBudgetWarningTitle(String category, String percent) {
    return '$category budget at $percent%';
  }

  @override
  String insightBudgetWarningMsg(String left, String category) {
    return 'Only $left DT left in your $category budget this month.';
  }

  @override
  String get insightHighPaceTitle => 'Spending pace is high';

  @override
  String insightHighPaceMsg(String daily, String over) {
    return 'At your current rate (~$daily DT/day), you may end the month $over DT over budget.';
  }

  @override
  String insightTopCategoryTitle(String category) {
    return 'Top spending: $category';
  }

  @override
  String insightTopCategoryMsg(String category, String amount, String percent) {
    return '$category is your biggest category at $amount DT this month ($percent% of spending).';
  }

  @override
  String get insightFreshStartTitle => 'Fresh start this month';

  @override
  String get insightFreshStartMsg =>
      'No expenses logged yet. Add your first expense to unlock personalized insights.';

  @override
  String get insightOnTrackTitle => 'On track this month';

  @override
  String insightOnTrackMsg(String amount) {
    return 'You could finish with about $amount DT remaining if you keep this pace.';
  }

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get lastSixMonths => 'Last 6 months';

  @override
  String get noMatchingExpenses => 'No matching expenses';

  @override
  String expensesCount(int count) {
    return '$count expenses';
  }

  @override
  String get expenseTitleLabel => 'Expense title';

  @override
  String get updateExpense => 'Update expense';

  @override
  String get saveExpense => 'Save expense';

  @override
  String get expenseUpdated => 'Expense updated';

  @override
  String get expenseSaved => 'Expense saved successfully';

  @override
  String get receiptAttached => 'Receipt attached';

  @override
  String get attachReceiptPhoto => 'Attach receipt photo';

  @override
  String get subscriptionTitleLabel => 'Subscription / title';

  @override
  String get dayOfMonthDue => 'Day of month due';

  @override
  String get subscriptionUpdated => 'Subscription updated';

  @override
  String get subscriptionAdded => 'Subscription added successfully';

  @override
  String get updateSubscription => 'Update subscription';

  @override
  String get noSubscriptionsYet => 'No recurring subscriptions yet';

  @override
  String get noSubscriptionsSubtitle =>
      'Tap \"Add Subscription\" to schedule recurring outlays.';

  @override
  String get dueToday => 'Due today';

  @override
  String get dueTomorrow => 'Due tomorrow';

  @override
  String dueInDays(int days) {
    return 'Due in $days days';
  }

  @override
  String dayOfMonthDetail(int day) {
    return 'Day $day of month';
  }

  @override
  String deleteSubscriptionNamed(String title) {
    return 'Remove recurring payment for \"$title\"?';
  }

  @override
  String get newChat => 'New chat';

  @override
  String get noChatsYet => 'No chats yet';
}
