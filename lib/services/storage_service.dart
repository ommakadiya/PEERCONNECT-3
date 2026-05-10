import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads a file to Firebase Storage and returns the download URL.
  Future<String?> uploadProfilePhoto(String userId, File file) async {
    try {
      final ref = _storage.ref().child('profile_photos').child('$userId.jpg');
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint('Error uploading profile photo: $e');
      return null;
    }
  }

  /// Removes a file from Firebase Storage.
  Future<void> deleteProfilePhoto(String userId) async {
    try {
      final ref = _storage.ref().child('profile_photos').child('$userId.jpg');
      await ref.delete();
    } catch (e) {
      debugPrint('Error deleting profile photo: $e');
    }
  }
}
