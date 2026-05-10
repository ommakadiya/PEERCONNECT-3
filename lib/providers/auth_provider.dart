import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peerconnect/models/user_model.dart';
import 'package:peerconnect/services/auth_service.dart';
import 'package:peerconnect/services/firestore_service.dart';

/// Possible authentication states.
enum AuthStatus {
  uninitialized,
  authenticated,
  unauthenticated,
  authenticating,
  error,
}

/// Provider that manages authentication state and user data.
///
/// Acts as the bridge between services and UI — the UI never
/// touches [AuthService] or [FirestoreService] directly.
class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final FirestoreService _firestoreService;

  AuthStatus _status = AuthStatus.uninitialized;
  UserModel? _user;
  String? _errorMessage;
  bool _guestMode = false;

  AuthProvider({
    required AuthService authService,
    required FirestoreService firestoreService,
  })  : _authService = authService,
        _firestoreService = firestoreService {
    // Listen to Firebase auth state changes
    _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  // ── Getters ──────────────────────────────────────────────────────────

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  FirestoreService get firestoreService => _firestoreService;

  // ── Public Methods ───────────────────────────────────────────────────

  /// Initiates the Google Sign-In flow.
  Future<void> signInWithGoogle() async {
    try {
      _status = AuthStatus.authenticating;
      _errorMessage = null;
      notifyListeners();

      final userCredential = await _authService.signInWithGoogle();
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception('Authentication succeeded but user is null.');
      }

      // Build user model from Firebase user
      final userModel = UserModel(
        uid: firebaseUser.uid,
        name: firebaseUser.displayName ?? 'Anonymous',
        email: firebaseUser.email ?? '',
        photoUrl: firebaseUser.photoURL ?? '',
        createdAt: DateTime.now(),
      );

      // Save to Firestore on first login
      await _firestoreService.createUser(userModel);

      // Fetch the stored user data (preserves original createdAt)
      _user = await _firestoreService.getUser(firebaseUser.uid);
      _status = AuthStatus.authenticated;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _user = null;
    }
    notifyListeners();
  }

  /// Signs in as a guest for development or bypassing authentication.
  Future<void> signInAsGuest() async {
    _guestMode = true;
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));

    _user = UserModel(
      uid: 'guest_user',
      name: 'GuardianNet User',
      email: 'guest@guardiannet.app',
      photoUrl: '',
      createdAt: DateTime.now(),
    );
    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    _guestMode = false;
    try {
      await _authService.signOut();
      _user = null;
      _status = AuthStatus.unauthenticated;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    }
    notifyListeners();
  }

  /// Clears the current error message.
  void clearError() {
    _errorMessage = null;
    if (_status == AuthStatus.error) {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  /// Updates the local user model and notifies listeners.
  /// Useful when profile data is updated via ProfileProvider.
  void updateLocalUser(UserModel newUser) {
    _user = newUser;
    notifyListeners();
  }

  // ── Private Methods ──────────────────────────────────────────────────

  /// Called whenever the Firebase auth state changes.
  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (_guestMode) {
      return;
    }

    if (firebaseUser == null) {
      _status = AuthStatus.unauthenticated;
      _user = null;
    } else {
      // Fetch user data from Firestore
      _user = await _firestoreService.getUser(firebaseUser.uid);
      if (_user == null) {
        // User exists in Auth but not Firestore — create record
        final userModel = UserModel(
          uid: firebaseUser.uid,
          name: firebaseUser.displayName ?? 'Anonymous',
          email: firebaseUser.email ?? '',
          photoUrl: firebaseUser.photoURL ?? '',
          createdAt: DateTime.now(),
        );
        await _firestoreService.createUser(userModel);
        _user = userModel;
      }
      _status = AuthStatus.authenticated;
    }
    notifyListeners();
  }
}
