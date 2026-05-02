import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:peerconnect/providers/profile_provider.dart';
import 'package:peerconnect/utils/constants.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;
  late TextEditingController _courseController;

  @override
  void initState() {
    super.initState();
    final profileProv = context.read<ProfileProvider>();
    
    String name = profileProv.displayName;
    String email = profileProv.displayEmail;
    String city = '';
    String country = '';
    String course = '';

    if (profileProv.role == UserRole.child && profileProv.childProfile != null) {
      city = profileProv.childProfile!.originCity;
      country = profileProv.childProfile!.migratedCountry;
      course = profileProv.childProfile!.occupation;
    } else if (profileProv.role == UserRole.parent && profileProv.parentEntries.isNotEmpty) {
      city = profileProv.parentEntries.first.originCity;
      course = profileProv.parentEntries.first.occupation;
    }

    _nameController = TextEditingController(text: name);
    _emailController = TextEditingController(text: email);
    _cityController = TextEditingController(text: city);
    _countryController = TextEditingController(text: country);
    _courseController = TextEditingController(text: course);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final profileProv = context.read<ProfileProvider>();
      
      // Update Child Profile
      if (profileProv.role == UserRole.child && profileProv.childProfile != null) {
        final cp = profileProv.childProfile!;
        final updatedCp = ChildProfile(
          name: _nameController.text,
          email: _emailController.text,
          originCity: _cityController.text,
          migratedCity: cp.migratedCity,
          migratedCountry: _countryController.text,
          phone: cp.phone,
          address: cp.address,
          occupation: _courseController.text,
          parentName: cp.parentName,
          parentEmail: cp.parentEmail,
        );
        profileProv.saveChildProfile(updatedCp);
      } 
      // Update Parent Profile
      else if (profileProv.role == UserRole.parent && profileProv.parentEntries.isNotEmpty) {
        final pe = profileProv.parentEntries.first;
        final updatedPe = ParentEntry(
          name: _nameController.text,
          email: _emailController.text,
          originCity: _cityController.text,
          phone: pe.phone,
          address: pe.address,
          occupation: _courseController.text,
          childEmail: pe.childEmail,
        );
        
        final newList = List<ParentEntry>.from(profileProv.parentEntries);
        newList[0] = updatedPe;
        profileProv.saveParentProfile(newList);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!', style: TextStyle(color: Colors.white)),
          backgroundColor: AppConstants.successColor,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isChild = context.read<ProfileProvider>().role == UserRole.child;

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppConstants.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Edit Profile', style: TextStyle(color: AppConstants.textPrimary, fontSize: 18)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.paddingLg),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField('Full Name', _nameController, Icons.person),
                    const SizedBox(height: 16),
                    _buildTextField('Email Address', _emailController, Icons.email),
                    const SizedBox(height: 16),
                    _buildTextField('City', _cityController, Icons.location_city),
                    const SizedBox(height: 16),
                    if (isChild) ...[
                      _buildTextField('Migrated Country', _countryController, Icons.public),
                      const SizedBox(height: 16),
                    ],
                    _buildTextField('Course / Occupation', _courseController, Icons.work),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: AppConstants.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppConstants.textSecondary),
        prefixIcon: Icon(icon, color: AppConstants.accentColor),
        filled: true,
        fillColor: AppConstants.surfaceCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppConstants.primaryColor.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppConstants.primaryColor.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppConstants.primaryColor),
        ),
      ),
      validator: (value) => value == null || value.trim().isEmpty ? 'Required field' : null,
    );
  }
}
