import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../utils/constants.dart';

class ChildProfileSetupScreen extends StatefulWidget {
  const ChildProfileSetupScreen({super.key});

  @override
  State<ChildProfileSetupScreen> createState() => _ChildProfileSetupScreenState();
}

class _ChildProfileSetupScreenState extends State<ChildProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _originCityController = TextEditingController();
  final _migratedCityController = TextEditingController();
  final _migratedCountryController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _occupationController = TextEditingController();
  final _parentNameController = TextEditingController();
  final _parentEmailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _originCityController.dispose();
    _migratedCityController.dispose();
    _migratedCountryController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _occupationController.dispose();
    _parentNameController.dispose();
    _parentEmailController.dispose();
    super.dispose();
  }

  bool _isSubmitting = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      try {
        final provider = context.read<ProfileProvider>();
        provider.saveChildProfile(
          ChildProfile(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            originCity: _originCityController.text.trim(),
            migratedCity: _migratedCityController.text.trim(),
            migratedCountry: _migratedCountryController.text.trim(),
            phone: _phoneController.text.trim(),
            address: _addressController.text.trim(),
            occupation: _occupationController.text.trim(),
            parentName: _parentNameController.text.trim(),
            parentEmail: _parentEmailController.text.trim(),
          ),
        );
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed('/main');
      } catch (e) {
        debugPrint('Profile save error: $e');
        if (!mounted) return;
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save profile. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: AppConstants.paddingLg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios, size: 20, color: AppConstants.textPrimary),
                    ),
                    Expanded(
                      child: Text(
                        'Child Profile Setup',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: AppConstants.textPrimary),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingLg),

                // ── Avatar ──
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // TODO: Image picker
                    },
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 44,
                          backgroundColor: AppConstants.surfaceCardLight,
                          child: const Icon(Icons.person, size: 44, color: AppConstants.textMuted),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppConstants.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt, size: 14, color: AppConstants.textPrimary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingSm),
                Center(
                  child: Text('Tap to add photo', style: theme.textTheme.labelMedium?.copyWith(color: AppConstants.textSecondary)),
                ),
                const SizedBox(height: AppConstants.paddingXl),

                // ── Personal Details Card ──
                _buildFormCard(
                  title: 'PERSONAL DETAILS',
                  theme: theme,
                  children: [
                    _buildField(_nameController, 'Full Name', Icons.person, theme),
                    _buildField(_emailController, 'Email ID (Gmail)', Icons.email_outlined, theme, keyboard: TextInputType.emailAddress),
                    _buildField(_originCityController, 'Origin City', Icons.location_city, theme),
                    _buildField(_migratedCityController, 'Migrated City', Icons.flight_land, theme),
                    _buildField(_migratedCountryController, 'Migrated Country', Icons.public, theme),
                    _buildField(_phoneController, 'Phone Number', Icons.phone, theme, keyboard: TextInputType.phone),
                    _buildField(_addressController, 'Address', Icons.home, theme),
                    _buildField(_occupationController, 'Occupation', Icons.work, theme),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingLg),

                // ── Parent Details Card ──
                _buildFormCard(
                  title: 'PARENT DETAILS',
                  subtitle: 'Assign at least one parent to your profile',
                  theme: theme,
                  children: [
                    _buildField(_parentNameController, 'Parent Name', Icons.person_outline, theme),
                    _buildField(_parentEmailController, 'Parent Email ID', Icons.email_outlined, theme, keyboard: TextInputType.emailAddress),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingXl),

                // ── Submit Button ──
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingMd),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppConstants.textPrimary),
                          )
                        : const Text('Complete Setup', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingXl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Form Card wrapper ──
  Widget _buildFormCard({
    required String title,
    String? subtitle,
    required ThemeData theme,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingLg),
      decoration: BoxDecoration(
        color: AppConstants.surfaceCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
        border: Border.all(color: AppConstants.primaryColor.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
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
              color: AppConstants.accentColor,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppConstants.paddingSm),
            Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: AppConstants.textSecondary)),
          ],
          const SizedBox(height: AppConstants.paddingLg),
          ...children,
        ],
      ),
    );
  }

  // ── Single field: label ABOVE input, icon INSIDE ──
  Widget _buildField(
    TextEditingController controller,
    String label,
    IconData icon,
    ThemeData theme, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              letterSpacing: 1.0,
              color: AppConstants.textMuted,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            keyboardType: keyboard,
            style: theme.textTheme.bodyMedium?.copyWith(color: AppConstants.textPrimary),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '$label is required';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: label,
              hintStyle: const TextStyle(color: AppConstants.textMuted),
              prefixIcon: Icon(icon, size: 18, color: AppConstants.textSecondary),
              filled: true,
              fillColor: AppConstants.surfaceCardLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
                borderSide: const BorderSide(color: AppConstants.primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
