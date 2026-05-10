import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../utils/constants.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProv = context.watch<AuthProvider>();
    final profProv = context.watch<ProfileProvider>();
    final user = authProv.user;
    
    if (user == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

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
          SingleChildScrollView(
            child: Column(
              children: [
                _buildPremiumHeader(context, user),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      _buildStatsSection(user),
                      const SizedBox(height: 32),
                      _buildSectionCard(
                        title: 'STUDENT IDENTITY',
                        icon: Icons.school_rounded,
                        onEdit: () => Navigator.pushNamed(context, '/edit-profile'),
                        children: [
                          _buildInfoRow(Icons.person_outline, 'Full Name', '${user.firstName} ${user.lastName}'),
                          _buildInfoRow(Icons.email_outlined, 'Academic Email', user.email),
                          _buildInfoRow(Icons.phone_outlined, 'Verified Phone', user.phoneNumber),
                          _buildInfoRow(Icons.location_on_outlined, 'Home Base', user.originCity),
                          _buildInfoRow(Icons.map_outlined, 'Global Residency', '${user.migratedCity}, ${user.migratedCountry}'),
                          _buildInfoRow(Icons.menu_book_rounded, 'Discipline', '${user.educationCourse} (${user.specialization})'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildSectionCard(
                        title: 'PARENTAL GUARDIAN',
                        icon: Icons.security_rounded,
                        onEdit: () => Navigator.pushNamed(context, '/edit-profile'),
                        badge: 'CONNECTED',
                        children: [
                          _buildInfoRow(Icons.person_outline, 'Guardian Name', '${user.parentDetails.firstName} ${user.parentDetails.lastName}'),
                          _buildInfoRow(Icons.phone_outlined, 'Emergency Contact', user.parentDetails.phoneNumber),
                          _buildInfoRow(Icons.work_outline_rounded, 'Occupation', user.parentDetails.occupation),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _buildSettingsSection(context),
                      const SizedBox(height: 40),
                      _buildLogoutButton(context, authProv),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumHeader(BuildContext context, UserModel user) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppConstants.primaryDark.withValues(alpha: 0.3),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 30), // Reduced top and bottom padding
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 120, // Reduced from 140
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppConstants.goldColor.withValues(alpha: 0.4), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.goldColor.withValues(alpha: 0.15),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 56, // Adjusted for 120 container
                backgroundColor: AppConstants.surfaceCard,
                backgroundImage: user.photoUrl.isNotEmpty ? NetworkImage(user.photoUrl) : null,
                child: user.photoUrl.isEmpty 
                  ? const Icon(Icons.person_rounded, size: 50, color: AppConstants.goldColor)
                  : null,
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: AppConstants.goldColor, shape: BoxShape.circle),
                  child: const Icon(Icons.edit_rounded, size: 14, color: AppConstants.backgroundColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16), // Reduced from 24
          Text(
            '${user.firstName} ${user.lastName}'.toUpperCase(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppConstants.textPrimary, letterSpacing: 1.5),
          ),
          const SizedBox(height: 4), // Reduced from 8
          Text(
            user.educationCourse.toUpperCase(),
            style: const TextStyle(fontSize: 11, color: AppConstants.goldColor, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(UserModel user) {
    return Row(
      children: [
        _buildStatCard('Network', '${user.connectionIds.length}', Icons.hub_outlined),
        const SizedBox(width: 12),
        _buildStatCard('Community', '12', Icons.public_outlined),
        const SizedBox(width: 12),
        _buildStatCard('Security', 'Elite', Icons.shield_outlined),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppConstants.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppConstants.goldColor.withValues(alpha: 0.05)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppConstants.goldColor, size: 24),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppConstants.textPrimary)),
            Text(label.toUpperCase(), style: const TextStyle(fontSize: 9, color: AppConstants.textSecondary, letterSpacing: 1)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title, 
    required IconData icon, 
    required List<Widget> children, 
    required VoidCallback onEdit,
    String? badge,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppConstants.surfaceCard,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppConstants.goldColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(icon, color: AppConstants.goldColor, size: 20),
                const SizedBox(width: 12),
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppConstants.textPrimary, letterSpacing: 1)),
                if (badge != null) ...[
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: AppConstants.goldColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
                    child: Text(badge, style: const TextStyle(fontSize: 9, color: AppConstants.goldColor, fontWeight: FontWeight.bold)),
                  ),
                ],
                const Spacer(),
                GestureDetector(
                  onTap: onEdit,
                  child: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppConstants.textMuted),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppConstants.primaryDark),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppConstants.goldColor.withValues(alpha: 0.5)),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, color: AppConstants.textSecondary, letterSpacing: 1)),
                const SizedBox(height: 4),
                Text(value.isEmpty ? '—' : value, 
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppConstants.textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.surfaceCard,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          _buildSettingsTile(Icons.notifications_active_outlined, 'System Notifications', () {}),
          _buildSettingsTile(Icons.lock_outline_rounded, 'Privacy & Encryption', () => Navigator.pushNamed(context, '/privacy')),
          _buildSettingsTile(Icons.info_outline_rounded, 'About Guardian Net', () => Navigator.pushNamed(context, '/about')),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppConstants.goldColor, size: 20),
      title: Text(title, style: const TextStyle(fontSize: 14, color: AppConstants.textPrimary, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppConstants.textMuted, size: 18),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AuthProvider auth) {
    return TextButton(
      onPressed: () => _showLogoutConfirmation(context, auth),
      child: const Text(
        'LOG OUT OF SECURE SESSION',
        style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1.5),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppConstants.surfaceCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Log Out', style: TextStyle(color: AppConstants.textPrimary, fontWeight: FontWeight.bold)),
        content: const Text('Confirm you wish to terminate the current session.', style: TextStyle(color: AppConstants.textSecondary)),
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
