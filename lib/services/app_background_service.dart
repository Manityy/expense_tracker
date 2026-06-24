import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import '../../services/subscription_service.dart';
import '../../services/notification_service.dart';
import '../../utils/challenges_helper.dart';
import '../../models/user_model.dart';

class AppBackgroundService {
  static Future<void> runStartupTasks(FirestoreService firestore) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final notifications = NotificationService();
    await notifications.initialize();
    await notifications.requestPermission();

    final subService = SubscriptionService();
    await subService.processDueSubscriptions(userId);

    final userDoc = await firestore.getUser(userId);
    if (!userDoc.exists) return;

    final user = UserModel.fromMap(userDoc.data()!);
    final spending = await firestore.getCategorySpendingThisMonth(userId);

    for (final entry in user.categoryBudgets.entries) {
      if (entry.value <= 0) continue;
      final spent = spending[entry.key] ?? 0;
      if (spent / entry.value >= 0.8) {
        await notifications.showBudgetAlert(
          category: entry.key,
          spent: spent,
          limit: entry.value,
        );
      }
    }

    final subs = await firestore.getRecurringExpensesOnce(userId);
    for (final sub in subService.getDueSoon(subs)) {
      final now = DateTime.now();
      final days = sub.dayOfMonth >= now.day ? sub.dayOfMonth - now.day : 0;
      await notifications.showSubscriptionDue(
        title: sub.title,
        amount: sub.amount,
        daysLeft: days,
      );
    }

    final challenges = ChallengesHelper.evaluate(
      weekExpenses: await firestore.getThisWeekExpenses(userId),
      weekendExpenses: await firestore.getThisWeekendExpenses(userId),
      lastWeekExpenses: await firestore.getLastWeekExpenses(userId),
      monthSpending: spending,
      categoryBudgets: user.categoryBudgets,
    );

    for (final challenge in challenges) {
      if (challenge.isCompleted) {
        await notifications.showChallengeCompleted(challenge.title);
      }
    }
  }
}
