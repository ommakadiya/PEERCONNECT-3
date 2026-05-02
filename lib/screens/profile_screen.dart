import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:peerconnect/providers/auth_provider.dart';
import 'package:peerconnect/providers/profile_provider.dart';
import 'package:peerconnect/utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profileProv = context.watch<ProfileProvider>();
    final authProv = context.watch<AuthProvider>();
    
    final bool isChild = profileProv.role == UserRole.child;
    final String roleStr = isChild ? 'Child' : (profileProv.role == UserRole.parent ? 'Parent' : 'User');
    
    final String name = profileProv.displayName.isNotEmpty 
        ? profileProv.displayName 
        : (authProv.user?.name ?? 'Unknown User');
        
    String location = 'N/A';
    String university = 'N/A';
    String course = 'N/A';
    String country = 'N/A';
    String city = 'N/A';

    if (isChild && profileProv.childProfile != null) {
      final cp = profileProv.childProfile!;
      location = cp.originCity;
      country = cp.migratedCountry.isNotEmpty ? cp.migratedCountry : 'N/A';
      city = cp.originCity.isNotEmpty ? cp.originCity : 'N/A';
      course = cp.occupation.isNotEmpty ? cp.occupation : 'N/A';
    } else if (!isChild && profileProv.parentEntries.isNotEmpty) {
      final pe = profileProv.parentEntries.first;
      location = pe.originCity;
      city = pe.originCity.isNotEmpty ? pe.originCity : 'N/A';
      course = pe.occupation.isNotEmpty ? pe.occupation : 'N/A';
    }

    final String displayEmail = profileProv.displayEmail.isNotEmpty
        ? profileProv.displayEmail
        : (authProv.user?.email ?? 'N/A');

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingLg, vertical: AppConstants.paddingXl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Center(
                child: Text(
                  'Profile & Settings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.paddingXl),

              // Profile Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppConstants.paddingLg),
                decoration: BoxDecoration(
                  color: AppConstants.surfaceCard,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
                  border: Border.all(color: AppConstants.primaryColor.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: AppConstants.surfaceCardLight,
                          backgroundImage: authProv.user?.photoUrl.isNotEmpty == true 
                              ? NetworkImage(authProv.user!.photoUrl) 
                              : null,
                          child: authProv.user?.photoUrl.isEmpty == true 
                              ? Icon(Icons.person, size: 40, color: AppConstants.textMuted)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppConstants.backgroundColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppConstants.surfaceCard, width: 2),
                            ),
                            child: const Icon(Icons.edit, size: 12, color: AppConstants.textSecondary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: AppConstants.paddingLg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppConstants.successColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              roleStr,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 14, color: AppConstants.textMuted),
                              const SizedBox(width: 4),
                              Text(
                                location,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppConstants.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.paddingXl),

              // Profile Information Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Profile Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textPrimary,
                    ),
                  ),
                  Icon(Icons.edit, color: AppConstants.successColor, size: 20),
                ],
              ),
              const SizedBox(height: AppConstants.paddingLg),
              Container(
                decoration: BoxDecoration(
                  color: AppConstants.surfaceCard,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
                  border: Border.all(color: AppConstants.primaryColor.withValues(alpha: 0.2)),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.person, name, 'Name'),
                    _buildDivider(),
                    _buildInfoRow(Icons.email, displayEmail, 'Email ID'),
                    _buildDivider(),
                    _buildInfoRow(Icons.school, university, 'University'),
                    _buildDivider(),
                    _buildInfoRow(Icons.menu_book, course, 'Course'),
                    _buildDivider(),
                    _buildInfoRow(Icons.public, country, 'Country'),
                    _buildDivider(),
                    _buildInfoRow(Icons.location_city, city, 'City'),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.paddingXl),

              // Account Settings Section
              const Text(
                'Account Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textPrimary,
                ),
              ),
              const SizedBox(height: AppConstants.paddingLg),
              Container(
                decoration: BoxDecoration(
                  color: AppConstants.surfaceCard,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
                  border: Border.all(color: AppConstants.primaryColor.withValues(alpha: 0.2)),
                ),
                child: Column(
                  children: [
                    _buildSettingsRow(Icons.lock_outline, 'Change Password', () {}),
                    _buildDivider(),
                    _buildSettingsRow(Icons.privacy_tip_outlined, 'Privacy Policies', () {
                      Navigator.pushNamed(context, '/privacy');
                    }),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.paddingXl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String value, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingLg, vertical: AppConstants.paddingLg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppConstants.successColor, size: 22),
          const SizedBox(width: AppConstants.paddingLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppConstants.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsRow(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingLg, vertical: AppConstants.paddingLg),
        child: Row(
          children: [
            Icon(icon, color: AppConstants.successColor, size: 22),
            const SizedBox(width: AppConstants.paddingLg),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppConstants.textPrimary,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppConstants.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppConstants.primaryColor.withValues(alpha: 0.2),
      indent: AppConstants.paddingLg,
      endIndent: AppConstants.paddingLg,
    );
  }
}