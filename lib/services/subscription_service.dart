import 'firestore_service.dart';
import '../models/recurring_expense_model.dart';

class SubscriptionService {
  final FirestoreService _firestore = FirestoreService();

  Future<int> processDueSubscriptions(String userId) async {
    final subs = await _firestore.getRecurringExpensesOnce(userId);
    final now = DateTime.now();
    final monthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    var posted = 0;

    for (final sub in subs) {
      if (now.day < sub.dayOfMonth) continue;
      if (sub.lastPostedMonth == monthKey) continue;

      final alreadyPosted = await _firestore.hasSubscriptionExpenseThisMonth(
        userId: userId,
        subscriptionId: sub.id,
        month: now,
      );
      if (alreadyPosted) {
        await _firestore.markSubscriptionPosted(sub.id, userId, monthKey);
        continue;
      }

      await _firestore.createExpense({
        'title': '${sub.title} (Subscription)',
        'amount': sub.amount,
        'category': sub.category,
        'date': DateTime(now.year, now.month, sub.dayOfMonth)
            .toIso8601String(),
        'userId': userId,
        'subscriptionId': sub.id,
        'isAutoPosted': true,
      });

      await _firestore.markSubscriptionPosted(sub.id, userId, monthKey);
      posted++;
    }

    return posted;
  }

  List<RecurringExpenseModel> getDueSoon(
    List<RecurringExpenseModel> subs, {
    int withinDays = 3,
  }) {
    final now = DateTime.now();
    return subs.where((sub) {
      final days = _daysUntilOccurrence(sub.dayOfMonth, now);
      return days >= 0 && days <= withinDays;
    }).toList();
  }

  int _daysUntilOccurrence(int dayOfMonth, DateTime now) {
    if (now.day <= dayOfMonth) {
      return dayOfMonth - now.day;
    }
    final nextMonth = now.month == 12 ? 1 : now.month + 1;
    final nextYear = now.month == 12 ? now.year + 1 : now.year;
    final nextDate = DateTime(nextYear, nextMonth, dayOfMonth);
    return nextDate.difference(DateTime(now.year, now.month, now.day)).inDays;
  }
}
