import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadReceipt({
    required String userId,
    required File imageFile,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final ref = _storage.ref().child('receipts/$userId/$timestamp.jpg');
    await ref.putFile(imageFile);
    return ref.getDownloadURL();
  }
}
