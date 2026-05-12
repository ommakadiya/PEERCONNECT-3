import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { child, parent, none }

class ParentDetails {
  final String firstName;
  final String lastName;
  final String emailId;
  final String phoneNumber;
  final String originCity;
  final String occupation;
  final String address;

  const ParentDetails({
    this.firstName = '',
    this.lastName = '',
    this.emailId = '',
    this.phoneNumber = '',
    this.originCity = '',
    this.occupation = '',
    this.address = '',
  });

  factory ParentDetails.fromMap(Map<String, dynamic> data) {
    return ParentDetails(
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      emailId: data['emailId'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      originCity: data['originCity'] ?? '',
      occupation: data['occupation'] ?? '',
      address: data['address'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'emailId': emailId,
      'phoneNumber': phoneNumber,
      'originCity': originCity,
      'occupation': occupation,
      'address': address,
    };
  }
}

class RecommendationFields {
  final String originCity;
  final String migratedCity;
  final String migratedCountry;
  final String educationCourse;
  final String specialization;
  final String collegeName;
  final String jobType;
  final String jobCompany;
  final String parentOriginCity;
  final String parentOccupation;

  const RecommendationFields({
    this.originCity = '',
    this.migratedCity = '',
    this.migratedCountry = '',
    this.educationCourse = '',
    this.specialization = '',
    this.collegeName = '',
    this.jobType = '',
    this.jobCompany = '',
    this.parentOriginCity = '',
    this.parentOccupation = '',
  });

  factory RecommendationFields.fromUserAndParent(UserModel u, ParentDetails pd) {
    return RecommendationFields(
      originCity: u.originCity,
      migratedCity: u.migratedCity,
      migratedCountry: u.migratedCountry,
      educationCourse: u.educationCourse,
      specialization: u.specialization,
      collegeName: u.collegeName,
      jobType: u.jobType,
      jobCompany: u.jobCompany,
      parentOriginCity: pd.originCity,
      parentOccupation: pd.occupation,
    );
  }

  factory RecommendationFields.fromMap(Map<String, dynamic> data) {
    return RecommendationFields(
      originCity: data['originCity'] ?? '',
      migratedCity: data['migratedCity'] ?? '',
      migratedCountry: data['migratedCountry'] ?? '',
      educationCourse: data['educationCourse'] ?? '',
      specialization: data['specialization'] ?? '',
      collegeName: data['collegeName'] ?? '',
      jobType: data['jobType'] ?? '',
      jobCompany: data['jobCompany'] ?? '',
      parentOriginCity: data['parentOriginCity'] ?? '',
      parentOccupation: data['parentOccupation'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'originCity': originCity,
      'migratedCity': migratedCity,
      'migratedCountry': migratedCountry,
      'educationCourse': educationCourse,
      'specialization': specialization,
      'collegeName': collegeName,
      'jobType': jobType,
      'jobCompany': jobCompany,
      'parentOriginCity': parentOriginCity,
      'parentOccupation': parentOccupation,
    };
  }
}

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  final DateTime createdAt;
  final UserRole role;

  final String firstName;
  final String middleName;
  final String lastName;
  final String phoneNumber;
  final String originCity;
  final String migratedCity;
  final String migratedCountry;
  final String educationCourse;
  final String specialization;
  final String collegeName;
  final String jobType;
  final String jobCompany;

  final ParentDetails parentDetails;
  final List<String> connectionIds;
  final RecommendationFields recommendationFields;

  const UserModel({
    required this.uid,
    this.name = '',
    required this.email,
    required this.photoUrl,
    required this.createdAt,
    this.role = UserRole.none,
    this.firstName = '',
    this.middleName = '',
    this.lastName = '',
    this.phoneNumber = '',
    this.originCity = '',
    this.migratedCity = '',
    this.migratedCountry = '',
    this.educationCourse = '',
    this.specialization = '',
    this.collegeName = '',
    this.jobType = 'None',
    this.jobCompany = '',
    this.parentDetails = const ParentDetails(),
    this.connectionIds = const [],
    this.recommendationFields = const RecommendationFields(),
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    try {
      return UserModel(
        uid: doc.id,
        name: data['name'] ?? '',
        email: data['email'] ?? '',
        photoUrl: data['profilePhoto'] ?? data['photoUrl'] ?? '',
        createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        role: _roleFromString(data['role'] as String? ?? 'none'),
        firstName: data['firstName'] ?? '',
        middleName: data['middleName'] ?? '',
        lastName: data['lastName'] ?? '',
        phoneNumber: data['phoneNumber'] ?? '',
        originCity: data['originCity'] ?? '',
        migratedCity: data['migratedCity'] ?? '',
        migratedCountry: data['migratedCountry'] ?? '',
        educationCourse: data['educationCourse'] ?? '',
        specialization: data['specialization'] ?? '',
        collegeName: data['collegeName'] ?? '',
        jobType: data['jobType'] ?? 'None',
        jobCompany: data['jobCompany'] ?? '',
        parentDetails: ParentDetails.fromMap(data['parentDetails'] as Map<String, dynamic>? ?? {}),
        connectionIds: List<String>.from(data['connectionIds'] ?? []),
        recommendationFields: RecommendationFields.fromMap(data['recommendationFields'] as Map<String, dynamic>? ?? {}),
      );
    } catch (e) {
      print('PARSING ERROR on document ${doc.id}: $e');
      rethrow;
    }
  }

  static UserRole _roleFromString(String value) {
    switch (value) {
      case 'child': return UserRole.child;
      case 'parent': return UserRole.parent;
      default: return UserRole.none;
    }
  }

  static String _roleToString(UserRole role) {
    switch (role) {
      case UserRole.child: return 'child';
      case UserRole.parent: return 'parent';
      case UserRole.none: return 'none';
    }
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profilePhoto': photoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'role': _roleToString(role),
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'originCity': originCity,
      'migratedCity': migratedCity,
      'migratedCountry': migratedCountry,
      'educationCourse': educationCourse,
      'specialization': specialization,
      'collegeName': collegeName,
      'jobType': jobType,
      'jobCompany': jobCompany,
      'parentDetails': parentDetails.toMap(),
      'connectionIds': connectionIds,
      'recommendationFields': recommendationFields.toMap(),
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? photoUrl,
    DateTime? createdAt,
    UserRole? role,
    String? firstName,
    String? middleName,
    String? lastName,
    String? phoneNumber,
    String? originCity,
    String? migratedCity,
    String? migratedCountry,
    String? educationCourse,
    String? specialization,
    String? collegeName,
    String? jobType,
    String? jobCompany,
    ParentDetails? parentDetails,
    List<String>? connectionIds,
    RecommendationFields? recommendationFields,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      role: role ?? this.role,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      originCity: originCity ?? this.originCity,
      migratedCity: migratedCity ?? this.migratedCity,
      migratedCountry: migratedCountry ?? this.migratedCountry,
      educationCourse: educationCourse ?? this.educationCourse,
      specialization: specialization ?? this.specialization,
      collegeName: collegeName ?? this.collegeName,
      jobType: jobType ?? this.jobType,
      jobCompany: jobCompany ?? this.jobCompany,
      parentDetails: parentDetails ?? this.parentDetails,
      connectionIds: connectionIds ?? this.connectionIds,
      recommendationFields: recommendationFields ?? this.recommendationFields,
    );
  }

  @override
  String toString() => 'UserModel(uid: $uid, name: $name, email: $email, role: $role)';
}
