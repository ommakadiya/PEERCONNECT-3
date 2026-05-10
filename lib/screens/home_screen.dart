import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:peerconnect/providers/auth_provider.dart';
import 'package:peerconnect/providers/profile_provider.dart';
import 'package:peerconnect/models/mock_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peerconnect/models/user_model.dart';
import 'package:peerconnect/screens/profile_details_screen.dart';
import 'package:peerconnect/utils/constants.dart';
import 'package:peerconnect/models/ad.dart';
import 'package:peerconnect/screens/ad_details_screen.dart';
import 'package:peerconnect/models/group_model.dart';
import 'package:peerconnect/screens/group_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _showConnections = true; // true for individual connections, false for groups

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
    
    // Auto-seed mock data if database is empty
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndSeed();
    });
  }

  Future<void> _checkAndSeed() async {
    final auth = context.read<AuthProvider>();
    
    final List<UserModel> mockUsers = MockData.students.map((s) => UserModel(
      uid: s.id,
      name: '\${s.firstName} \${s.lastName}'.trim(),
      email: s.email,
      photoUrl: '',
      createdAt: DateTime.now(),
      firstName: s.firstName,
      middleName: s.middleName,
      lastName: s.lastName,
      phoneNumber: s.phoneNumber,
      originCity: s.originCity,
      migratedCity: s.migratedCity,
      migratedCountry: s.migratedCountry,
      educationCourse: s.educationCourse,
      specialization: s.specialization,
      collegeName: s.collegeName,
      jobType: s.jobType,
      jobCompany: s.jobCompany,
    )).toList();
    
    await auth.firestoreService.seedMockData(mockUsers);
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (ctx, auth, _) {
        final user = auth.user;
        final profileProv = context.watch<ProfileProvider>();

        if (user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed('/login');
          });
          return const SizedBox.shrink();
        }

        final String displayName = profileProv.displayName.isNotEmpty
            ? profileProv.displayName
            : (user.name.isNotEmpty ? user.name : 'User');
        final String displayEmail = profileProv.displayEmail.isNotEmpty
            ? profileProv.displayEmail
            : user.email;

        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: AppConstants.backgroundGradient,
          ),
          child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _header(context, auth, displayName),
                          const SizedBox(height: 32),
                          _profileCard(displayName, displayEmail, user.photoUrl),
                          const SizedBox(height: 24),
                          _toggleButton(),
                          const SizedBox(height: 16),
                          _showConnections ? _connectionsList() : _groupsList(),
                          const SizedBox(height: 24),
                          _recentActivity(),
                          const SizedBox(height: 24),
                          _adsGrid(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _header(BuildContext ctx, AuthProvider auth, String displayName) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
                style: TextStyle(fontSize: 12, color: AppConstants.textSecondary.withValues(alpha: 0.8)),
              ),
              Text(
                displayName.split(' ').first,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        _iconBtn(Icons.notifications_none_rounded, () {}),
        const SizedBox(width: 8),
        _iconBtn(Icons.logout_rounded, () => _confirmLogOut(ctx, auth)),
      ],
    );
  }

  Widget _iconBtn(IconData ic, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppConstants.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppConstants.primaryColor.withValues(alpha: 0.15),
        ),
      ),
      child: Icon(ic, color: AppConstants.textSecondary, size: 22),
    ),
  );

  Widget _toggleButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => setState(() => _showConnections = true),
          style: ElevatedButton.styleFrom(
            backgroundColor: _showConnections ? AppConstants.primaryColor : AppConstants.surfaceCard,
            foregroundColor: _showConnections ? AppConstants.textPrimary : AppConstants.textSecondary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Connections'),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () => setState(() => _showConnections = false),
          style: ElevatedButton.styleFrom(
            backgroundColor: !_showConnections ? AppConstants.primaryColor : AppConstants.surfaceCard,
            foregroundColor: !_showConnections ? AppConstants.textPrimary : AppConstants.textSecondary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Groups'),
        ),
      ],
    );
  }

  Widget _connectionsList() {
    final connectedIds = context.watch<ProfileProvider>().connectedIds;
    
    return FutureBuilder<List<UserModel>>(
      future: context.read<AuthProvider>().firestoreService.getAllUsers(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final connections = snapshot.data!.where((u) => connectedIds.contains(u.uid)).toList();
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Connected Peers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppConstants.textPrimary),
            ),
            const SizedBox(height: 12),
            if (connections.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('No connections yet. Visit Connections tab to network!', style: TextStyle(color: AppConstants.textSecondary)),
              ),
            ...connections.map((u) => Card(
              color: AppConstants.surfaceCard,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileDetailsScreen(
                    user: u,
                    isConnected: true,
                    onConnectToggle: () {
                      context.read<ProfileProvider>().removeConnection(u.uid);
                      // Update UI and state manually if needed
                    }
                  )));
                },
                leading: CircleAvatar(
                  backgroundColor: AppConstants.primaryColor,
                  child: Text(u.name.isNotEmpty ? u.name[0].toUpperCase() : '?', style: const TextStyle(color: AppConstants.textPrimary)),
                ),
                title: Text(u.name, style: const TextStyle(color: AppConstants.textPrimary)),
                subtitle: Text(u.educationCourse.isNotEmpty ? u.educationCourse : 'Student', style: const TextStyle(color: AppConstants.textSecondary)),
                trailing: const Icon(Icons.chevron_right, color: AppConstants.textMuted),
              ),
            )),
          ],
        );
      }
    );
  }

  Widget _groupsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Groups',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppConstants.textPrimary),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: AppConstants.primaryColor),
              onPressed: _showCreateGroupDialog,
              tooltip: 'Create Group',
            ),
          ],
        ),
        const SizedBox(height: 12),
        FutureBuilder(
          future: Future.wait([
            context.read<AuthProvider>().firestoreService.getAllUsers(),
            context.read<AuthProvider>().firestoreService.getManualGroups(),
          ]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            
            final allUsers = snapshot.data![0] as List<UserModel>;
            final manualGroupsData = snapshot.data![1] as List<Map<String, dynamic>>;
            
            final List<GroupModel> manualGroups = manualGroupsData.map((data) => GroupModel(
              groupId: data['id'],
              groupName: data['groupName'] ?? '',
              groupDescription: data['groupDescription'] ?? '',
              createdBy: data['createdBy'] ?? '',
              createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
              groupType: data['groupType'] ?? 'manual',
              similarityCategory: data['similarityCategory'] ?? '',
              members: (data['members'] as List<dynamic>? ?? []).map((e) => GroupMember.fromMap(e as Map<String, dynamic>)).toList(),
            )).toList();

            final autoGroups = _generateAutomaticGroups(allUsers);
            
            final List<GroupModel> allGroups = [...manualGroups, ...autoGroups];
            
            if (allGroups.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('No groups yet. Create one!', style: TextStyle(color: AppConstants.textSecondary)),
              );
            }

            return Column(
              children: allGroups.map((group) => Card(
                color: AppConstants.surfaceCard,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 0,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppConstants.primaryColor.withValues(alpha: 0.2)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: AppConstants.surfaceCardLight,
                      child: Icon(group.groupType == 'automatic' ? Icons.auto_awesome : Icons.group, color: AppConstants.primaryColor),
                    ),
                    title: Text(
                      group.groupName, 
                      style: const TextStyle(color: AppConstants.textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          group.groupDescription, 
                          style: const TextStyle(color: AppConstants.textSecondary, fontSize: 13),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              const Icon(Icons.people, size: 14, color: AppConstants.accentColor),
                              const SizedBox(width: 4),
                              Text('${group.members.length} Members', style: const TextStyle(color: AppConstants.textMuted, fontSize: 12)),
                              if (group.similarityCategory.isNotEmpty) ...[
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: AppConstants.surfaceCardLight, borderRadius: BorderRadius.circular(8)),
                                  child: Text(group.similarityCategory, style: const TextStyle(fontSize: 10, color: AppConstants.primaryColor)),
                                )
                              ]
                            ],
                          ),
                        )
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => GroupDetailsScreen(group: group)));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: const Text('View', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              )).toList(),
            );
          }
        ),
      ],
    );
  }

  List<GroupModel> _generateAutomaticGroups(List<UserModel> allUsers) {
    Map<String, List<UserModel>> groupsMap = {};

    for (var u in allUsers) {
      if (u.originCity.isNotEmpty) {
        groupsMap.putIfAbsent('${u.originCity} Students Network', () => []).add(u);
      }
      if (u.educationCourse.isNotEmpty) {
        groupsMap.putIfAbsent('${u.educationCourse} Community', () => []).add(u);
      }
      if (u.jobCompany.isNotEmpty) {
        groupsMap.putIfAbsent('${u.jobCompany} Student Developers', () => []).add(u);
      }
      if (u.migratedCity.isNotEmpty) {
        groupsMap.putIfAbsent('${u.migratedCity} Migrants Circle', () => []).add(u);
      }
    }

    List<GroupModel> autoGroups = [];
    groupsMap.forEach((name, members) {
      if (members.length > 2) {
        autoGroups.add(GroupModel(
          groupId: 'auto_\${name.replaceAll(" ", "_")}',
          groupName: name,
          groupDescription: 'Automatically generated group based on similarity.',
          createdBy: 'system',
          createdAt: DateTime.now(),
          groupType: 'automatic',
          similarityCategory: name.split(' ').first,
          members: members.map((m) => GroupMember(userId: m.uid, joinedAt: DateTime.now())).toList(),
        ));
      }
    });
    return autoGroups;
  }

  void _showCreateGroupDialog() {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppConstants.surfaceCard,
          title: const Text('Create Group', style: TextStyle(color: AppConstants.textPrimary)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: const TextStyle(color: AppConstants.textPrimary),
                decoration: const InputDecoration(labelText: 'Group Name', labelStyle: TextStyle(color: AppConstants.textSecondary)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                style: const TextStyle(color: AppConstants.textPrimary),
                decoration: const InputDecoration(labelText: 'Group Description', labelStyle: TextStyle(color: AppConstants.textSecondary)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: AppConstants.textMuted)),
            ),
            ElevatedButton(
              onPressed: () async {
                final authProv = context.read<AuthProvider>();
                final user = authProv.user;
                if (user != null && nameController.text.isNotEmpty) {
                  final groupData = {
                    'groupName': nameController.text.trim(),
                    'groupDescription': descController.text.trim(),
                    'createdBy': user.uid,
                    'createdAt': FieldValue.serverTimestamp(),
                    'groupType': 'manual',
                    'similarityCategory': 'Custom',
                    'members': [
                      {
                        'userId': user.uid,
                        'joinedAt': Timestamp.now(),
                      }
                    ],
                  };
                  await authProv.firestoreService.createGroup(groupData);
                  if (ctx.mounted) {
                    Navigator.pop(ctx);
                    setState(() {}); // Refresh future builder
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppConstants.primaryColor),
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  Widget _profileCard(String name, String email, String photoUrl) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppConstants.surfaceCard, AppConstants.surfaceCardLight],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppConstants.primaryColor.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppConstants.primaryColor, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: AppConstants.surfaceCardLight,
              backgroundImage: context.watch<ProfileProvider>().localPhotoPath != null
                  ? FileImage(File(context.watch<ProfileProvider>().localPhotoPath!)) as ImageProvider
                  : (photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null),
              child: (context.watch<ProfileProvider>().localPhotoPath == null && photoUrl.isEmpty)
                  ? Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppConstants.accentColor,
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppConstants.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppConstants.successColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '● Online',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppConstants.successColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _recentActivity() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppConstants.surfaceCard,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: AppConstants.primaryColor.withValues(alpha: 0.1),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppConstants.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Column(
            children: [
              Icon(
                Icons.history_rounded,
                size: 40,
                color: AppConstants.textMuted.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 8),
              const Text(
                'No recent activity',
                style: TextStyle(color: AppConstants.textMuted, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _adsGrid() {
    final List<Ad> dummyAds = [
      Ad(
        adId: '1',
        title: 'Premium Tools',
        description: 'Upgrade your workflow with our new toolkit.',
        targetCountry: 'Global',
        linkUrl: 'https://peerconnect.app/premium',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now(),
        likes: ['u1', 'u2'],
      ),
      Ad(
        adId: '2',
        title: 'Cloud Storage',
        description: 'Get 50% off annually on cloud storage.',
        targetCountry: 'USA',
        linkUrl: 'https://peerconnect.app/cloud',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 15)),
        createdAt: DateTime.now(),
        likes: ['u3'],
      ),
      Ad(
        adId: '3',
        title: 'Webinar',
        description: 'Mastering Networking in 2026.',
        targetCountry: 'Global',
        linkUrl: 'https://peerconnect.app/webinar',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 5)),
        createdAt: DateTime.now(),
        likes: [],
      ),
      Ad(
        adId: '4',
        title: 'Pro Insights',
        description: 'Data-driven tips for your career.',
        targetCountry: 'UK',
        linkUrl: 'https://peerconnect.app/insights',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 60)),
        createdAt: DateTime.now(),
        likes: ['u1', 'u4', 'u5'],
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sponsored',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppConstants.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: dummyAds.length,
          itemBuilder: (context, index) {
            return _adCard(dummyAds[index]);
          },
        ),
      ],
    );
  }

  Widget _adCard(Ad ad) {
    IconData getIconForAd(String title) {
      if (title.contains('Premium')) return Icons.star_rounded;
      if (title.contains('Cloud')) return Icons.cloud_done_rounded;
      if (title.contains('Webinar')) return Icons.video_call_rounded;
      return Icons.analytics_rounded;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AdDetailsScreen(ad: ad)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppConstants.surfaceCardLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppConstants.secondaryColor.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppConstants.secondaryColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                getIconForAd(ad.title),
                size: 28,
                color: AppConstants.secondaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              ad.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppConstants.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              ad.description,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppConstants.textSecondary,
                fontSize: 12,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppConstants.secondaryColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Ad',
                style: TextStyle(
                  color: AppConstants.backgroundColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogOut(BuildContext ctx, AuthProvider auth) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: AppConstants.surfaceCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Log Out',
          style: TextStyle(color: AppConstants.textPrimary),
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: AppConstants.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppConstants.textMuted),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              auth.signOut().then((_) {
                if (ctx.mounted) {
                  Navigator.of(ctx).pushReplacementNamed('/login');
                }
              });
            },
            child: const Text(
              'Log Out',
              style: TextStyle(color: AppConstants.errorColor),
            ),
          ),
        ],
      ),
    );
  }
}
