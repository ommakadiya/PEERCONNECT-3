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
    
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildPremiumHeader(context, user),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingLg),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  _buildStatsSection(user),
                  const SizedBox(height: 24),
                  _buildSectionCard(
                    title: 'Student Details',
                    icon: Icons.school_rounded,
                    onEdit: () => Navigator.pushNamed(context, '/edit-profile'),
                    children: [
                      _buildInfoRow(Icons.person_outline, 'Full Name', '${user.firstName} ${user.lastName}'),
                      _buildInfoRow(Icons.email_outlined, 'Email', user.email),
                      _buildInfoRow(Icons.phone_outlined, 'Phone', user.phoneNumber),
                      _buildInfoRow(Icons.location_on_outlined, 'Origin', user.originCity),
                      _buildInfoRow(Icons.map_outlined, 'Current Location', '${user.migratedCity}, ${user.migratedCountry}'),
                      _buildInfoRow(Icons.menu_book_rounded, 'Course', '${user.educationCourse} (${user.specialization})'),
                      _buildInfoRow(Icons.apartment_rounded, 'College', user.collegeName),
                      _buildInfoRow(Icons.work_outline_rounded, 'Job Status', '${user.jobType} at ${user.jobCompany}'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSectionCard(
                    title: 'Parent Details',
                    icon: Icons.family_restroom_rounded,
                    onEdit: () => Navigator.pushNamed(context, '/edit-profile'),
                    badge: 'Connected',
                    children: [
                      _buildInfoRow(Icons.person_outline, 'Parent Name', '${user.parentDetails.firstName} ${user.parentDetails.lastName}'),
                      _buildInfoRow(Icons.phone_outlined, 'Phone', user.parentDetails.phoneNumber),
                      _buildInfoRow(Icons.work_outline_rounded, 'Occupation', user.parentDetails.occupation),
                      _buildInfoRow(Icons.home_outlined, 'Home Address', user.parentDetails.address),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSettingsSection(context),
                  const SizedBox(height: 32),
                  _buildLogoutButton(context, authProv),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumHeader(BuildContext context, UserModel user) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppConstants.primaryGradient,
      ),
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 40),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppConstants.premiumGold.withValues(alpha: 0.5), width: 3),
                ),
              ),
              CircleAvatar(
                radius: 60,
                backgroundColor: AppConstants.warmBeige,
                backgroundImage: user.photoUrl.isNotEmpty ? NetworkImage(user.photoUrl) : null,
                child: user.photoUrl.isEmpty 
                  ? Text(user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : '?', 
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: AppConstants.forestGreen))
                  : null,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '${user.firstName} ${user.lastName}',
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppConstants.warmBeige),
          ),
          const SizedBox(height: 8),
          Text(
            user.educationCourse.isNotEmpty ? user.educationCourse : 'Update your course',
            style: const TextStyle(fontSize: 15, color: AppConstants.premiumGold, fontWeight: FontWeight.bold),
          ),
          Text(
            '${user.migratedCity}, ${user.migratedCountry}',
            style: TextStyle(fontSize: 14, color: AppConstants.warmBeige.withValues(alpha: 0.8)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(UserModel user) {
    return Row(
      children: [
        _buildStatCard('Connections', '${user.connectionIds.length}', Icons.people_outline),
        const SizedBox(width: 12),
        _buildStatCard('Groups', '4', Icons.groups_outlined), // Placeholder
        const SizedBox(width: 12),
        _buildStatCard('Safety Score', '98%', Icons.verified_user_outlined),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppConstants.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppConstants.primaryColor.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppConstants.primaryColor, size: 20),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppConstants.textPrimary)),
            Text(label, style: const TextStyle(fontSize: 10, color: AppConstants.textMuted)),
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
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppConstants.primaryColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 12, 12),
            child: Row(
              children: [
                Icon(icon, color: AppConstants.primaryColor, size: 22),
                const SizedBox(width: 12),
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppConstants.textPrimary)),
                if (badge != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: AppConstants.successColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
                    child: Text(badge, style: const TextStyle(fontSize: 10, color: AppConstants.successColor, fontWeight: FontWeight.bold)),
                  ),
                ],
                const Spacer(),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 18, color: AppConstants.textSecondary),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppConstants.lightSand),
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
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppConstants.surfaceCardLight, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 16, color: AppConstants.secondaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 11, color: AppConstants.textMuted)),
                Text(value.isEmpty ? 'Not set' : value, 
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppConstants.textPrimary)),
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
          _buildSettingsTile(Icons.notifications_outlined, 'Notifications', () {}),
          _buildSettingsTile(Icons.security_outlined, 'Security & Password', () {}),
          _buildSettingsTile(Icons.privacy_tip_outlined, 'Privacy Policy', () => Navigator.pushNamed(context, '/privacy')),
          _buildSettingsTile(Icons.info_outline_rounded, 'About Guardian Net', () => Navigator.pushNamed(context, '/about')),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppConstants.textSecondary, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 15, color: AppConstants.textPrimary)),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppConstants.textMuted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AuthProvider auth) {
    return OutlinedButton(
      onPressed: () => _showLogoutConfirmation(context, auth),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppConstants.errorColor,
        side: const BorderSide(color: AppConstants.errorColor),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  void _showLogoutConfirmation(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppConstants.surfaceCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Log Out', style: TextStyle(color: AppConstants.textPrimary)),
        content: const Text('Are you sure you want to log out from Guardian Net?', style: TextStyle(color: AppConstants.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: AppConstants.textMuted))),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              auth.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: const Text('Log Out', style: TextStyle(color: AppConstants.errorColor, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
