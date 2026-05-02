import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:peerconnect/providers/profile_provider.dart';
import 'package:peerconnect/models/mock_data.dart';
import 'package:peerconnect/utils/constants.dart';

class ConnectionsScreen extends StatefulWidget {
  const ConnectionsScreen({super.key});

  @override
  State<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen>
    with SingleTickerProviderStateMixin {
  // ── State ──────────────────────────────────────────────────────────────
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Using parent "p1" as the logged-in mock user.
  static const String _currentUserId = 'p1';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase().trim());
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // ── Computed lists ─────────────────────────────────────────────────────
  List<ConnectionUser> _getRecommendations(Set<String> connectedIds) {
    return MockData.allUsers
      .where((u) =>
          u.id != _currentUserId &&
          !connectedIds.contains(u.id) &&
          (_searchQuery.isEmpty ||
              u.name.toLowerCase().contains(_searchQuery) ||
              u.role.toLowerCase().contains(_searchQuery) ||
              u.company.toLowerCase().contains(_searchQuery) ||
              u.originCity.toLowerCase().contains(_searchQuery)))
      .toList();
  }

  List<ConnectionUser> _getMyConnections(Set<String> connectedIds) {
    return MockData.allUsers
      .where((u) =>
          connectedIds.contains(u.id) &&
          (_searchQuery.isEmpty ||
              u.name.toLowerCase().contains(_searchQuery) ||
              u.role.toLowerCase().contains(_searchQuery) ||
              u.company.toLowerCase().contains(_searchQuery) ||
              u.originCity.toLowerCase().contains(_searchQuery)))
      .toList();
  }

  // ── Actions ────────────────────────────────────────────────────────────
  void _connect(ConnectionUser user) {
    context.read<ProfileProvider>().addConnection(user.id);
    _showSnack('✅ Connected with ${user.name}', AppConstants.successColor);
  }

  void _disconnect(ConnectionUser user) {
    context.read<ProfileProvider>().removeConnection(user.id);
    _showSnack('Disconnected from ${user.name}', AppConstants.errorColor);
  }

  void _showSnack(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showProfile(ConnectionUser user, Set<String> connectedIds) {
    final isConnected = connectedIds.contains(user.id);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _ProfileSheet(
        user: user,
        isConnected: isConnected,
        onConnect: () {
          Navigator.pop(context);
          _connect(user);
        },
        onDisconnect: () {
          Navigator.pop(context);
          _disconnect(user);
        },
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final connectedIds = context.watch<ProfileProvider>().connectedIds;
    final recommendations = _getRecommendations(connectedIds);
    final myConnections = _getMyConnections(connectedIds);
    return Container(
      decoration: const BoxDecoration(gradient: AppConstants.backgroundGradient),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            // ── Header ────────────────────────────────────────────────
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
                          style: TextStyle(
                              fontSize: 13,
                              color: AppConstants.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: AppConstants.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${connectedIds.length} connected',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Search ────────────────────────────────────────────────
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
                  style: const TextStyle(
                      color: AppConstants.textPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search by name, role, city…',
                    hintStyle: const TextStyle(
                        color: AppConstants.textMuted, fontSize: 14),
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: AppConstants.textMuted, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded,
                                color: AppConstants.textMuted, size: 18),
                            onPressed: () => _searchController.clear(),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Tab bar ───────────────────────────────────────────────
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
                  labelColor: Colors.white,
                  unselectedLabelColor: AppConstants.textSecondary,
                  labelStyle: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 13),
                  unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 13),
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(text: 'Discover (${recommendations.length})'),
                    Tab(text: 'My Network (${myConnections.length})'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Tab content ───────────────────────────────────────────
            Expanded(
              child: TabBarView(
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

// ── Reusable list widget ──────────────────────────────────────────────────
class _UserList extends StatelessWidget {
  final List<ConnectionUser> users;
  final String emptyMessage;
  final bool isConnected;
  final ValueChanged<ConnectionUser> onPrimary;
  final ValueChanged<ConnectionUser> onCardTap;

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
              isConnected
                  ? Icons.people_outline_rounded
                  : Icons.search_off_rounded,
              size: 56,
              color: AppConstants.textMuted,
            ),
            const SizedBox(height: 12),
            Text(
              emptyMessage,
              style: const TextStyle(
                  color: AppConstants.textSecondary, fontSize: 15),
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

// ── Connection card ───────────────────────────────────────────────────────
class _ConnectionCard extends StatefulWidget {
  final ConnectionUser user;
  final bool isConnected;
  final ValueChanged<ConnectionUser> onPrimary;
  final ValueChanged<ConnectionUser> onTap;

  const _ConnectionCard({
    required this.user,
    required this.isConnected,
    required this.onPrimary,
    required this.onTap,
  });

  @override
  State<_ConnectionCard> createState() => _ConnectionCardState();
}

class _ConnectionCardState extends State<_ConnectionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _press;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween<double>(begin: 1.0, end: 0.97)
        .animate(CurvedAnimation(parent: _press, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  Color get _avatarColor {
    const palette = [
      AppConstants.primaryColor,
      AppConstants.secondaryColor,
      Color(0xFF1A5E3A),
      Color(0xFF2A7A4A),
      Color(0xFF0D3D1C),
    ];
    return palette[widget.user.id.hashCode.abs() % palette.length];
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTapDown: (_) => _press.forward(),
        onTapUp: (_) {
          _press.reverse();
          widget.onTap(widget.user);
        },
        onTapCancel: () => _press.reverse(),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppConstants.surfaceCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isConnected
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
                // Avatar
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        _avatarColor,
                        _avatarColor.withValues(alpha: 0.6)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.user.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.name,
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
                        widget.user.role,
                        style: const TextStyle(
                          color: AppConstants.accentColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded,
                              size: 11,
                              color: AppConstants.textMuted),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              '${widget.user.originCity} · ${widget.user.company}',
                              style: const TextStyle(
                                  color: AppConstants.textMuted,
                                  fontSize: 11),
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
                // Button
                _ActionButton(
                  isConnected: widget.isConnected,
                  onPressed: () => widget.onPrimary(widget.user),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Action button ─────────────────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final bool isConnected;
  final VoidCallback onPressed;

  const _ActionButton({required this.isConnected, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: isConnected ? null : AppConstants.primaryGradient,
          color: isConnected ? AppConstants.surfaceCardLight : null,
          borderRadius: BorderRadius.circular(20),
          border: isConnected
              ? Border.all(
                  color:
                      AppConstants.primaryColor.withValues(alpha: 0.6))
              : null,
        ),
        child: Text(
          isConnected ? 'Connected' : 'Connect',
          style: TextStyle(
            color: isConnected
                ? AppConstants.textSecondary
                : Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ── Profile bottom sheet ──────────────────────────────────────────────────
class _ProfileSheet extends StatelessWidget {
  final ConnectionUser user;
  final bool isConnected;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  const _ProfileSheet({
    required this.user,
    required this.isConnected,
    required this.onConnect,
    required this.onDisconnect,
  });

  Color _avatarColor() {
    const palette = [
      AppConstants.primaryColor,
      AppConstants.secondaryColor,
      Color(0xFF1A5E3A),
      Color(0xFF2A7A4A),
    ];
    return palette[user.id.hashCode.abs() % palette.length];
  }

  @override
  Widget build(BuildContext context) {
    final ac = _avatarColor();
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
      decoration: const BoxDecoration(
        color: AppConstants.surfaceCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppConstants.textMuted.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          // Avatar
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [ac, ac.withValues(alpha: 0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: ac.withValues(alpha: 0.4),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                user.name[0].toUpperCase(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.name,
            style: const TextStyle(
              color: AppConstants.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.role,
            style: const TextStyle(
              color: AppConstants.accentColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          // Info chips
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(
                  icon: Icons.business_rounded, label: user.company),
              _InfoChip(
                  icon: Icons.location_city_rounded,
                  label: user.originCity),
              _InfoChip(
                icon: Icons.people_rounded,
                label: '${user.connections.length} connections',
              ),
            ],
          ),
          const SizedBox(height: 28),
          // CTA
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isConnected ? onDisconnect : onConnect,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: isConnected
                    ? AppConstants.surfaceCardLight
                    : AppConstants.primaryColor,
                foregroundColor: isConnected
                    ? AppConstants.textSecondary
                    : Colors.white,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: isConnected
                      ? const BorderSide(color: AppConstants.primaryColor)
                      : BorderSide.none,
                ),
              ),
              child: Text(
                isConnected ? 'Disconnect' : 'Connect',
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppConstants.surfaceCardLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: AppConstants.primaryColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppConstants.accentColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: AppConstants.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
