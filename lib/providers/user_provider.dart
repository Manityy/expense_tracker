import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final currentUserProvider = Provider<User?>((ref) {
  return FirebaseAuth.instance.currentUser;
});