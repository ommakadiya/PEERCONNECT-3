import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../theme/app_theme.dart';
import '../widgets/micro_interactions.dart';
import 'main_layout.dart';

class ChildProfileSetupScreen extends StatefulWidget {
  const ChildProfileSetupScreen({super.key});

  @override
  State<ChildProfileSetupScreen> createState() => _ChildProfileSetupScreenState();
}

class _ChildProfileSetupScreenState extends State<ChildProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
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
        final provider = Provider.of<AppStateProvider>(context, listen: false);
        await provider.completeChildProfile(
          name: _nameController.text.trim(),
          originCity: _originCityController.text.trim(),
          university: 'N/A',
          course: 'N/A',
          migratedCity: _migratedCityController.text.trim(),
          migratedCountry: _migratedCountryController.text.trim(),
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
          occupation: _occupationController.text.trim(),
          parentName: _parentNameController.text.trim(),
          parentEmail: _parentEmailController.text.trim(),
        );
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          FadePageRoute(page: const MainLayout()),
        );
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
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: AppSpacing.lg),
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
                      icon: Icon(Icons.arrow_back_ios, size: 20, color: isDark ? AppColors.darkText : AppColors.textPrimary),
                    ),
                    Expanded(
                      child: Text(
                        'Child Profile Setup',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

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
                          backgroundColor: isDark ? AppColors.darkBorder : AppColors.border,
                          child: Icon(Icons.person, size: 44, color: isDark ? AppColors.darkTextMuted : AppColors.textMuted),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt, size: 14, color: AppColors.background),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Center(
                  child: Text('Tap to add photo', style: theme.textTheme.labelMedium),
                ),
                const SizedBox(height: AppSpacing.xl),

                // ── Personal Details Card ──
                _buildFormCard(
                  title: 'PERSONAL DETAILS',
                  isDark: isDark,
                  theme: theme,
                  children: [
                    _buildField(_nameController, 'Full Name', Icons.person, theme, isDark),
                    _buildField(_originCityController, 'Origin City', Icons.location_city, theme, isDark),
                    _buildField(_migratedCityController, 'Migrated City', Icons.flight_land, theme, isDark),
                    _buildField(_migratedCountryController, 'Migrated Country', Icons.public, theme, isDark),
                    _buildField(_phoneController, 'Phone Number', Icons.phone, theme, isDark, keyboard: TextInputType.phone),
                    _buildField(_addressController, 'Address', Icons.home, theme, isDark),
                    _buildField(_occupationController, 'Occupation', Icons.work, theme, isDark),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // ── Parent Details Card ──
                _buildFormCard(
                  title: 'PARENT DETAILS',
                  subtitle: 'Assign at least one parent to your profile',
                  isDark: isDark,
                  theme: theme,
                  children: [
                    _buildField(_parentNameController, 'Parent Name', Icons.person_outline, theme, isDark),
                    _buildField(_parentEmailController, 'Parent Email ID', Icons.email_outlined, theme, isDark, keyboard: TextInputType.emailAddress),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),

                // ── Submit Button ──
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.background),
                          )
                        : const Text('Complete Setup', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
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
    required bool isDark,
    required ThemeData theme,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
        boxShadow: AppShadows.sm(isDark: isDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelSmall?.copyWith(
              letterSpacing: 1.5,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(subtitle, style: theme.textTheme.bodySmall),
          ],
          const SizedBox(height: AppSpacing.lg),
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
    ThemeData theme,
    bool isDark, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              letterSpacing: 1.0,
              color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            keyboardType: keyboard,
            style: theme.textTheme.bodyMedium,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '$label is required';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: label,
              prefixIcon: Icon(icon, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
