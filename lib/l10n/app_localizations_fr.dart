// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Flousi';

  @override
  String get navHome => 'Accueil';

  @override
  String get navExpenses => 'Dépenses';

  @override
  String get navAnalytics => 'Analyses';

  @override
  String get navSubscriptions => 'Abos';

  @override
  String get navProfile => 'Profil';

  @override
  String welcomeGreeting(String name) {
    return 'Ahlan, $name';
  }

  @override
  String get welcomeSubtitle => 'Flousk fi yedek';

  @override
  String get profile => 'Profil';

  @override
  String get appearance => 'Apparence';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get language => 'Langue';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageArabic => 'العربية';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get monthlyIncome => 'Revenu mensuel';

  @override
  String get remainingThisMonth => 'Reste ce mois';

  @override
  String get spentThisMonth => 'Dépensé ce mois';

  @override
  String get accountSettings => 'Compte';

  @override
  String get achievements => 'Succès';

  @override
  String get logOut => 'Se déconnecter';

  @override
  String get logOutConfirmTitle => 'Se déconnecter ?';

  @override
  String get logOutConfirmMessage =>
      'Vous devrez vous reconnecter pour accéder à vos données.';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get save => 'Enregistrer';

  @override
  String get change => 'Changer';

  @override
  String get all => 'Tout';

  @override
  String get unableToLoadProfile => 'Impossible de charger le profil';

  @override
  String get userNotFound => 'Profil utilisateur introuvable';

  @override
  String get profileNotFound => 'Profil introuvable';

  @override
  String get updateSalary => 'Modifier le salaire';

  @override
  String get manageMonthlyIncome => 'Gérer votre revenu mensuel';

  @override
  String get categoryBudgets => 'Budgets par catégorie';

  @override
  String get categoryBudgetsSubtitle => 'Définir des limites de dépenses';

  @override
  String get exportExpenses => 'Exporter les dépenses';

  @override
  String get exportExpensesSubtitle =>
      'Télécharger un CSV de toutes vos dépenses';

  @override
  String get noExpensesToExport => 'Aucune dépense à exporter';

  @override
  String get savingsGoal => 'Objectif d\'épargne';

  @override
  String savingsGoalSet(String amount) {
    return 'Objectif : $amount DT';
  }

  @override
  String get savingsGoalUnset => 'Définir un objectif d\'épargne';

  @override
  String get myChallenges => 'Mes défis';

  @override
  String challengesCompleted(int count) {
    return '$count terminés';
  }

  @override
  String get challengesEmpty => 'Relevez des défis pour gagner des badges';

  @override
  String get recentTransactions => 'Transactions récentes';

  @override
  String get noExpensesYet => 'Aucune dépense. Appuyez sur + pour en ajouter.';

  @override
  String get noExpensesYetShort => 'Aucune dépense';

  @override
  String get noExpensesYetSubtitle =>
      'Suivez vos dépenses en ajoutant votre première dépense.';

  @override
  String get endOfMonthForecast => 'Prévision fin de mois';

  @override
  String get savingsGoalTitle => 'Objectif d\'épargne';

  @override
  String get goal => 'Objectif';

  @override
  String get current => 'Actuel';

  @override
  String get goalAchieved => 'Objectif atteint !';

  @override
  String get keepSaving => 'Continuez à épargner !';

  @override
  String get signIn => 'Se connecter';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get welcomeBack => 'Ahlan bik';

  @override
  String get signInSubtitle =>
      'Flousi — Connectez-vous pour suivre vos dépenses';

  @override
  String get joinFlousi => 'Rejoindre Flousi';

  @override
  String get registerSubtitle => 'Flousi — Commencez à suivre en DT';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get fullName => 'Nom complet';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get resetPassword => 'Réinitialiser le mot de passe';

  @override
  String get sendLink => 'Envoyer le lien';

  @override
  String get passwordResetSent =>
      'E-mail de réinitialisation envoyé. Vérifiez votre boîte mail.';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get myExpenses => 'Mes dépenses';

  @override
  String get addExpense => 'Ajouter une dépense';

  @override
  String get editExpense => 'Modifier la dépense';

  @override
  String get deleteExpense => 'Supprimer la dépense';

  @override
  String get deleteExpenseConfirm =>
      'Voulez-vous vraiment supprimer cette dépense ?';

  @override
  String get searchExpenses => 'Rechercher des dépenses...';

  @override
  String errorLoadingExpenses(String error) {
    return 'Erreur de chargement : $error';
  }

  @override
  String get analytics => 'Analyses';

  @override
  String get unableToLoadAnalytics => 'Impossible de charger les analyses';

  @override
  String get analyticsEmptySubtitle =>
      'Commencez à suivre pour débloquer les analyses.';

  @override
  String noExpensesInMonth(String month) {
    return 'Aucune dépense en $month';
  }

  @override
  String get pickAnotherMonth =>
      'Choisissez un autre mois ou ajoutez une dépense.';

  @override
  String get spent => 'Dépensé';

  @override
  String get remaining => 'Reste';

  @override
  String get ofIncome => 'Du revenu';

  @override
  String get transactions => 'Transactions';

  @override
  String get byCategory => 'Par catégorie';

  @override
  String percentOfSpending(String percent) {
    return '$percent % des dépenses';
  }

  @override
  String get sixMonthSpending => 'Dépenses sur 6 mois';

  @override
  String get fullMonthlyHistory => 'Historique mensuel complet';

  @override
  String get fullMonthlyHistorySubtitle => 'Tendances, moyennes et évolution';

  @override
  String get monthlyTrend => 'Tendance mensuelle';

  @override
  String get noSpendingHistory => 'Pas encore d\'historique';

  @override
  String get noSpendingHistorySubtitle =>
      'Ajoutez des dépenses pour voir vos tendances.';

  @override
  String get vsLastMonth => 'vs mois dernier';

  @override
  String get sixMonthAverage => 'Moyenne 6 mois';

  @override
  String get allMonths => 'Tous les mois';

  @override
  String vsPrevious(String change) {
    return '$change vs précédent';
  }

  @override
  String get subscriptions => 'Abonnements';

  @override
  String get addSubscription => 'Ajouter un abonnement';

  @override
  String get editSubscription => 'Modifier l\'abonnement';

  @override
  String get deleteSubscription => 'Supprimer l\'abonnement';

  @override
  String get deleteSubscriptionConfirm =>
      'Voulez-vous vraiment supprimer cet abonnement ?';

  @override
  String errorLoadingSubscriptions(String error) {
    return 'Erreur de chargement : $error';
  }

  @override
  String get subscriptionNameHint => 'ex. Netflix, Loyer, Internet';

  @override
  String get fillAllFields => 'Veuillez remplir tous les champs';

  @override
  String get validAmountRequired => 'Veuillez entrer un montant valide';

  @override
  String dayOfMonth(int day) {
    return 'Jour $day';
  }

  @override
  String get amount => 'Montant';

  @override
  String get title => 'Titre';

  @override
  String get category => 'Catégorie';

  @override
  String get date => 'Date';

  @override
  String get expenseTitleHint => 'ex. Courses Carrefour';

  @override
  String get takePhoto => 'Prendre une photo';

  @override
  String get chooseFromGallery => 'Choisir dans la galerie';

  @override
  String get receiptPhoto => 'Photo du reçu';

  @override
  String get flousiCategorizing => 'Flousi catégorise...';

  @override
  String get salary => 'Salaire';

  @override
  String get saveSalary => 'Enregistrer le salaire';

  @override
  String get salarySaved => 'Salaire enregistré';

  @override
  String get setYourSalary => 'Définir votre salaire';

  @override
  String get saveGoal => 'Enregistrer l\'objectif';

  @override
  String get noLimit => 'Sans limite';

  @override
  String get budgetsSaved => 'Budgets enregistrés avec succès !';

  @override
  String errorLoadingBudgets(String error) {
    return 'Erreur de chargement : $error';
  }

  @override
  String errorSavingBudgets(String error) {
    return 'Erreur d\'enregistrement : $error';
  }

  @override
  String get savingsChallenges => 'Défis d\'épargne';

  @override
  String get categoryBudgetsTitle => 'Budgets par catégorie';

  @override
  String get noCategoryBudgets =>
      'Aucun budget défini. Configurez des limites dans votre Profil !';

  @override
  String get setupCategoryBudgets => 'Configurer les budgets';

  @override
  String budgetExceededBy(String amount) {
    return 'Dépassé de $amount DT !';
  }

  @override
  String get budgetEightyPercent => '80 %+ dépensé';

  @override
  String get flousiAiAssistant => 'Assistant Flousi AI';

  @override
  String get flousiAiSubtitle =>
      'Besoin d\'aide ? Demandez des conseils personnalisés à Flousi AI.';

  @override
  String get chatWithAi => 'Discuter avec l\'IA';

  @override
  String get askFlousi => 'Demandez quelque chose à Flousi...';

  @override
  String get flousiThinking => 'Flousi réfléchit...';

  @override
  String get deleteChat => 'Supprimer la discussion';

  @override
  String deleteChatConfirm(String title) {
    return 'Supprimer \"$title\" ? Cette action est irréversible.';
  }

  @override
  String get deletingChat => 'Suppression...';

  @override
  String get aiConversationsEmpty =>
      'Demandez à Flousi AI des conseils, stratégies d\'épargne ou analyses !';

  @override
  String get usageExceeded =>
      'Attention : vous avez dépassé votre revenu mensuel';

  @override
  String usagePercent(String percent) {
    return 'Vous avez utilisé $percent % de votre revenu mensuel';
  }

  @override
  String forecastOnPace(String amount, int days) {
    return 'Rythme actuel : ~$amount DT restants ($days jours restants)';
  }

  @override
  String forecastOverspend(String amount) {
    return 'Rythme actuel : dépassement de ~$amount DT';
  }

  @override
  String dailyAverage(String amount) {
    return 'Moyenne quotidienne : $amount DT';
  }

  @override
  String onboardingWelcome(String name) {
    return 'Ahlan fi Flousi, $name !';
  }

  @override
  String get onboardingTagline => 'Flousi — barra flousk';

  @override
  String get onboardingIntro =>
      'Configurons votre profil en 3 étapes pour activer tableau de bord, budgets et insights IA.';

  @override
  String get continueBtn => 'Continuer';

  @override
  String get finishSetup => 'Terminer';

  @override
  String get skipBudgetSetup => 'Ignorer les budgets pour l\'instant';

  @override
  String get validIncomeRequired => 'Veuillez entrer un revenu mensuel valide';

  @override
  String get monthlyIncomeSetup => 'Revenu mensuel';

  @override
  String get monthlyIncomeSetupHint =>
      'Flousi calcule ainsi ce qu\'il vous reste chaque mois.';

  @override
  String get savingsGoalSetup => 'Objectif d\'épargne';

  @override
  String get savingsGoalSetupHint =>
      'Optionnel — suivez votre progression sur l\'accueil.';

  @override
  String get monthlySavingsTarget => 'Objectif d\'épargne mensuel';

  @override
  String get catRent => 'Loyer';

  @override
  String get catBills => 'Factures';

  @override
  String get catFood => 'Nourriture';

  @override
  String get catGroceries => 'Courses';

  @override
  String get catTransport => 'Transport';

  @override
  String get catEntertainment => 'Loisirs';

  @override
  String get catHealthcare => 'Santé';

  @override
  String get catEducation => 'Éducation';

  @override
  String get catShopping => 'Shopping';

  @override
  String get catSavings => 'Épargne';

  @override
  String get catOther => 'Autre';

  @override
  String insightBudgetExceededTitle(String category) {
    return 'Budget $category dépassé';
  }

  @override
  String insightBudgetExceededMsg(String spent, String limit, String category) {
    return 'Vous avez dépensé $spent DT sur $limit DT pour $category. Réduisez les dépenses non essentielles.';
  }

  @override
  String insightBudgetWarningTitle(String category, String percent) {
    return 'Budget $category à $percent %';
  }

  @override
  String insightBudgetWarningMsg(String left, String category) {
    return 'Il reste seulement $left DT pour $category ce mois.';
  }

  @override
  String get insightHighPaceTitle => 'Rythme de dépenses élevé';

  @override
  String insightHighPaceMsg(String daily, String over) {
    return 'À ce rythme (~$daily DT/jour), vous pourriez finir à $over DT au-dessus du budget.';
  }

  @override
  String insightTopCategoryTitle(String category) {
    return 'Top dépenses : $category';
  }

  @override
  String insightTopCategoryMsg(String category, String amount, String percent) {
    return '$category est votre plus grande catégorie à $amount DT ($percent % des dépenses).';
  }

  @override
  String get insightFreshStartTitle => 'Nouveau départ ce mois';

  @override
  String get insightFreshStartMsg =>
      'Aucune dépense enregistrée. Ajoutez votre première dépense pour des insights personnalisés.';

  @override
  String get insightOnTrackTitle => 'Bon rythme ce mois';

  @override
  String insightOnTrackMsg(String amount) {
    return 'Vous pourriez finir avec environ $amount DT restants à ce rythme.';
  }

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get lastSixMonths => '6 derniers mois';

  @override
  String get noMatchingExpenses => 'Aucune dépense correspondante';

  @override
  String expensesCount(int count) {
    return '$count dépenses';
  }

  @override
  String get expenseTitleLabel => 'Titre de la dépense';

  @override
  String get updateExpense => 'Mettre à jour';

  @override
  String get saveExpense => 'Enregistrer';

  @override
  String get expenseUpdated => 'Dépense mise à jour';

  @override
  String get expenseSaved => 'Dépense enregistrée avec succès';

  @override
  String get receiptAttached => 'Reçu joint';

  @override
  String get attachReceiptPhoto => 'Joindre une photo du reçu';

  @override
  String get subscriptionTitleLabel => 'Abonnement / titre';

  @override
  String get dayOfMonthDue => 'Jour d\'échéance';

  @override
  String get subscriptionUpdated => 'Abonnement mis à jour';

  @override
  String get subscriptionAdded => 'Abonnement ajouté avec succès';

  @override
  String get updateSubscription => 'Mettre à jour';

  @override
  String get noSubscriptionsYet => 'Aucun abonnement récurrent';

  @override
  String get noSubscriptionsSubtitle =>
      'Appuyez sur « Ajouter » pour planifier des paiements récurrents.';

  @override
  String get dueToday => 'Échéance aujourd\'hui';

  @override
  String get dueTomorrow => 'Échéance demain';

  @override
  String dueInDays(int days) {
    return 'Échéance dans $days jours';
  }

  @override
  String dayOfMonthDetail(int day) {
    return 'Jour $day du mois';
  }

  @override
  String deleteSubscriptionNamed(String title) {
    return 'Supprimer le paiement récurrent pour « $title » ?';
  }

  @override
  String get newChat => 'Nouvelle discussion';

  @override
  String get noChatsYet => 'Aucune discussion';
}
