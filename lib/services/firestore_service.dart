import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peerconnect/models/user_model.dart';

/// Handles all Cloud Firestore database operations.
///
/// This service encapsulates Firestore read/write logic,
/// keeping it completely separate from UI code.
class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Reference to the 'users' collection.
  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  /// Creates or updates a user document in Firestore.
  ///
  /// Uses `set` with merge to avoid overwriting existing data on repeat logins.
  Future<void> createUser(UserModel user) async {
    try {
      final docRef = _usersCollection.doc(user.uid);
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        // First-time login: create the user document
        await docRef.set(user.toFirestore());
      }
      // If document already exists, do nothing (preserve original createdAt)
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  /// Retrieves a user document by [uid].
  ///
  /// Returns null if the document does not exist.
  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _usersCollection.doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  /// Returns a real-time stream of the user document.
  Stream<UserModel?> userStream(String uid) {
    return _usersCollection.doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    });
  }
}
