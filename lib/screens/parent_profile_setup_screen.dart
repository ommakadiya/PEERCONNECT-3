import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../theme/app_theme.dart';
import '../widgets/micro_interactions.dart';
import 'main_layout.dart';

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
  final _originCity1 = TextEditingController();
  final _phone1 = TextEditingController();
  final _address1 = TextEditingController();
  final _occupation1 = TextEditingController();
  final _childEmail1 = TextEditingController();

  // Parent 2 controllers
  final _name2 = TextEditingController();
  final _originCity2 = TextEditingController();
  final _phone2 = TextEditingController();
  final _address2 = TextEditingController();
  final _occupation2 = TextEditingController();
  final _childEmail2 = TextEditingController();

  @override
  void dispose() {
    _name1.dispose();
    _originCity1.dispose();
    _phone1.dispose();
    _address1.dispose();
    _occupation1.dispose();
    _childEmail1.dispose();
    _name2.dispose();
    _originCity2.dispose();
    _phone2.dispose();
    _address2.dispose();
    _occupation2.dispose();
    _childEmail2.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<AppStateProvider>(context, listen: false);

      List<ParentDetail> parents = [
        ParentDetail(
          name: _name1.text.trim(),
          originCity: _originCity1.text.trim(),
          phone: _phone1.text.trim(),
          address: _address1.text.trim(),
          occupation: _occupation1.text.trim(),
          childEmailId: _childEmail1.text.trim(),
        ),
      ];

      if (_parentCount == 2) {
        parents.add(
          ParentDetail(
            name: _name2.text.trim(),
            originCity: _originCity2.text.trim(),
            phone: _phone2.text.trim(),
            address: _address2.text.trim(),
            occupation: _occupation2.text.trim(),
            childEmailId: _childEmail2.text.trim(),
          ),
        );
      }

      provider.completeParentProfile(parents: parents);
      Navigator.of(context).pushReplacement(
        FadePageRoute(page: const MainLayout()),
      );
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
                        'Parent Profile Setup',
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

                // ── Parent 1 Card ──
                _buildFormCard(
                  title: 'PARENT 1 DETAILS',
                  isDark: isDark,
                  theme: theme,
                  children: _buildParentFields(
                    nameCtrl: _name1,
                    cityCtrl: _originCity1,
                    phoneCtrl: _phone1,
                    addressCtrl: _address1,
                    occupationCtrl: _occupation1,
                    childEmailCtrl: _childEmail1,
                    theme: theme,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // ── Add / Remove Parent 2 ──
                if (_parentCount < 2)
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() => _parentCount = 2),
                      icon: const Icon(Icons.person_add, size: 18),
                      label: const Text('Add Another Parent'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
                      ),
                    ),
                  ),

                if (_parentCount == 2) ...[
                  _buildFormCard(
                    title: 'PARENT 2 DETAILS',
                    isDark: isDark,
                    theme: theme,
                    trailing: TextButton(
                      onPressed: () => setState(() => _parentCount = 1),
                      child: const Text('Remove', style: TextStyle(color: AppColors.error, fontSize: 13)),
                    ),
                    children: _buildParentFields(
                      nameCtrl: _name2,
                      cityCtrl: _originCity2,
                      phoneCtrl: _phone2,
                      addressCtrl: _address2,
                      occupationCtrl: _occupation2,
                      childEmailCtrl: _childEmail2,
                      theme: theme,
                      isDark: isDark,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),

                // ── Submit Button ──
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: PressableScale(
                    scaleFactor: 0.95,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      ),
                      child: const Text('Complete Setup', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
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
    required bool isDark,
    required ThemeData theme,
    required List<Widget> children,
    Widget? trailing,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ...children,
        ],
      ),
    );
  }

  // ── Parent form fields ──
  List<Widget> _buildParentFields({
    required TextEditingController nameCtrl,
    required TextEditingController cityCtrl,
    required TextEditingController phoneCtrl,
    required TextEditingController addressCtrl,
    required TextEditingController occupationCtrl,
    required TextEditingController childEmailCtrl,
    required ThemeData theme,
    required bool isDark,
  }) {
    return [
      _buildField(nameCtrl, 'Full Name', Icons.person, theme, isDark),
      _buildField(cityCtrl, 'Origin City', Icons.location_city, theme, isDark),
      _buildField(phoneCtrl, 'Phone Number', Icons.phone, theme, isDark, keyboard: TextInputType.phone),
      _buildField(addressCtrl, 'Address', Icons.home, theme, isDark),
      _buildField(occupationCtrl, 'Occupation', Icons.work, theme, isDark),
      _buildField(childEmailCtrl, 'Child ID / Child Email', Icons.child_care, theme, isDark, keyboard: TextInputType.emailAddress),
    ];
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
