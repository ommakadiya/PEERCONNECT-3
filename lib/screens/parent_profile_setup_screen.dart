import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../utils/constants.dart';

class ParentProfileSetupScreen extends StatefulWidget {
  const ParentProfileSetupScreen({super.key});

  @override
  State<ParentProfileSetupScreen> createState() => _ParentProfileSetupScreenState();
}

class _ParentProfileSetupScreenState extends State<ParentProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  int _parentCount = 1;

  // Parent 1 controllers
  final _name1 = TextEditingController();
  final _email1 = TextEditingController();
  final _originCity1 = TextEditingController();
  final _phone1 = TextEditingController();
  final _address1 = TextEditingController();
  final _occupation1 = TextEditingController();
  final _childEmail1 = TextEditingController();

  // Parent 2 controllers
  final _name2 = TextEditingController();
  final _email2 = TextEditingController();
  final _originCity2 = TextEditingController();
  final _phone2 = TextEditingController();
  final _address2 = TextEditingController();
  final _occupation2 = TextEditingController();
  final _childEmail2 = TextEditingController();

  @override
  void dispose() {
    _name1.dispose();
    _email1.dispose();
    _originCity1.dispose();
    _phone1.dispose();
    _address1.dispose();
    _occupation1.dispose();
    _childEmail1.dispose();
    _name2.dispose();
    _email2.dispose();
    _originCity2.dispose();
    _phone2.dispose();
    _address2.dispose();
    _occupation2.dispose();
    _childEmail2.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<ProfileProvider>();

      List<ParentEntry> parents = [
        ParentEntry(
          name: _name1.text.trim(),
          email: _email1.text.trim(),
          originCity: _originCity1.text.trim(),
          phone: _phone1.text.trim(),
          address: _address1.text.trim(),
          occupation: _occupation1.text.trim(),
          childEmail: _childEmail1.text.trim(),
        ),
      ];

      if (_parentCount == 2) {
        parents.add(
          ParentEntry(
            name: _name2.text.trim(),
            email: _email2.text.trim(),
            originCity: _originCity2.text.trim(),
            phone: _phone2.text.trim(),
            address: _address2.text.trim(),
            occupation: _occupation2.text.trim(),
            childEmail: _childEmail2.text.trim(),
          ),
        );
      }

      provider.saveParentProfile(parents);
      Navigator.of(context).pushReplacementNamed('/main');
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
                        'Parent Profile Setup',
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

                // ── Parent 1 Card ──
                _buildFormCard(
                  title: 'PARENT 1 DETAILS',
                  theme: theme,
                  children: _buildParentFields(
                    nameCtrl: _name1,
                    emailCtrl: _email1,
                    cityCtrl: _originCity1,
                    phoneCtrl: _phone1,
                    addressCtrl: _address1,
                    occupationCtrl: _occupation1,
                    childEmailCtrl: _childEmail1,
                    theme: theme,
                  ),
                ),
                const SizedBox(height: AppConstants.paddingLg),

                // ── Add / Remove Parent 2 ──
                if (_parentCount < 2)
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() => _parentCount = 2),
                      icon: const Icon(Icons.person_add, size: 18),
                      label: const Text('Add Another Parent'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppConstants.primaryColor,
                        side: const BorderSide(color: AppConstants.primaryColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.borderRadiusSm)),
                        padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXl, vertical: AppConstants.paddingMd),
                      ),
                    ),
                  ),

                if (_parentCount == 2) ...[
                  _buildFormCard(
                    title: 'PARENT 2 DETAILS',
                    theme: theme,
                    trailing: TextButton(
                      onPressed: () => setState(() => _parentCount = 1),
                      child: const Text('Remove', style: TextStyle(color: AppConstants.errorColor, fontSize: 13)),
                    ),
                    children: _buildParentFields(
                      nameCtrl: _name2,
                      emailCtrl: _email2,
                      cityCtrl: _originCity2,
                      phoneCtrl: _phone2,
                      addressCtrl: _address2,
                      occupationCtrl: _occupation2,
                      childEmailCtrl: _childEmail2,
                      theme: theme,
                    ),
                  ),
                ],
                const SizedBox(height: AppConstants.paddingXl),

                // ── Submit Button ──
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingMd),
                    ),
                    child: const Text('Complete Setup', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
    required ThemeData theme,
    required List<Widget> children,
    Widget? trailing,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.accentColor,
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: AppConstants.paddingLg),
          ...children,
        ],
      ),
    );
  }

  // ── Parent form fields ──
  List<Widget> _buildParentFields({
    required TextEditingController nameCtrl,
    required TextEditingController emailCtrl,
    required TextEditingController cityCtrl,
    required TextEditingController phoneCtrl,
    required TextEditingController addressCtrl,
    required TextEditingController occupationCtrl,
    required TextEditingController childEmailCtrl,
    required ThemeData theme,
  }) {
    return [
      _buildField(nameCtrl, 'Full Name', Icons.person, theme),
      _buildField(emailCtrl, 'Email ID (Gmail)', Icons.email_outlined, theme, keyboard: TextInputType.emailAddress),
      _buildField(cityCtrl, 'Origin City', Icons.location_city, theme),
      _buildField(phoneCtrl, 'Phone Number', Icons.phone, theme, keyboard: TextInputType.phone),
      _buildField(addressCtrl, 'Address', Icons.home, theme),
      _buildField(occupationCtrl, 'Occupation', Icons.work, theme),
      _buildField(childEmailCtrl, 'Child ID / Child Email', Icons.child_care, theme, keyboard: TextInputType.emailAddress),
    ];
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
