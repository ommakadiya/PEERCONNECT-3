import 'package:flutter/foundation.dart';
import 'package:peerconnect/models/user_model.dart';
import 'package:peerconnect/services/firestore_service.dart';

export 'package:peerconnect/models/user_model.dart' show UserRole;

class ProfileProvider extends ChangeNotifier {
  final FirestoreService _firestoreService;

  String? _localPhotoPath;
  bool _isSaving = false;
  String? _saveError;
  final Set<String> _connectedIds = {};

  UserModel? _user;

  ProfileProvider({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  Set<String> get connectedIds => _connectedIds;
  String? get localPhotoPath => _localPhotoPath;
  bool get isSaving => _isSaving;
  String? get saveError => _saveError;

  void setUser(UserModel user) {
    _user = user;
    _connectedIds.clear();
    _connectedIds.addAll(user.connectionIds);
    notifyListeners();
  }

  String get displayName {
    if (_user != null) {
      if (_user!.firstName.isNotEmpty) {
        return '${_user!.firstName} ${_user!.lastName}'.trim();
      }
      return _user!.name;
    }
    return '';
  }

  String get displayEmail {
    if (_user != null) {
      if (_user!.email.isNotEmpty) {
        return _user!.email;
      }
    }
    return '';
  }

  Future<void> saveProfile(UserModel userModel) async {
    _isSaving = true;
    _saveError = null;
    notifyListeners();

    try {
      await _firestoreService.updateUser(userModel);
      _user = userModel;
    } catch (e) {
      _saveError = e.toString().replaceFirst('Exception: ', '');
      debugPrint('Firestore saveProfile error: $e');
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  void clearProfile() {
    _user = null;
    _connectedIds.clear();
    _localPhotoPath = null;
    _saveError = null;
    notifyListeners();
  }

  void setLocalPhotoPath(String path) {
    _localPhotoPath = path;
    notifyListeners();
  }

  void addConnection(String id) {
    _connectedIds.add(id);
    notifyListeners();
  }

  void removeConnection(String id) {
    _connectedIds.remove(id);
    notifyListeners();
  }

  void clearSaveError() {
    _saveError = null;
    notifyListeners();
  }
}
