import 'package:cloud_firestore/cloud_firestore.dart';
import 'expense_date_utils.dart';

class ExpenseHelpers {
  static double monthlyTotal(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs, {
    DateTime? month,
  }) {
    final target = month ?? DateTime.now();
    var total = 0.0;
    for (final doc in docs) {
      final date = ExpenseDateUtils.parse(doc.data()['date']);
      if (date != null && ExpenseDateUtils.isInMonth(date, target)) {
        total += (doc.data()['amount'] as num?)?.toDouble() ?? 0;
      }
    }
    return total;
  }

  static Map<String, double> categorySpending(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs, {
    DateTime? month,
  }) {
    final target = month ?? DateTime.now();
    final spending = <String, double>{};
    for (final doc in docs) {
      final date = ExpenseDateUtils.parse(doc.data()['date']);
      if (date == null || !ExpenseDateUtils.isInMonth(date, target)) continue;
      final category = doc.data()['category'] as String? ?? 'Other';
      final amount = (doc.data()['amount'] as num?)?.toDouble() ?? 0;
      spending[category] = (spending[category] ?? 0) + amount;
    }
    return spending;
  }

  static List<QueryDocumentSnapshot<Map<String, dynamic>>> recent(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs, {
    int limit = 5,
  }) {
    final sorted = List<QueryDocumentSnapshot<Map<String, dynamic>>>.from(docs)
      ..sort((a, b) {
        final dateA = ExpenseDateUtils.parse(a.data()['date']) ?? DateTime(1970);
        final dateB = ExpenseDateUtils.parse(b.data()['date']) ?? DateTime(1970);
        return dateB.compareTo(dateA);
      });
    return sorted.take(limit).toList();
  }
}
