import 'package:flutter/foundation.dart';
import 'package:peerconnect/models/user_model.dart';
import 'package:peerconnect/services/firestore_service.dart';
import 'package:peerconnect/services/storage_service.dart';
import 'dart:io';

export 'package:peerconnect/models/user_model.dart' show UserRole;

class ProfileProvider extends ChangeNotifier {
  final FirestoreService _firestoreService;
  final StorageService _storageService;

  String? _localPhotoPath;
  bool _isSaving = false;
  bool _isUploading = false;
  String? _saveError;
  final Set<String> _connectedIds = {};

  UserModel? _user;

  ProfileProvider({FirestoreService? firestoreService, StorageService? storageService})
      : _firestoreService = firestoreService ?? FirestoreService(),
        _storageService = storageService ?? StorageService();

  Set<String> get connectedIds => _connectedIds;
  UserModel? get user => _user;
  String? get localPhotoPath => _localPhotoPath;
  bool get isSaving => _isSaving;
  bool get isUploading => _isUploading;
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
      UserModel updatedUser = userModel;
      
      // Handle photo upload if local path exists
      if (_localPhotoPath != null) {
        _isUploading = true;
        notifyListeners();
        
        final downloadUrl = await _storageService.uploadProfilePhoto(userModel.uid, File(_localPhotoPath!));
        if (downloadUrl != null) {
          updatedUser = userModel.copyWith(photoUrl: downloadUrl);
          _localPhotoPath = null; // Clear local path after successful upload
        }
        _isUploading = false;
      }

      await _firestoreService.updateUser(updatedUser);
      _user = updatedUser;
    } catch (e) {
      _saveError = e.toString().replaceFirst('Exception: ', '');
      debugPrint('Firestore saveProfile error: $e');
    } finally {
      _isSaving = false;
      _isUploading = false;
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
