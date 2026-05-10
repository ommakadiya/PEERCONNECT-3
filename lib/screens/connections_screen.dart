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
      debugPrint('Error loading users: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
          (_searchQuery.isEmpty ||
              u.name.toLowerCase().contains(_searchQuery) ||
              u.firstName.toLowerCase().contains(_searchQuery) ||
              u.originCity.toLowerCase().contains(_searchQuery)))
      .toList();
  }

  List<UserModel> _getMyConnections(Set<String> connectedIds, String currentUserId) {
    return _allUsers
      .where((u) =>
          u.uid != currentUserId &&
          connectedIds.contains(u.uid) &&
          (_searchQuery.isEmpty ||
              u.name.toLowerCase().contains(_searchQuery) ||
              u.firstName.toLowerCase().contains(_searchQuery) ||
              u.originCity.toLowerCase().contains(_searchQuery)))
      .toList();
  }

  void _connect(UserModel user) async {
    final authProv = context.read<AuthProvider>();
    final profProv = context.read<ProfileProvider>();
    final currentUser = authProv.user;
    
    if (currentUser != null) {
      final newConnections = List<String>.from(currentUser.connectionIds)..add(user.uid);
      final updatedUser = currentUser.copyWith(connectionIds: newConnections);
      
      // Update UI state immediately for better UX
      profProv.addConnection(user.uid);
      
      // Persist and Sync
      await profProv.saveProfile(updatedUser);
      authProv.updateLocalUser(updatedUser);
      
      _showSnack('✅ Connected with ${user.firstName.isNotEmpty ? user.firstName : user.name}', AppConstants.successColor);
    }
  }

  void _disconnect(UserModel user) async {
    final authProv = context.read<AuthProvider>();
    final profProv = context.read<ProfileProvider>();
    final currentUser = authProv.user;
    
    if (currentUser != null) {
      final newConnections = List<String>.from(currentUser.connectionIds)..remove(user.uid);
      final updatedUser = currentUser.copyWith(connectionIds: newConnections);
      
      // Update UI state immediately
      profProv.removeConnection(user.uid);
      
      // Persist and Sync
      await profProv.saveProfile(updatedUser);
      authProv.updateLocalUser(updatedUser);
      
      _showSnack('Disconnected from ${user.firstName.isNotEmpty ? user.firstName : user.name}', AppConstants.errorColor);
    }
  }

  void _showSnack(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: AppConstants.textPrimary, fontWeight: FontWeight.w600),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showProfile(UserModel user, Set<String> connectedIds) {
    final isConnected = connectedIds.contains(user.uid);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileDetailsScreen(
          user: user,
          isConnected: isConnected,
          onConnectToggle: () {
            if (isConnected) {
              _disconnect(user);
            } else {
              _connect(user);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProv = context.watch<AuthProvider>();
    final currentUserId = authProv.user?.uid ?? '';
    // Use the actual connectionIds from the model
    final connectedIds = authProv.user?.connectionIds.toSet() ?? {};

    final recommendations = _getRecommendations(connectedIds, currentUserId);
    final myConnections = _getMyConnections(connectedIds, currentUserId);

    return Container(
      decoration: const BoxDecoration(color: AppConstants.backgroundColor),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Connections',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppConstants.textPrimary,
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Grow your peer network',
                              style: TextStyle(fontSize: 13, color: AppConstants.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: AppConstants.primaryGradient,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${myConnections.length} connected',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppConstants.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppConstants.surfaceCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppConstants.primaryColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: AppConstants.textPrimary, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Search by name, city...',
                        hintStyle: const TextStyle(color: AppConstants.textMuted, fontSize: 14),
                        prefixIcon: const Icon(Icons.search_rounded, color: AppConstants.textMuted, size: 20),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.close_rounded, color: AppConstants.textMuted, size: 18),
                                onPressed: () => _searchController.clear(),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppConstants.surfaceCard,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        gradient: AppConstants.primaryGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: AppConstants.textPrimary,
                      unselectedLabelColor: AppConstants.textSecondary,
                      labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(text: 'Discover (${recommendations.length})'),
                        Tab(text: 'My Network (${myConnections.length})'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: _isLoading 
                    ? const Center(child: CircularProgressIndicator())
                    : TabBarView(
                    controller: _tabController,
                    children: [
                      _UserList(
                        users: recommendations,
                        emptyMessage: _searchQuery.isEmpty
                            ? "You've connected with everyone! 🎉"
                            : 'No results for "$_searchQuery"',
                        isConnected: false,
                        onPrimary: _connect,
                        onCardTap: (u) => _showProfile(u, connectedIds),
                      ),
                      _UserList(
                        users: myConnections,
                        emptyMessage: _searchQuery.isEmpty
                            ? 'No connections yet. Start discovering!'
                            : 'No results for "$_searchQuery"',
                        isConnected: true,
                        onPrimary: _disconnect,
                        onCardTap: (u) => _showProfile(u, connectedIds),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserList extends StatelessWidget {
  final List<UserModel> users;
  final String emptyMessage;
  final bool isConnected;
  final ValueChanged<UserModel> onPrimary;
  final ValueChanged<UserModel> onCardTap;

  const _UserList({
    required this.users,
    required this.emptyMessage,
    required this.isConnected,
    required this.onPrimary,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isConnected ? Icons.people_outline_rounded : Icons.search_off_rounded,
              size: 56,
              color: AppConstants.textMuted,
            ),
            const SizedBox(height: 12),
            Text(
              emptyMessage,
              style: const TextStyle(color: AppConstants.textSecondary, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: users.length,
      itemBuilder: (context, index) {
        return _ConnectionCard(
          user: users[index],
          isConnected: isConnected,
          onPrimary: onPrimary,
          onTap: onCardTap,
        );
      },
    );
  }
}

class _ConnectionCard extends StatelessWidget {
  final UserModel user;
  final bool isConnected;
  final ValueChanged<UserModel> onPrimary;
  final ValueChanged<UserModel> onTap;

  const _ConnectionCard({
    required this.user,
    required this.isConnected,
    required this.onPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String displayName = user.firstName.isNotEmpty
        ? '${user.firstName} ${user.lastName}'.trim()
        : user.name;
    if (displayName.isEmpty) displayName = 'Unknown User';

    String displayRole = user.educationCourse.isNotEmpty
        ? user.educationCourse
        : 'Student';

    String location = user.originCity.isNotEmpty
        ? user.originCity
        : 'Unknown City';

    return GestureDetector(
      onTap: () => onTap(user),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppConstants.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isConnected
                ? AppConstants.primaryColor.withValues(alpha: 0.5)
                : AppConstants.surfaceCardLight,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: AppConstants.primaryColor,
                backgroundImage: user.photoUrl.isNotEmpty ? NetworkImage(user.photoUrl) : null,
                child: user.photoUrl.isEmpty ? Text(
                  displayName[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ) : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        color: AppConstants.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      displayRole,
                      style: const TextStyle(
                        color: AppConstants.accentColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded, size: 11, color: AppConstants.textMuted),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            location,
                            style: const TextStyle(color: AppConstants.textMuted, fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => onPrimary(user),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: isConnected ? null : AppConstants.primaryGradient,
                    color: isConnected ? AppConstants.surfaceCardLight : null,
                    borderRadius: BorderRadius.circular(20),
                    border: isConnected ? Border.all(color: AppConstants.primaryColor.withValues(alpha: 0.6)) : null,
                  ),
                  child: Text(
                    isConnected ? 'Connected' : 'Connect',
                    style: TextStyle(
                      color: isConnected ? AppConstants.textSecondary : Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
