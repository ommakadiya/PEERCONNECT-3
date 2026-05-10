import 'package:cloud_firestore/cloud_firestore.dart';

class GroupMember {
  final String userId;
  final DateTime joinedAt;

  const GroupMember({
    required this.userId,
    required this.joinedAt,
  });

  factory GroupMember.fromMap(Map<String, dynamic> data) {
    return GroupMember(
      userId: data['userId'] ?? '',
      joinedAt: (data['joinedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'joinedAt': Timestamp.fromDate(joinedAt),
    };
  }
}

class GroupModel {
  final String groupId;
  final String groupName;
  final String groupDescription;
  final String createdBy;
  final DateTime createdAt;
  final String groupType; // 'automatic' or 'manual'
  final String similarityCategory;
  final List<GroupMember> members;

  const GroupModel({
    required this.groupId,
    required this.groupName,
    required this.groupDescription,
    required this.createdBy,
    required this.createdAt,
    required this.groupType,
    this.similarityCategory = '',
    this.members = const [],
  });

  factory GroupModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return GroupModel.fromMap(data, doc.id);
  }

  factory GroupModel.fromMap(Map<String, dynamic> data, [String? id]) {
    final membersData = data['members'] as List<dynamic>? ?? [];
    return GroupModel(
      groupId: id ?? data['groupId'] ?? '',
      groupName: data['groupName'] ?? '',
      groupDescription: data['groupDescription'] ?? '',
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      groupType: data['groupType'] ?? 'manual',
      similarityCategory: data['similarityCategory'] ?? '',
      members: membersData.map((e) => GroupMember.fromMap(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'groupName': groupName,
      'groupDescription': groupDescription,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'groupType': groupType,
      'similarityCategory': similarityCategory,
      'members': members.map((e) => e.toMap()).toList(),
    };
  }
}
