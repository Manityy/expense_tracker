import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import 'user_provider.dart';

final firestoreServiceProvider = Provider<FirestoreService>(
  (ref) => FirestoreService(),
);

final userModelStreamProvider = StreamProvider.autoDispose<UserModel?>((ref) {
  final uid = ref.watch(currentUserProvider)?.uid;
  if (uid == null) return Stream.value(null);

  return ref.watch(firestoreServiceProvider).getUserStream(uid).map((doc) {
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!);
  });
});

final expensesStreamProvider =
    StreamProvider.autoDispose<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
  (ref) {
    final uid = ref.watch(currentUserProvider)?.uid;
    if (uid == null) return Stream.value([]);

    return ref
        .watch(firestoreServiceProvider)
        .getUserExpenses(uid)
        .map((snapshot) => snapshot.docs);
  },
);
