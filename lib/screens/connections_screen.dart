import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:peerconnect/providers/auth_provider.dart';
import 'package:peerconnect/providers/profile_provider.dart';
import 'package:peerconnect/models/user_model.dart';
import 'package:peerconnect/services/firestore_service.dart';
import 'package:peerconnect/utils/constants.dart';
import 'package:peerconnect/screens/profile_details_screen.dart';

class ConnectionsScreen extends StatefulWidget {
  const ConnectionsScreen({super.key});

  @override
  State<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<UserModel> _allUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase().trim());
    });
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final fs = FirestoreService();
      final users = await fs.getAllUsers();
      if (mounted) {
        setState(() {
          _allUsers = users;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<UserModel> _getRecommendations(Set<String> connectedIds, String currentUserId) {
    return _allUsers
      .where((u) =>
          u.uid != currentUserId &&
          !connectedIds.contains(u.uid) &&
          (_searchQuery.isEmpty || u.name.toLowerCase().contains(_searchQuery) || u.originCity.toLowerCase().contains(_searchQuery)))
      .toList();
  }

  List<UserModel> _getMyConnections(Set<String> connectedIds, String currentUserId) {
    return _allUsers
      .where((u) =>
          u.uid != currentUserId &&
          connectedIds.contains(u.uid) &&
          (_searchQuery.isEmpty || u.name.toLowerCase().contains(_searchQuery) || u.originCity.toLowerCase().contains(_searchQuery)))
      .toList();
  }

  void _connect(UserModel user) async {
    final authProv = context.read<AuthProvider>();
    final profProv = context.read<ProfileProvider>();
    final currentUser = authProv.user;
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(connectionIds: List<String>.from(currentUser.connectionIds)..add(user.uid));
      profProv.addConnection(user.uid);
      await profProv.saveProfile(updatedUser);
      authProv.updateLocalUser(updatedUser);
    }
  }

  void _disconnect(UserModel user) async {
    final authProv = context.read<AuthProvider>();
    final profProv = context.read<ProfileProvider>();
    final currentUser = authProv.user;
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(connectionIds: List<String>.from(currentUser.connectionIds)..remove(user.uid));
      profProv.removeConnection(user.uid);
      await profProv.saveProfile(updatedUser);
      authProv.updateLocalUser(updatedUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProv = context.watch<AuthProvider>();
    final currentUserId = authProv.user?.uid ?? '';
    final connectedIds = authProv.user?.connectionIds.toSet() ?? {};
    final recommendations = _getRecommendations(connectedIds, currentUserId);
    final myConnections = _getMyConnections(connectedIds, currentUserId);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildPremiumHeader(myConnections.length),
            _buildSearchBar(),
            const SizedBox(height: 16),
            _buildTabBar(recommendations.length, myConnections.length),
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: AppConstants.goldColor))
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _UserList(users: recommendations, emptyMessage: "No discoveries found.", isConnected: false, onPrimary: _connect),
                      _UserList(users: myConnections, emptyMessage: "No secure connections established.", isConnected: true, onPrimary: _disconnect),
                    ],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumHeader(int count) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ELITE NETWORK', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppConstants.goldColor, letterSpacing: 2)),
              const SizedBox(height: 4),
              Text('Global Access', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppConstants.textPrimary)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: AppConstants.goldColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppConstants.goldColor.withValues(alpha: 0.3))),
            child: Text('$count SECURE', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppConstants.goldColor, letterSpacing: 1)),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: AppConstants.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppConstants.goldColor.withValues(alpha: 0.1)),
        ),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(color: AppConstants.textPrimary, fontSize: 14),
          decoration: const InputDecoration(
            hintText: 'SEARCH BY NAME OR LOCATION...',
            hintStyle: TextStyle(color: AppConstants.textMuted, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
            prefixIcon: Icon(Icons.search_rounded, color: AppConstants.goldColor, size: 20),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(int recCount, int myCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppConstants.goldColor,
        indicatorWeight: 3,
        labelColor: AppConstants.goldColor,
        unselectedLabelColor: AppConstants.textSecondary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1),
        dividerColor: AppConstants.primaryDark,
        tabs: [
          Tab(text: 'DISCOVER ($recCount)'),
          Tab(text: 'MY NETWORK ($myCount)'),
        ],
      ),
    );
  }
}

class _UserList extends StatelessWidget {
  final List<UserModel> users;
  final String emptyMessage;
  final bool isConnected;
  final ValueChanged<UserModel> onPrimary;

  const _UserList({required this.users, required this.emptyMessage, required this.isConnected, required this.onPrimary});

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return Center(child: Text(emptyMessage, style: const TextStyle(color: AppConstants.textMuted, fontSize: 13, fontWeight: FontWeight.bold)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: users.length,
      itemBuilder: (context, index) => _ConnectionCard(user: users[index], isConnected: isConnected, onPrimary: onPrimary),
    );
  }
}

class _ConnectionCard extends StatelessWidget {
  final UserModel user;
  final bool isConnected;
  final ValueChanged<UserModel> onPrimary;

  const _ConnectionCard({required this.user, required this.isConnected, required this.onPrimary});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppConstants.surfaceCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppConstants.goldColor.withValues(alpha: 0.1)),
        boxShadow: AppConstants.premiumShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppConstants.premiumGradient),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: AppConstants.backgroundColor,
                backgroundImage: user.photoUrl.isNotEmpty ? NetworkImage(user.photoUrl) : null,
                child: user.photoUrl.isEmpty ? Text(user.name[0].toUpperCase(), style: const TextStyle(color: AppConstants.goldColor, fontWeight: FontWeight.bold)) : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name, style: const TextStyle(color: AppConstants.textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(user.educationCourse.toUpperCase(), style: const TextStyle(color: AppConstants.goldColor, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, size: 10, color: AppConstants.textMuted),
                      const SizedBox(width: 4),
                      Text(user.originCity, style: const TextStyle(color: AppConstants.textMuted, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => onPrimary(user),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: isConnected ? null : AppConstants.premiumGradient,
                  color: isConnected ? AppConstants.primaryDark : null,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  isConnected ? 'SECURED' : 'CONNECT',
                  style: TextStyle(color: isConnected ? AppConstants.textSecondary : AppConstants.backgroundColor, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
