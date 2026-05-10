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
    _sFirstName.dispose(); _sMiddleName.dispose(); _sLastName.dispose();
    _sEmail.dispose(); _sPhone.dispose(); _sOriginCity.dispose();
    _sMigratedCity.dispose(); _sMigratedCountry.dispose(); _sEduCourse.dispose();
    _sSpecialization.dispose(); _sCollege.dispose(); _sJobCompany.dispose();
    _pFirstName.dispose(); _pLastName.dispose(); _pEmail.dispose();
    _pPhone.dispose(); _pOriginCity.dispose(); _pOccupation.dispose(); _pAddress.dispose();
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
            toolbarTitle: 'SECURE IMAGE CROP',
            toolbarColor: AppConstants.backgroundColor,
            toolbarWidgetColor: AppConstants.goldColor,
            activeControlsWidgetColor: AppConstants.goldColor,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(title: 'SECURE IMAGE CROP'),
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('UPDATE IDENTITY IMAGE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppConstants.goldColor, letterSpacing: 1.5)),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded, color: AppConstants.goldColor),
              title: const Text('CAPTURE WITH CAMERA', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppConstants.textPrimary)),
              onTap: () { Navigator.pop(ctx); _pickImage(ImageSource.camera); },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded, color: AppConstants.goldColor),
              title: const Text('SELECT FROM ARCHIVE', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppConstants.textPrimary)),
              onTap: () { Navigator.pop(ctx); _pickImage(ImageSource.gallery); },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final authProv = context.read<AuthProvider>();
      final profProv = context.read<ProfileProvider>();
      final user = authProv.user;
      if (user == null) return;

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
        parentDetails: user.parentDetails.copyWith(
          firstName: _pFirstName.text.trim(),
          lastName: _pLastName.text.trim(),
          emailId: _pEmail.text.trim(),
          phoneNumber: _pPhone.text.trim(),
          originCity: _pOriginCity.text.trim(),
          occupation: _pOccupation.text.trim(),
          address: _pAddress.text.trim(),
        ),
      );

      await profProv.saveProfile(updatedUser);
      authProv.updateLocalUser(profProv.user!);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Identity protocols updated successfully'), backgroundColor: AppConstants.primaryColor),
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
        title: const Text('UPDATE IDENTITY', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 16)),
        actions: [
          TextButton(
            onPressed: profProv.isSaving ? null : _saveProfile,
            child: const Text('SAVE', style: TextStyle(color: AppConstants.goldColor, fontWeight: FontWeight.w900, letterSpacing: 1)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppConstants.premiumGradient),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: AppConstants.primaryDark,
                      backgroundImage: profProv.localPhotoPath != null && profProv.localPhotoPath!.isNotEmpty
                          ? FileImage(File(profProv.localPhotoPath!)) as ImageProvider
                          : (authProv.user?.photoUrl.isNotEmpty == true ? NetworkImage(authProv.user!.photoUrl) : null),
                      child: (profProv.localPhotoPath == null || profProv.localPhotoPath!.isEmpty) && (authProv.user?.photoUrl.isEmpty ?? true)
                          ? const Icon(Icons.person_rounded, size: 60, color: AppConstants.goldColor)
                          : null,
                    ),
                  ),
                  Positioned(bottom: 5, right: 5, child: GestureDetector(
                    onTap: _showImagePickerOptions,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(color: AppConstants.goldColor, shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt_rounded, size: 18, color: AppConstants.backgroundColor),
                    ),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 40),
            _buildSectionHeader('STUDENT IDENTITY'),
            _buildTextField('FIRST NAME', _sFirstName),
            _buildTextField('MIDDLE NAME', _sMiddleName, required: false),
            _buildTextField('LAST NAME', _sLastName),
            _buildTextField('ACADEMIC EMAIL', _sEmail, keyboardType: TextInputType.emailAddress),
            _buildTextField('SECURE PHONE', _sPhone, keyboardType: TextInputType.phone),
            _buildTextField('ORIGIN CITY', _sOriginCity),
            _buildTextField('CURRENT CITY', _sMigratedCity),
            _buildTextField('CURRENT COUNTRY', _sMigratedCountry),
            _buildTextField('ACADEMIC COURSE', _sEduCourse),
            _buildTextField('SPECIALIZATION', _sSpecialization),
            _buildTextField('COLLEGE NAME', _sCollege),
            _buildDropdown('PROFESSIONAL STATUS', ['None', 'Part-time', 'Full-time'], _jobType, (val) => setState(() => _jobType = val!)),
            _buildTextField('ORGANIZATION', _sJobCompany, required: false),
            
            const SizedBox(height: 32),
            _buildSectionHeader('GUARDIAN PROTOCOL'),
            _buildTextField('GUARDIAN FIRST NAME', _pFirstName),
            _buildTextField('GUARDIAN LAST NAME', _pLastName),
            _buildTextField('GUARDIAN EMAIL', _pEmail, keyboardType: TextInputType.emailAddress),
            _buildTextField('EMERGENCY PHONE', _pPhone, keyboardType: TextInputType.phone),
            _buildTextField('GUARDIAN ORIGIN', _pOriginCity),
            _buildTextField('OCCUPATION', _pOccupation),
            _buildTextField('RESIDENTIAL ADDRESS', _pAddress, maxLines: 2),
            
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: AppConstants.goldColor, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 2)),
          const SizedBox(height: 8),
          Container(height: 1, width: 60, decoration: const BoxDecoration(color: AppConstants.goldColor)),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool required = true, TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(color: AppConstants.textPrimary, fontSize: 14, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: const TextStyle(color: AppConstants.goldColor, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
          filled: true,
          fillColor: AppConstants.surfaceCard,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppConstants.goldColor, width: 1)),
        ),
        validator: required ? (val) => (val == null || val.isEmpty) ? 'REQUIRED' : null : null,
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String value, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DropdownButtonFormField<String>(
        value: value,
        dropdownColor: AppConstants.surfaceCard,
        onChanged: onChanged,
        style: const TextStyle(color: AppConstants.textPrimary, fontSize: 14, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: const TextStyle(color: AppConstants.goldColor, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
          filled: true,
          fillColor: AppConstants.surfaceCard,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        ),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      ),
    );
  }
}
