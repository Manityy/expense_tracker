import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

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
    final snapshot = await _firestore
        .collection('expenses')
        .where('userId', isEqualTo: userId)
        .get();

    double total = 0;

    for (final doc in snapshot.docs) {
      total += (doc['amount'] as num).toDouble();
    }

    return total;
  }
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
  getRecentExpenses(String userId) async {
    final snapshot = await _firestore
        .collection('expenses')
        .where('userId', isEqualTo: userId)
        .get();

    final docs = snapshot.docs;

    docs.sort(
          (a, b) => (b['date'] as String)
          .compareTo(a['date'] as String),
    );

    return docs.take(5).toList();
  }
}