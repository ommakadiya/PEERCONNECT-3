import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../utils/constants.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
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

  late TextEditingController _pFirstName;
  late TextEditingController _pLastName;
  late TextEditingController _pEmail;
  late TextEditingController _pPhone;
  late TextEditingController _pOriginCity;
  late TextEditingController _pOccupation;
  late TextEditingController _pAddress;

  String _jobType = 'None';

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    
    _sFirstName = TextEditingController(text: user?.firstName);
    _sMiddleName = TextEditingController(text: user?.middleName);
    _sLastName = TextEditingController(text: user?.lastName);
    _sEmail = TextEditingController(text: user?.email);
    _sPhone = TextEditingController(text: user?.phoneNumber);
    _sOriginCity = TextEditingController(text: user?.originCity);
    _sMigratedCity = TextEditingController(text: user?.migratedCity);
    _sMigratedCountry = TextEditingController(text: user?.migratedCountry);
    _sEduCourse = TextEditingController(text: user?.educationCourse);
    _sSpecialization = TextEditingController(text: user?.specialization);
    _sCollege = TextEditingController(text: user?.collegeName);
    _sJobCompany = TextEditingController(text: user?.jobCompany);
    _jobType = user?.jobType ?? 'None';

    _pFirstName = TextEditingController(text: user?.parentDetails.firstName);
    _pLastName = TextEditingController(text: user?.parentDetails.lastName);
    _pEmail = TextEditingController(text: user?.parentDetails.emailId);
    _pPhone = TextEditingController(text: user?.parentDetails.phoneNumber);
    _pOriginCity = TextEditingController(text: user?.parentDetails.originCity);
    _pOccupation = TextEditingController(text: user?.parentDetails.occupation);
    _pAddress = TextEditingController(text: user?.parentDetails.address);
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

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: AppConstants.backgroundColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(title: 'Crop Image'),
        ],
      );

      if (croppedFile != null && mounted) {
        context.read<ProfileProvider>().setLocalPhotoPath(croppedFile.path);
      }
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.surfaceCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.camera_alt, color: AppConstants.primaryColor),
            title: const Text('Camera', style: TextStyle(color: AppConstants.textPrimary)),
            onTap: () { Navigator.pop(ctx); _pickImage(ImageSource.camera); },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: AppConstants.primaryColor),
            title: const Text('Gallery', style: TextStyle(color: AppConstants.textPrimary)),
            onTap: () { Navigator.pop(ctx); _pickImage(ImageSource.gallery); },
          ),
          if (context.read<ProfileProvider>().localPhotoPath != null || context.read<AuthProvider>().user?.photoUrl.isNotEmpty == true)
            ListTile(
              leading: const Icon(Icons.delete, color: AppConstants.errorColor),
              title: const Text('Remove Photo', style: TextStyle(color: AppConstants.errorColor)),
              onTap: () {
                Navigator.pop(ctx);
                context.read<ProfileProvider>().setLocalPhotoPath(''); // Placeholder for remove
              },
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
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
      );

      await profProv.saveProfile(updatedUser);
      authProv.updateLocalUser(profProv.user!); // Sync back to auth
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully'), backgroundColor: AppConstants.successColor),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profProv = context.watch<ProfileProvider>();
    final authProv = context.watch<AuthProvider>();
    
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppConstants.backgroundColor,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: profProv.isSaving ? null : _saveProfile,
            child: const Text('Save', style: TextStyle(color: AppConstants.primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.paddingLg),
          children: [
            // Profile Photo
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppConstants.surfaceCardLight,
                    backgroundImage: profProv.localPhotoPath != null && profProv.localPhotoPath!.isNotEmpty
                        ? FileImage(File(profProv.localPhotoPath!)) as ImageProvider
                        : (authProv.user?.photoUrl.isNotEmpty == true ? NetworkImage(authProv.user!.photoUrl) : null),
                    child: (profProv.localPhotoPath == null || profProv.localPhotoPath!.isEmpty) && (authProv.user?.photoUrl.isEmpty ?? true)
                        ? const Icon(Icons.person, size: 60, color: AppConstants.textMuted)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _showImagePickerOptions,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppConstants.primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppConstants.backgroundColor, width: 2),
                        ),
                        child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  if (profProv.isUploading)
                    const Positioned.fill(
                      child: Center(child: CircularProgressIndicator(color: AppConstants.primaryColor)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            _buildSectionHeader('Student Details'),
            _buildTextField('First Name', _sFirstName),
            _buildTextField('Middle Name', _sMiddleName, required: false),
            _buildTextField('Last Name', _sLastName),
            _buildTextField('Email', _sEmail, keyboardType: TextInputType.emailAddress),
            _buildTextField('Phone', _sPhone, keyboardType: TextInputType.phone),
            _buildTextField('Origin City', _sOriginCity),
            _buildTextField('Migrated City', _sMigratedCity),
            _buildTextField('Migrated Country', _sMigratedCountry),
            _buildTextField('Education Course', _sEduCourse),
            _buildTextField('Specialization', _sSpecialization),
            _buildTextField('College', _sCollege),
            _buildDropdown('Job Type', ['None', 'Part-time', 'Full-time'], _jobType, (val) => setState(() => _jobType = val!)),
            _buildTextField('Job Company', _sJobCompany, required: false),
            
            const SizedBox(height: 24),
            _buildSectionHeader('Parent Details'),
            _buildTextField('Parent First Name', _pFirstName),
            _buildTextField('Parent Last Name', _pLastName),
            _buildTextField('Parent Email', _pEmail, keyboardType: TextInputType.emailAddress),
            _buildTextField('Parent Phone', _pPhone, keyboardType: TextInputType.phone),
            _buildTextField('Parent Origin City', _pOriginCity),
            _buildTextField('Occupation', _pOccupation),
            _buildTextField('Address', _pAddress, maxLines: 2),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(color: AppConstants.primaryColor, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool required = true, TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(color: AppConstants.textPrimary, fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: const TextStyle(color: AppConstants.textSecondary),
          filled: true,
          fillColor: AppConstants.surfaceCard,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
        validator: required ? (val) => (val == null || val.isEmpty) ? 'Required' : null : null,
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String value, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        dropdownColor: AppConstants.surfaceCard,
        onChanged: onChanged,
        style: const TextStyle(color: AppConstants.textPrimary, fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: const TextStyle(color: AppConstants.textSecondary),
          filled: true,
          fillColor: AppConstants.surfaceCard,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      ),
    );
  }
}
