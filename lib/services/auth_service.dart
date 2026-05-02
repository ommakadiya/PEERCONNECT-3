import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:peerconnect/utils/constants.dart';

/// Handles all Firebase Authentication operations.
///
/// This service encapsulates Google Sign-In and Firebase Auth logic,
/// keeping it completely separate from UI code.
class AuthService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthService({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(
          clientId: kIsWeb ? AppConstants.googleSignInWebClientId : null,
        );

  /// Returns the currently signed-in [User], or null.
  User? get currentUser => _firebaseAuth.currentUser;

  /// Stream of auth state changes (login / logout).
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Signs in with Google and returns the [UserCredential].
  ///
  /// Throws an [Exception] if the user cancels or if authentication fails.
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign-in was cancelled by the user.');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw Exception('Firebase Auth error: ${e.message}');
    } catch (e) {
      throw Exception('Sign-in failed: $e');
    }
  }

  /// Signs out of both Google and Firebase.
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw Exception('Sign-out failed: $e');
    }
  }
}
