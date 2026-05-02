import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peerconnect/providers/auth_provider.dart';
import 'package:peerconnect/providers/profile_provider.dart';
import 'package:peerconnect/utils/constants.dart';
import 'package:peerconnect/screens/edit_profile_screen.dart';
import 'package:peerconnect/screens/change_password_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (mounted) {
        context.read<ProfileProvider>().setLocalPhotoPath(pickedFile.path);
      }
    }
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppConstants.surfaceCard,
        title: const Text('Delete Account', style: TextStyle(color: AppConstants.errorColor)),
        content: const Text('Are you sure you want to permanently delete your account? This action cannot be undone.', style: TextStyle(color: AppConstants.textPrimary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppConstants.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ProfileProvider>().clearProfile();
              context.read<AuthProvider>().signOut();
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppConstants.errorColor),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

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
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
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
                      border: Border.all(color: AppConstants.secondaryColor.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: _pickImage,
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: AppConstants.surfaceCardLight,
                                backgroundImage: profileProv.localPhotoPath != null
                                    ? FileImage(File(profileProv.localPhotoPath!)) as ImageProvider
                                    : (authProv.user?.photoUrl.isNotEmpty == true 
                                        ? NetworkImage(authProv.user!.photoUrl) 
                                        : null),
                                child: (profileProv.localPhotoPath == null && authProv.user?.photoUrl.isEmpty == true)
                                    ? const Icon(Icons.person, size: 40, color: AppConstants.textMuted)
                                    : null,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppConstants.secondaryColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppConstants.surfaceCard, width: 2),
                                  ),
                                  child: const Icon(Icons.camera_alt, size: 12, color: Colors.white),
                                ),
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
                                  color: AppConstants.secondaryColor,
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
                      IconButton(
                        icon: const Icon(Icons.edit, color: AppConstants.secondaryColor, size: 20),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.paddingLg),
                  Container(
                    decoration: BoxDecoration(
                      color: AppConstants.surfaceCard,
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
                      border: Border.all(color: AppConstants.secondaryColor.withValues(alpha: 0.3)),
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
                      border: Border.all(color: AppConstants.secondaryColor.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      children: [
                        _buildSettingsRow(Icons.lock_outline, 'Change Password', () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordScreen()));
                        }),
                        _buildDivider(),
                        _buildSettingsRow(Icons.privacy_tip_outlined, 'Privacy Policies', () {
                          Navigator.pushNamed(context, '/privacy');
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingXl),

                  // Delete Account Section
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppConstants.surfaceCard,
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
                      border: Border.all(color: AppConstants.errorColor.withValues(alpha: 0.3)),
                    ),
                    child: _buildSettingsRow(
                      Icons.delete_forever, 
                      'Delete Account', 
                      _deleteAccount,
                      textColor: AppConstants.errorColor,
                      iconColor: AppConstants.errorColor,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingXl),
                ],
              ),
            ),
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
          Icon(icon, color: AppConstants.secondaryColor, size: 22),
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

  Widget _buildSettingsRow(IconData icon, String title, VoidCallback onTap, {Color? textColor, Color? iconColor}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingLg, vertical: AppConstants.paddingLg),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? AppConstants.secondaryColor, size: 22),
            const SizedBox(width: AppConstants.paddingLg),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? AppConstants.textPrimary,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: textColor ?? AppConstants.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppConstants.secondaryColor.withValues(alpha: 0.2),
      indent: AppConstants.paddingLg,
      endIndent: AppConstants.paddingLg,
    );
  }
}