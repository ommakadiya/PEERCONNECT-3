import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peerconnect/models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  Future<void> createUser(UserModel user) async {
    try {
      final docRef = _usersCollection.doc(user.uid);
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        await docRef.set(user.toFirestore());
      }
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

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

  Stream<UserModel?> userStream(String uid) {
    return _usersCollection.doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    });
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _usersCollection.doc(user.uid).update(user.toFirestore());
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      print('DEBUG: Fetched ${snapshot.docs.length} users from Firestore');
      return snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
    } catch (e) {
      print('ERROR: Failed to fetch users: $e');
      return [];
    }
  }

  // --- Groups ---

  Future<void> createGroup(Map<String, dynamic> groupData) async {
    try {
      await _firestore.collection('groups').add(groupData);
    } catch (e) {
      print('ERROR: Failed to create group: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getManualGroups() async {
    try {
      // Simplified query (removed orderBy) to avoid index requirement for now
      final snapshot = await _firestore
          .collection('groups')
          .where('groupType', isEqualTo: 'manual')
          .get();
      print('DEBUG: Fetched ${snapshot.docs.length} manual groups');
      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } catch (e) {
      print('ERROR: Failed to fetch manual groups: $e');
      return [];
    }
  }

  Future<void> joinGroup(String groupId, String userId) async {
    try {
      final doc = await _firestore.collection('groups').doc(groupId).get();
      if (!doc.exists) return;
      final data = doc.data()!;
      final members = List<dynamic>.from(data['members'] ?? []);
      
      if (!members.any((m) => m['userId'] == userId)) {
        members.add({
          'userId': userId,
          'joinedAt': Timestamp.now(),
        });
        await _firestore.collection('groups').doc(groupId).update({'members': members});
      }
    } catch (e) {
      print('Error joining group: $e');
    }
  }

  Future<void> seedMockData(List<UserModel> users) async {
    try {
      final snapshot = await _usersCollection.limit(10).get();
      // Only seed if we have very few users (e.g. less than 5)
      if (snapshot.docs.length < 5) {
        print('Database appears empty. Seeding mock data...');
        for (var user in users) {
          await _usersCollection.doc(user.uid).set(user.toFirestore());
        }
        print('Seeding complete.');
      }
    } catch (e) {
      print('Error seeding data: $e');
    }
  }
}
