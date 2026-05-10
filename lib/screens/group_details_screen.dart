import 'package:flutter/material.dart';
import 'package:peerconnect/models/group_model.dart';
import 'package:peerconnect/models/user_model.dart';
import 'package:peerconnect/services/firestore_service.dart';
import 'package:peerconnect/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:peerconnect/utils/constants.dart';

class GroupDetailsScreen extends StatefulWidget {
  final GroupModel group;

  const GroupDetailsScreen({super.key, required this.group});

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  bool _isLoading = true;
  List<UserModel> _allUsers = [];
  late GroupModel _currentGroup;

  @override
  void initState() {
    super.initState();
    _currentGroup = widget.group;
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final fs = context.read<AuthProvider>().firestoreService;
    final users = await fs.getAllUsers();
    
    if (_currentGroup.groupType == 'manual') {
      // For manual groups, reload from Firestore to get updated members
      final manualGroups = await fs.getManualGroups();
      final updatedGroupData = manualGroups.firstWhere((g) => g['id'] == _currentGroup.groupId, orElse: () => {});
      if (updatedGroupData.isNotEmpty) {
        // Build GroupModel using factory logic. We need a fake DocumentSnapshot or just manually parse
        // Because GroupModel.fromFirestore takes a DocumentSnapshot, we can just manually build it
        final membersData = updatedGroupData['members'] as List<dynamic>? ?? [];
        _currentGroup = GroupModel(
          groupId: updatedGroupData['id'],
          groupName: updatedGroupData['groupName'] ?? '',
          groupDescription: updatedGroupData['groupDescription'] ?? '',
          createdBy: updatedGroupData['createdBy'] ?? '',
          createdAt: updatedGroupData['createdAt']?.toDate() ?? DateTime.now(),
          groupType: updatedGroupData['groupType'] ?? 'manual',
          similarityCategory: updatedGroupData['similarityCategory'] ?? '',
          members: membersData.map((e) => GroupMember.fromMap(e as Map<String, dynamic>)).toList(),
        );
      }
    }
    
    setState(() {
      _allUsers = users;
      _isLoading = false;
    });
  }

  void _joinGroup() async {
    final authProv = context.read<AuthProvider>();
    if (authProv.user == null) return;
    
    setState(() => _isLoading = true);
    await authProv.firestoreService.joinGroup(_currentGroup.groupId, authProv.user!.uid);
    await _loadUsers(); // refresh
  }

  String _maskEmail(String email) {
    if (email.isEmpty) return 'N/A';
    final parts = email.split('@');
    if (parts.length != 2) return email;
    if (parts[0].length <= 2) return '${parts[0]}***@${parts[1]}';
    return '${parts[0].substring(0, 2)}***@${parts[1]}';
  }

  String _maskPhone(String phone) {
    if (phone.isEmpty) return 'N/A';
    if (phone.length <= 4) return phone;
    return '${phone.substring(0, phone.length - 4)}****';
  }

  @override
  Widget build(BuildContext context) {
    final authProv = context.watch<AuthProvider>();
    final currentUser = authProv.user;
    
    final memberIds = _currentGroup.members.map((m) => m.userId).toSet();
    final groupMembers = _allUsers.where((u) => memberIds.contains(u.uid)).toList();
    
    final isMember = currentUser != null && memberIds.contains(currentUser.uid);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Group Details', style: TextStyle(color: AppConstants.textPrimary, fontSize: 18)),
        backgroundColor: AppConstants.surfaceCard,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppConstants.textPrimary),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(AppConstants.paddingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(AppConstants.paddingLg),
                  decoration: BoxDecoration(
                    color: AppConstants.surfaceCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppConstants.primaryColor.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentGroup.groupName,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppConstants.textPrimary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _currentGroup.groupDescription,
                        style: const TextStyle(fontSize: 14, color: AppConstants.textSecondary),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.people, size: 16, color: AppConstants.accentColor),
                          const SizedBox(width: 6),
                          Text('${_currentGroup.members.length} Members', style: const TextStyle(color: AppConstants.textSecondary, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      if (_currentGroup.similarityCategory.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: AppConstants.surfaceCardLight, borderRadius: BorderRadius.circular(12)),
                          child: Text(_currentGroup.similarityCategory, style: const TextStyle(fontSize: 12, color: AppConstants.goldColor)),
                        )
                      ],
                      if (!isMember && _currentGroup.groupType == 'manual') ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _joinGroup,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppConstants.primaryColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Join Group', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        )
                      ]
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Members', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppConstants.textPrimary)),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: groupMembers.length,
                    itemBuilder: (context, index) {
                      final u = groupMembers[index];
                      // Privacy: if current user is not connected to 'u' and 'u' is not currentUser, mask details
                      bool isConnected = currentUser != null && (currentUser.connectionIds.contains(u.uid) || u.uid == currentUser.uid);
                      
                      String displayName = u.firstName.isNotEmpty ? '${u.firstName} ${u.lastName}'.trim() : u.name;
                      if (displayName.isEmpty) displayName = 'Unknown';
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppConstants.surfaceCard,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppConstants.primaryColor,
                              backgroundImage: u.photoUrl.isNotEmpty ? NetworkImage(u.photoUrl) : null,
                              child: u.photoUrl.isEmpty ? Text(displayName[0].toUpperCase(), style: const TextStyle(color: Colors.white)) : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(displayName, style: const TextStyle(color: AppConstants.textPrimary, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 4),
                                  Text(u.educationCourse.isNotEmpty ? u.educationCourse : 'Student', style: const TextStyle(color: AppConstants.accentColor, fontSize: 12)),
                                  const SizedBox(height: 4),
                                  Text(
                                    isConnected ? u.email : _maskEmail(u.email),
                                    style: const TextStyle(color: AppConstants.textMuted, fontSize: 12),
                                  ),
                                  Text(
                                    isConnected ? u.phoneNumber : _maskPhone(u.phoneNumber),
                                    style: const TextStyle(color: AppConstants.textMuted, fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
