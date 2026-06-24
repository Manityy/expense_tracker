import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';
import '../models/conversation_model.dart';
import '../models/chat_message_model.dart';
import '../models/recurring_expense_model.dart';
import '../utils/expense_date_utils.dart';


class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(user.toMap());
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(
      String uid,
      ) async {
    return await _firestore
        .collection('users')
        .doc(uid)
        .get();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  }

  Future<void> ensureOnboardingFlag(String uid) async {
    final doc = await getUser(uid);
    if (!doc.exists) return;
    final data = doc.data()!;
    final salary = (data['salary'] ?? 0).toDouble();
    final completed = data['onboardingCompleted'] ?? false;
    if (salary > 0 && !completed) {
      await _firestore.collection('users').doc(uid).update({
        'onboardingCompleted': true,
      });
    }
  }

  Future<void> createExpense(Map<String, dynamic> expense) async {
    await _firestore.collection('expenses').add(expense);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserExpenses(
      String userId,
      ) {
    return _firestore
        .collection('expenses')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  Future<void> deleteExpense(String expenseId) async {
    await _firestore
        .collection('expenses')
        .doc(expenseId)
        .delete();
  }

  Future<void> updateExpense(
    String expenseId,
    Map<String, dynamic> data,
  ) async {
    await _firestore.collection('expenses').doc(expenseId).update(data);
  }

  Future<void> completeOnboarding({
    required String uid,
    required double salary,
    required double savingsGoal,
  }) async {
    await _firestore.collection('users').doc(uid).update({
      'salary': salary,
      'savingsGoal': savingsGoal,
      'onboardingCompleted': true,
    });
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
  getExpensesOnce(String userId) async {
    final snapshot = await _firestore
        .collection('expenses')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs;
  }
  Future<void> updateSalary(
      String uid,
      double salary,
      ) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .update({
      'salary': salary,
    });
  }
  Future<double> getTotalExpenses(String userId) async {
    return getMonthlyTotalExpenses(userId);
  }

  Future<double> getMonthlyTotalExpenses(
    String userId, {
    DateTime? month,
  }) async {
    final targetMonth = month ?? DateTime.now();
    final docs = await getExpensesOnce(userId);
    double total = 0;

    for (final doc in docs) {
      final date = ExpenseDateUtils.parse(doc.data()['date']);
      if (date != null && ExpenseDateUtils.isInMonth(date, targetMonth)) {
        total += (doc.data()['amount'] as num?)?.toDouble() ?? 0;
      }
    }

    return total;
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
  getExpensesForMonth(
    String userId, {
    DateTime? month,
  }) async {
    final targetMonth = month ?? DateTime.now();
    final docs = await getExpensesOnce(userId);

    return docs.where((doc) {
      final date = ExpenseDateUtils.parse(doc.data()['date']);
      return date != null && ExpenseDateUtils.isInMonth(date, targetMonth);
    }).toList();
  }
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
  getRecentExpenses(String userId) async {
    final snapshot = await _firestore
        .collection('expenses')
        .where('userId', isEqualTo: userId)
        .get();

    final docs = snapshot.docs;

    docs.sort((a, b) {
      final dateA = ExpenseDateUtils.parse(a.data()['date']) ?? DateTime(1970);
      final dateB = ExpenseDateUtils.parse(b.data()['date']) ?? DateTime(1970);
      return dateB.compareTo(dateA);
    });

    return docs.take(5).toList();
  }
  Stream<List<ConversationModel>> getConversations(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('conversations')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ConversationModel.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<void> createConversation(
    String userId,
    String conversationId,
    String title,
  ) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('conversations')
        .doc(conversationId)
        .set(ConversationModel(
          id: conversationId,
          title: title,
          createdAt: DateTime.now(),
        ).toMap());
  }

  Future<void> updateConversationTitle(
    String userId,
    String conversationId,
    String title,
  ) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('conversations')
        .doc(conversationId)
        .update({'title': title});
  }

  Future<void> deleteConversation(String userId, String conversationId) async {
    final messagesRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('conversations')
        .doc(conversationId)
        .collection('messages');

    final messagesSnapshot = await messagesRef.get();
    final batch = _firestore.batch();
    for (final doc in messagesSnapshot.docs) {
      batch.delete(doc.reference);
    }
    
    final conversationDocRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('conversations')
        .doc(conversationId);
    batch.delete(conversationDocRef);

    await batch.commit();
  }

  Future<void> saveChatMessage(
    String userId,
    String conversationId,
    ChatMessageModel message,
  ) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .add(message.toMap());
  }

  Stream<List<ChatMessageModel>> getConversationMessages(
    String userId,
    String conversationId,
  ) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessageModel.fromMap(doc.data()))
            .toList());
  }

  Future<void> updateCategoryBudgets(
    String userId,
    Map<String, double> budgets,
  ) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .update({
      'categoryBudgets': budgets,
    });
  }

  Future<Map<String, double>> getCategorySpendingThisMonth(String userId) async {
    final docs = await getExpensesOnce(userId);
    final Map<String, double> spending = {};
    final now = DateTime.now();

    for (final doc in docs) {
      final date = ExpenseDateUtils.parse(doc.data()['date']);
      if (date == null || !ExpenseDateUtils.isInMonth(date, now)) continue;

      final category = doc.data()['category'] as String? ?? 'Other';
      final amount = (doc.data()['amount'] as num?)?.toDouble() ?? 0.0;
      spending[category] = (spending[category] ?? 0.0) + amount;
    }

    return spending;
  }

  // Recurring Expenses & Subscriptions
  Future<void> addRecurringExpense(String userId, RecurringExpenseModel model) async {
    final ref = _firestore
        .collection('users')
        .doc(userId)
        .collection('recurringExpenses');
    
    if (model.id.isEmpty) {
      final docRef = ref.doc();
      final finalModel = RecurringExpenseModel(
        id: docRef.id,
        title: model.title,
        amount: model.amount,
        category: model.category,
        dayOfMonth: model.dayOfMonth,
        createdAt: model.createdAt,
        userId: model.userId,
      );
      await docRef.set(finalModel.toMap());
    } else {
      await ref.doc(model.id).set(model.toMap());
    }
  }

  Stream<List<RecurringExpenseModel>> getRecurringExpenses(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('recurringExpenses')
        .orderBy('dayOfMonth')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RecurringExpenseModel.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<void> deleteRecurringExpense(String userId, String id) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('recurringExpenses')
        .doc(id)
        .delete();
  }

  Future<List<RecurringExpenseModel>> getRecurringExpensesOnce(
    String userId,
  ) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('recurringExpenses')
        .get();
    return snapshot.docs
        .map((doc) => RecurringExpenseModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> markSubscriptionPosted(
    String subscriptionId,
    String userId,
    String monthKey,
  ) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('recurringExpenses')
        .doc(subscriptionId)
        .update({'lastPostedMonth': monthKey});
  }

  Future<bool> hasSubscriptionExpenseThisMonth({
    required String userId,
    required String subscriptionId,
    required DateTime month,
  }) async {
    final docs = await getExpensesForMonth(userId, month: month);
    return docs.any(
      (doc) => doc.data()['subscriptionId'] == subscriptionId,
    );
  }

  // Gamified Challenges Helpers
  Future<List<Map<String, dynamic>>> getThisWeekExpenses(String userId) async {
    final docs = await getExpensesOnce(userId);
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfMonday = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

    return docs.where((doc) {
      final date = ExpenseDateUtils.parse(doc.data()['date']);
      if (date == null) return false;
      return date.isAfter(startOfMonday) || date.isAtSameMomentAs(startOfMonday);
    }).map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getLastWeekExpenses(String userId) async {
    final docs = await getExpensesOnce(userId);
    final now = DateTime.now();
    final startOfThisWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfMonday = DateTime(
      startOfThisWeek.year,
      startOfThisWeek.month,
      startOfThisWeek.day,
    );
    final startOfLastWeek = startOfMonday.subtract(const Duration(days: 7));
    final endOfLastWeek = startOfMonday.subtract(const Duration(milliseconds: 1));

    return docs.where((doc) {
      final date = ExpenseDateUtils.parse(doc.data()['date']);
      if (date == null) return false;
      return date.isAfter(startOfLastWeek.subtract(const Duration(milliseconds: 1))) &&
          date.isBefore(endOfLastWeek.add(const Duration(milliseconds: 1)));
    }).map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getThisWeekendExpenses(String userId) async {
    final docs = await getExpensesOnce(userId);
    final now = DateTime.now();
    
    // Find the Saturday of the current week
    int daysToSaturday = 6 - now.weekday;
    final saturday = now.add(Duration(days: daysToSaturday));
    final startOfSaturday = DateTime(saturday.year, saturday.month, saturday.day);
    
    final sunday = startOfSaturday.add(const Duration(days: 1));
    final endOfSunday = DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59, 999);

    return docs.where((doc) {
      final date = ExpenseDateUtils.parse(doc.data()['date']);
      if (date == null) return false;
      return date.isAfter(startOfSaturday.subtract(const Duration(milliseconds: 1))) &&
             date.isBefore(endOfSunday.add(const Duration(milliseconds: 1)));
    }).map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }
}