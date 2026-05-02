import 'package:flutter/material.dart';
import '../models/mock_data.dart';
import '../utils/constants.dart';

/// Standalone profile details screen (fallback for deep links).
/// Primary profile view is the glassmorphism modal in profile_modal.dart.
class ProfileDetailsScreen extends StatefulWidget {
  final ConnectionUser user;
  final bool initialIsConnected;
  final ValueChanged<bool> onConnectionStatusChanged;

  const ProfileDetailsScreen({
    super.key,
    required this.user,
    this.initialIsConnected = false,
    required this.onConnectionStatusChanged,
  });

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  late bool isConnected;

  @override
  void initState() {
    super.initState();
    isConnected = widget.initialIsConnected;
  }

  void _toggleConnection() {
    setState(() {
      isConnected = !isConnected;
    });
    widget.onConnectionStatusChanged(isConnected);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = widget.user;

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppConstants.surfaceCard,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          children: [
            // ══════════════════════════════════════
            //  HERO SECTION
            // ══════════════════════════════════════
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppConstants.surfaceCard,
                border: Border(
                  bottom: BorderSide(
                    color: AppConstants.primaryColor.withValues(alpha: 0.3),
                    width: 0.5,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppConstants.primaryColor,
                      child: Text(
                        user.name[0].toUpperCase(),
                        style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMd),

                    // Name
                    Text(
                      user.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppConstants.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),

                    // Location
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 14,
                          color: AppConstants.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          user.originCity,
                          style: theme.textTheme.bodySmall?.copyWith(color: AppConstants.textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Connect button
                    SizedBox(
                      width: 160,
                      height: 38,
                      child: ElevatedButton.icon(
                        onPressed: _toggleConnection,
                        icon: AnimatedSwitcher(
                          duration: AppConstants.animationFast,
                          child: Icon(
                            isConnected ? Icons.check_rounded : Icons.person_add_outlined,
                            key: ValueKey(isConnected),
                            size: 16,
                          ),
                        ),
                        label: AnimatedSwitcher(
                          duration: AppConstants.animationFast,
                          child: Text(
                            isConnected ? 'Connected' : '+ Connect',
                            key: ValueKey(isConnected),
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isConnected ? AppConstants.successColor : AppConstants.primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppConstants.borderRadiusSm),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppConstants.paddingSm),

            // ══════════════════════════════════════
            //  SECTION CARDS
            // ══════════════════════════════════════
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMd),
              child: Column(
                children: [
                  // ── 1. Basic Info ──
                  _SectionCard(
                    title: 'BASIC INFO',
                    theme: theme,
                    child: Column(
                      children: [
                        _InfoRow(label: 'Role', value: user.role, theme: theme),
                        _divider(),
                        _InfoRow(label: 'Company/School', value: user.company, theme: theme),
                        _divider(),
                        _InfoRow(label: 'City', value: user.originCity, theme: theme),
                        _divider(),
                        _InfoRow(label: 'Connections', value: user.connections.length.toString(), theme: theme),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingSm),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Thin divider ──
  Widget _divider() {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: AppConstants.primaryColor.withValues(alpha: 0.2),
    );
  }
}

// ══════════════════════════════════════════════════
//  REUSABLE SECTION CARD (compact)
// ══════════════════════════════════════════════════
class _SectionCard extends StatelessWidget {
  final String title;
  final ThemeData theme;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.theme,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: AppConstants.surfaceCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
        border: Border.all(
          color: AppConstants.primaryColor.withValues(alpha: 0.2),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelSmall?.copyWith(
              letterSpacing: 1.5,
              fontWeight: FontWeight.w600,
              color: AppConstants.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════
//  INFO ROW — label : value
// ══════════════════════════════════════════════════
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppConstants.textMuted,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppConstants.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
