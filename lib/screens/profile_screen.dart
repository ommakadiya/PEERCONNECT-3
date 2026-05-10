import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peerconnect/providers/auth_provider.dart';
import 'package:peerconnect/providers/profile_provider.dart';
import 'package:peerconnect/models/user_model.dart';
import 'package:peerconnect/utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Student details controllers
  late TextEditingController _sFirstName;
  late TextEditingController _sMiddleName;
  late TextEditingController _sLastName;
  late TextEditingController _sEmail;
  late TextEditingController _sPhone;
  late TextEditingController _sOriginCity;
  late TextEditingController _sMigratedCity;
  late TextEditingController _sMigratedCountry;
  late TextEditingController _sEduCourse;
  late TextEditingController _sSpecialization;
  late TextEditingController _sCollege;
  late TextEditingController _sJobCompany;
  String _jobType = 'None';

  // Parent details controllers
  late TextEditingController _pFirstName;
  late TextEditingController _pLastName;
  late TextEditingController _pEmail;
  late TextEditingController _pPhone;
  late TextEditingController _pOriginCity;
  late TextEditingController _pOccupation;
  late TextEditingController _pAddress;

  @override
  void initState() {
    super.initState();
    final authProv = context.read<AuthProvider>();
    final user = authProv.user;
    
    // Auto-fill from Google name if first/last name are empty
    String initialFirstName = user?.firstName ?? '';
    String initialLastName = user?.lastName ?? '';
    
    if (initialFirstName.isEmpty && user?.name != null && user!.name.isNotEmpty) {
      final parts = user.name.split(' ');
      initialFirstName = parts.first;
      if (parts.length > 1 && initialLastName.isEmpty) {
        initialLastName = parts.sublist(1).join(' ');
      }
    }

    final p = user?.parentDetails ?? const ParentDetails();

    _sFirstName = TextEditingController(text: initialFirstName);
    _sMiddleName = TextEditingController(text: user?.middleName ?? '');
    _sLastName = TextEditingController(text: initialLastName);
    _sEmail = TextEditingController(text: user?.email ?? '');
    _sPhone = TextEditingController(text: user?.phoneNumber ?? '');
    _sOriginCity = TextEditingController(text: user?.originCity ?? '');
    _sMigratedCity = TextEditingController(text: user?.migratedCity ?? '');
    _sMigratedCountry = TextEditingController(text: user?.migratedCountry ?? '');
    _sEduCourse = TextEditingController(text: user?.educationCourse ?? '');
    _sSpecialization = TextEditingController(text: user?.specialization ?? '');
    _sCollege = TextEditingController(text: user?.collegeName ?? '');
    _sJobCompany = TextEditingController(text: user?.jobCompany ?? '');
    _jobType = ['None', 'Part-time', 'Full-time'].contains(user?.jobType) ? (user!.jobType) : 'None';

    _pFirstName = TextEditingController(text: p.firstName);
    _pLastName = TextEditingController(text: p.lastName);
    _pEmail = TextEditingController(text: p.emailId);
    _pPhone = TextEditingController(text: p.phoneNumber);
    _pOriginCity = TextEditingController(text: p.originCity);
    _pOccupation = TextEditingController(text: p.occupation);
    _pAddress = TextEditingController(text: p.address);
  }

  @override
  void dispose() {
    _sFirstName.dispose();
    _sMiddleName.dispose();
    _sLastName.dispose();
    _sEmail.dispose();
    _sPhone.dispose();
    _sOriginCity.dispose();
    _sMigratedCity.dispose();
    _sMigratedCountry.dispose();
    _sEduCourse.dispose();
    _sSpecialization.dispose();
    _sCollege.dispose();
    _sJobCompany.dispose();

    _pFirstName.dispose();
    _pLastName.dispose();
    _pEmail.dispose();
    _pPhone.dispose();
    _pOriginCity.dispose();
    _pOccupation.dispose();
    _pAddress.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null && mounted) {
      context.read<ProfileProvider>().setLocalPhotoPath(pickedFile.path);
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final authProv = context.read<AuthProvider>();
      final profProv = context.read<ProfileProvider>();
      final user = authProv.user;
      if (user == null) return;

      final updatedParent = ParentDetails(
        firstName: _pFirstName.text.trim(),
        lastName: _pLastName.text.trim(),
        emailId: _pEmail.text.trim(),
        phoneNumber: _pPhone.text.trim(),
        originCity: _pOriginCity.text.trim(),
        occupation: _pOccupation.text.trim(),
        address: _pAddress.text.trim(),
      );

      final updatedUser = user.copyWith(
        firstName: _sFirstName.text.trim(),
        middleName: _sMiddleName.text.trim(),
        lastName: _sLastName.text.trim(),
        email: _sEmail.text.trim(),
        phoneNumber: _sPhone.text.trim(),
        originCity: _sOriginCity.text.trim(),
        migratedCity: _sMigratedCity.text.trim(),
        migratedCountry: _sMigratedCountry.text.trim(),
        educationCourse: _sEduCourse.text.trim(),
        specialization: _sSpecialization.text.trim(),
        collegeName: _sCollege.text.trim(),
        jobType: _jobType,
        jobCompany: _sJobCompany.text.trim(),
        parentDetails: updatedParent,
        role: user.role == UserRole.none ? UserRole.child : user.role, // Ensure role is set to avoid re-prompt
      );
      
      final updatedRecommendations = RecommendationFields.fromUserAndParent(updatedUser, updatedParent);
      final finalUser = updatedUser.copyWith(recommendationFields: updatedRecommendations);

      await profProv.saveProfile(finalUser);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully'), backgroundColor: AppConstants.successColor),
        );
      }
    }
  }

  void _signOut() {
    context.read<AuthProvider>().signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    final profProv = context.watch<ProfileProvider>();
    final authProv = context.watch<AuthProvider>();
    
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppConstants.paddingLg),
            children: [
              const Center(
                child: Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.paddingXl),
              
              // Profile Image
              Center(
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: AppConstants.surfaceCardLight,
                        backgroundImage: profProv.localPhotoPath != null
                            ? FileImage(File(profProv.localPhotoPath!)) as ImageProvider
                            : (authProv.user?.photoUrl.isNotEmpty == true 
                                ? NetworkImage(authProv.user!.photoUrl) 
                                : null),
                        child: (profProv.localPhotoPath == null && (authProv.user?.photoUrl.isEmpty ?? true))
                            ? const Icon(Icons.person, size: 50, color: AppConstants.textMuted)
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppConstants.secondaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppConstants.surfaceCard, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.paddingXl),

              // Student Details Section
              _buildSectionCard(
                title: 'Student Details',
                children: [
                  _buildTextField('First Name', _sFirstName),
                  _buildTextField('Middle Name', _sMiddleName, required: false),
                  _buildTextField('Last Name', _sLastName),
                  _buildTextField('Email ID', _sEmail, keyboardType: TextInputType.emailAddress),
                  _buildTextField('Phone Number', _sPhone, keyboardType: TextInputType.phone),
                  _buildTextField('Origin City', _sOriginCity),
                  _buildTextField('Migrated City', _sMigratedCity),
                  _buildTextField('Migrated Country', _sMigratedCountry),
                  _buildTextField('Education Course', _sEduCourse),
                  _buildTextField('Specialization', _sSpecialization),
                  _buildTextField('College Name', _sCollege),
                  _buildDropdown('Job Type', ['None', 'Part-time', 'Full-time'], _jobType, (val) {
                    setState(() => _jobType = val!);
                  }),
                  _buildTextField('Job Company', _sJobCompany, required: false),
                ],
              ),
              const SizedBox(height: AppConstants.paddingLg),

              // Parent Details Section
              _buildSectionCard(
                title: 'Parent Details',
                children: [
                  _buildTextField('Parent First Name', _pFirstName),
                  _buildTextField('Parent Last Name', _pLastName),
                  _buildTextField('Parent Email ID', _pEmail, keyboardType: TextInputType.emailAddress),
                  _buildTextField('Parent Phone Number', _pPhone, keyboardType: TextInputType.phone),
                  _buildTextField('Parent Origin City', _pOriginCity),
                  _buildTextField('Parent Occupation', _pOccupation),
                  _buildTextField('Parent Address', _pAddress),
                ],
              ),
              const SizedBox(height: AppConstants.paddingXl),

              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: profProv.isSaving ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: profProv.isSaving
                      ? const CircularProgressIndicator(color: AppConstants.textPrimary)
                      : const Text('Save Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: AppConstants.paddingXl),
              Center(
                child: TextButton.icon(
                  onPressed: _signOut, 
                  icon: const Icon(Icons.logout, color: AppConstants.errorColor),
                  label: const Text('Sign Out', style: TextStyle(color: AppConstants.errorColor)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLg),
      decoration: BoxDecoration(
        color: AppConstants.surfaceCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
        border: Border.all(color: AppConstants.primaryColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.secondaryColor,
            ),
          ),
          const SizedBox(height: AppConstants.paddingLg),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label, 
    TextEditingController controller, {
    bool required = true, 
    TextInputType keyboardType = TextInputType.text
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: AppConstants.textPrimary),
        decoration: InputDecoration(
          labelText: label + (required ? ' *' : ''),
          labelStyle: const TextStyle(color: AppConstants.textSecondary),
          filled: true,
          fillColor: AppConstants.surfaceCardLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        validator: required
            ? (value) => (value == null || value.trim().isEmpty) ? 'Required' : null
            : null,
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String value, void Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(color: AppConstants.textPrimary)))).toList(),
        onChanged: onChanged,
        dropdownColor: AppConstants.surfaceCard,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppConstants.textSecondary),
          filled: true,
          fillColor: AppConstants.surfaceCardLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
