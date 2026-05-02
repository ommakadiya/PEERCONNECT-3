import 'package:flutter/foundation.dart';

/// Represents the user's chosen role.
enum UserRole { child, parent, none }

/// Model for child/student profile details.
class ChildProfile {
  final String name;
  final String email;
  final String originCity;
  final String migratedCity;
  final String migratedCountry;
  final String phone;
  final String address;
  final String occupation;
  final String parentName;
  final String parentEmail;

  const ChildProfile({
    required this.name,
    required this.email,
    required this.originCity,
    required this.migratedCity,
    required this.migratedCountry,
    required this.phone,
    required this.address,
    required this.occupation,
    required this.parentName,
    required this.parentEmail,
  });
}

/// Model for a single parent entry.
class ParentEntry {
  final String name;
  final String email;
  final String originCity;
  final String phone;
  final String address;
  final String occupation;
  final String childEmail;

  const ParentEntry({
    required this.name,
    required this.email,
    required this.originCity,
    required this.phone,
    required this.address,
    required this.occupation,
    required this.childEmail,
  });
}

/// Provider that stores the user's role and profile details.
///
/// Data is kept in memory for this session. Wire to Firestore as needed.
class ProfileProvider extends ChangeNotifier {
  UserRole _role = UserRole.none;
  ChildProfile? _childProfile;
  List<ParentEntry> _parentEntries = [];

  final Set<String> _connectedIds = {'p2', 'p3'};

  // ── Getters ──────────────────────────────────────────────────────────
  UserRole get role => _role;
  ChildProfile? get childProfile => _childProfile;
  List<ParentEntry> get parentEntries => _parentEntries;
  Set<String> get connectedIds => _connectedIds;

  bool get hasProfile =>
      _role != UserRole.none &&
      (_childProfile != null || _parentEntries.isNotEmpty);

  /// Display name for the profile header.
  String get displayName {
    if (_role == UserRole.child) return _childProfile?.name ?? '';
    if (_role == UserRole.parent && _parentEntries.isNotEmpty) {
      return _parentEntries.first.name;
    }
    return '';
  }

  /// Display email for the profile header.
  String get displayEmail {
    if (_role == UserRole.child) return _childProfile?.email ?? '';
    if (_role == UserRole.parent && _parentEntries.isNotEmpty) {
      return _parentEntries.first.email;
    }
    return '';
  }

  // ── Mutations ─────────────────────────────────────────────────────────

  void setRole(UserRole role) {
    _role = role;
    notifyListeners();
  }

  void saveChildProfile(ChildProfile profile) {
    _role = UserRole.child;
    _childProfile = profile;
    notifyListeners();
  }

  void saveParentProfile(List<ParentEntry> entries) {
    _role = UserRole.parent;
    _parentEntries = entries;
    notifyListeners();
  }

  void clearProfile() {
    _role = UserRole.none;
    _childProfile = null;
    _parentEntries = [];
    _connectedIds.clear();
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
}
