import 'package:cloud_firestore/cloud_firestore.dart';
import 'expense_date_utils.dart';

class AnalyticsHelpers {
  static Map<String, double> monthlyTotalsFromExpenses(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final totals = <String, double>{};
    for (final doc in docs) {
      final date = ExpenseDateUtils.parse(doc.data()['date']);
      if (date == null) continue;
      final key = _monthKey(date);
      totals[key] =
          (totals[key] ?? 0) + ((doc.data()['amount'] as num?)?.toDouble() ?? 0);
    }
    return totals;
  }

  static String _monthKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}';
  }

  static List<MapEntry<String, double>> lastNMonths({
    required Map<String, double> totals,
    required int count,
    DateTime? endMonth,
  }) {
    final end = endMonth ?? DateTime.now();
    final anchor = DateTime(end.year, end.month, 1);
    final result = <MapEntry<String, double>>[];

    for (int i = count - 1; i >= 0; i--) {
      final month = DateTime(anchor.year, anchor.month - i, 1);
      final key = _monthKey(month);
      result.add(MapEntry(key, totals[key] ?? 0));
    }
    return result;
  }

  static String formatMonthKey(String key) {
    try {
      final parts = key.split('-');
      if (parts.length < 2) return key;
      final year = parts[0].substring(2);
      final month = int.parse(parts[1]);
      const names = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      return "${names[month - 1]} '$year";
    } catch (_) {
      return key;
    }
  }

  static String formatMonthKeyLong(String key) {
    try {
      final parts = key.split('-');
      if (parts.length < 2) return key;
      final month = int.parse(parts[1]);
      final year = parts[0];
      const names = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December',
      ];
      return '${names[month - 1]} $year';
    } catch (_) {
      return key;
    }
  }

  static double chartMaxY(Iterable<double> values) {
    final maxVal = values.fold<double>(0, (m, v) => v > m ? v : m);
    if (maxVal <= 0) return 100;
    return maxVal * 1.25;
  }
}
