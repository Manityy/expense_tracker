import 'package:expense_tracker/l10n/app_localizations.dart';

/// Maps stored English category keys to localized display names.
class CategoryL10n {
  static String name(AppLocalizations l10n, String categoryKey) {
    switch (categoryKey) {
      case 'Rent':
        return l10n.catRent;
      case 'Bills':
        return l10n.catBills;
      case 'Food':
        return l10n.catFood;
      case 'Groceries':
        return l10n.catGroceries;
      case 'Transport':
        return l10n.catTransport;
      case 'Entertainment':
        return l10n.catEntertainment;
      case 'Healthcare':
        return l10n.catHealthcare;
      case 'Education':
        return l10n.catEducation;
      case 'Shopping':
        return l10n.catShopping;
      case 'Savings':
        return l10n.catSavings;
      case 'Other':
        return l10n.catOther;
      default:
        return categoryKey;
    }
  }
}
