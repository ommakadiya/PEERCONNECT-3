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
  bool _showConnections = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.8, curve: Curves.easeOut)),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic)),
    );
    _controller.forward();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndSeed();
    });
  }

  Future<void> _checkAndSeed() async {
    final auth = context.read<AuthProvider>();
    final List<UserModel> mockUsers = MockData.students.map((s) => UserModel(
      uid: s.id,
      name: '${s.firstName} ${s.lastName}'.trim(),
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

        if (user == null) return const SizedBox.shrink();

        final String displayName = profileProv.displayName.isNotEmpty
            ? profileProv.displayName
            : (user.name.isNotEmpty ? user.name : 'User');
        final String displayEmail = profileProv.displayEmail.isNotEmpty
            ? profileProv.displayEmail
            : user.email;

        return Scaffold(
          backgroundColor: AppConstants.backgroundColor,
          body: Stack(
            children: [
              // Background Gradient
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppConstants.backgroundColor, AppConstants.primaryDark],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                          const SizedBox(height: 32),
                          _statisticsSection(),
                          const SizedBox(height: 32),
                          _toggleButton(),
                          const SizedBox(height: 20),
                          _showConnections ? _connectionsList() : _groupsList(),
                          const SizedBox(height: 32),
                          _adsGrid(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _header(BuildContext ctx, AuthProvider auth, String displayName) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back,',
              style: TextStyle(fontSize: 14, color: AppConstants.textSecondary, fontWeight: FontWeight.w500),
            ),
            Text(
              displayName.split(' ').first.toUpperCase(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AppConstants.textPrimary,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const Spacer(),
        _iconBtn(Icons.notifications_none_rounded, () {}),
        const SizedBox(width: 12),
        _iconBtn(Icons.logout_rounded, () => _confirmLogOut(ctx, auth), isDestructive: true),
      ],
    );
  }

  Widget _iconBtn(IconData ic, VoidCallback onTap, {bool isDestructive = false}) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppConstants.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDestructive ? Colors.redAccent.withValues(alpha: 0.2) : AppConstants.goldColor.withValues(alpha: 0.1),
        ),
      ),
      child: Icon(ic, color: isDestructive ? Colors.redAccent : AppConstants.goldColor, size: 22),
    ),
  );

  Widget _statisticsSection() {
    return Row(
      children: [
        _statItem('Network', '124', Icons.people_outline),
        const SizedBox(width: 16),
        _statItem('Groups', '8', Icons.groups_outlined),
        const SizedBox(width: 16),
        _statItem('Trust', '98%', Icons.verified_user_outlined),
      ],
    );
  }

  Widget _statItem(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppConstants.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppConstants.goldColor.withValues(alpha: 0.05)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppConstants.goldColor, size: 20),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppConstants.textPrimary)),
            Text(label, style: const TextStyle(fontSize: 10, color: AppConstants.textSecondary, letterSpacing: 1)),
          ],
        ),
      ),
    );
  }

  Widget _profileCard(String name, String email, String photoUrl) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppConstants.surfaceCard.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppConstants.goldColor.withValues(alpha: 0.15)),
        boxShadow: AppConstants.premiumShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [AppConstants.goldColor, AppConstants.goldLight]),
            ),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: AppConstants.primaryDark,
              backgroundImage: context.watch<ProfileProvider>().localPhotoPath != null
                  ? FileImage(File(context.watch<ProfileProvider>().localPhotoPath!)) as ImageProvider
                  : (photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null),
              child: (context.watch<ProfileProvider>().localPhotoPath == null && photoUrl.isEmpty)
                  ? Text(name[0].toUpperCase(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppConstants.goldColor))
                  : null,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppConstants.textPrimary)),
                const SizedBox(height: 4),
                Text(email, style: const TextStyle(fontSize: 13, color: AppConstants.textSecondary)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.verified, color: AppConstants.goldColor, size: 14),
                    const SizedBox(width: 6),
                    Text('Premium Member', style: TextStyle(fontSize: 11, color: AppConstants.goldColor, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleButton() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppConstants.surfaceCard,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          _toggleItem('Connections', _showConnections, () => setState(() => _showConnections = true)),
          _toggleItem('Groups', !_showConnections, () => setState(() => _showConnections = false)),
        ],
      ),
    );
  }

  Widget _toggleItem(String label, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? AppConstants.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            boxShadow: isActive ? AppConstants.goldShadow : [],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? AppConstants.textPrimary : AppConstants.textSecondary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
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
          children: connections.map((u) => _connectionTile(u)).toList(),
        );
      }
    );
  }

  Widget _connectionTile(UserModel u) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppConstants.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppConstants.goldColor.withValues(alpha: 0.05)),
      ),
      child: ListTile(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileDetailsScreen(user: u, isConnected: true))),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppConstants.surfaceCardLight,
          child: Text(u.name[0].toUpperCase(), style: const TextStyle(color: AppConstants.goldColor, fontWeight: FontWeight.bold)),
        ),
        title: Text(u.name, style: const TextStyle(color: AppConstants.textPrimary, fontWeight: FontWeight.bold)),
        subtitle: Text(u.educationCourse, style: const TextStyle(color: AppConstants.textSecondary, fontSize: 12)),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppConstants.goldColor),
      ),
    );
  }

  Widget _groupsList() {
    return FutureBuilder(
      future: Future.wait([
        context.read<AuthProvider>().firestoreService.getAllUsers(),
        context.read<AuthProvider>().firestoreService.getManualGroups(),
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final allUsers = snapshot.data![0] as List<UserModel>;
        final manualGroupsData = snapshot.data![1] as List<Map<String, dynamic>>;
        final List<GroupModel> manualGroups = manualGroupsData.map((data) => GroupModel.fromMap(data)).toList();
        final autoGroups = _generateAutomaticGroups(allUsers);
        final List<GroupModel> allGroups = [...manualGroups, ...autoGroups];

        return Column(
          children: allGroups.map((group) => _groupTile(group)).toList(),
        );
      }
    );
  }

  Widget _groupTile(GroupModel group) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppConstants.surfaceCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppConstants.goldColor.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppConstants.primaryDark, borderRadius: BorderRadius.circular(16)),
          child: Icon(group.groupType == 'automatic' ? Icons.auto_awesome : Icons.group, color: AppConstants.goldColor),
        ),
        title: Text(group.groupName, style: const TextStyle(color: AppConstants.textPrimary, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(group.groupDescription, style: const TextStyle(color: AppConstants.textSecondary, fontSize: 12), maxLines: 2),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.people, size: 14, color: AppConstants.goldColor),
                const SizedBox(width: 6),
                Text('${group.members.length} Members', style: const TextStyle(color: AppConstants.goldColor, fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: AppConstants.goldColor, size: 18),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GroupDetailsScreen(group: group))),
      ),
    );
  }

  List<GroupModel> _generateAutomaticGroups(List<UserModel> allUsers) {
    Map<String, List<UserModel>> groupsMap = {};
    for (var u in allUsers) {
      if (u.originCity.isNotEmpty) groupsMap.putIfAbsent('${u.originCity} Network', () => []).add(u);
      if (u.educationCourse.isNotEmpty) groupsMap.putIfAbsent('${u.educationCourse} Circle', () => []).add(u);
    }
    List<GroupModel> autoGroups = [];
    groupsMap.forEach((name, members) {
      if (members.length > 2) {
        autoGroups.add(GroupModel(
          groupId: 'auto_${name.replaceAll(" ", "_")}',
          groupName: name,
          groupDescription: 'Premium community for ${name.split(' ').first} students.',
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

  Widget _adsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.star_rounded, color: AppConstants.goldColor, size: 20),
            const SizedBox(width: 8),
            Text('PREMIUM OPPORTUNITIES', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppConstants.textPrimary, letterSpacing: 1.5)),
          ],
        ),
        const SizedBox(height: 16),
        // Simplified Horizontal Ad Scroll for luxury feel
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (ctx, index) => _premiumAdCard(index),
          ),
        ),
      ],
    );
  }

  Widget _premiumAdCard(int index) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.surfaceCardLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppConstants.goldColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppConstants.primaryDark, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.rocket_launch, color: AppConstants.goldColor, size: 20),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: AppConstants.goldColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
                child: const Text('PRO', style: TextStyle(color: AppConstants.goldColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const Spacer(),
          const Text('Premium Career Tools', style: TextStyle(color: AppConstants.textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
          Text('Enhance your professional visibility.', style: TextStyle(color: AppConstants.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }

  void _confirmLogOut(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppConstants.surfaceCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Confirm Log Out', style: TextStyle(color: AppConstants.textPrimary, fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to end your secure session?', style: TextStyle(color: AppConstants.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: AppConstants.textMuted))),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              auth.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: const Text('Log Out', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
