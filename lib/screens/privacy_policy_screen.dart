import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policies'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                  boxShadow: AppShadows.sm(isDark: isDark),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPolicySection(
                      'User Data Collection',
                      'We collect information you provide directly to us when you create or modify your account, such as your name, email, profile details, and role (Parent or Student). This data is essential for providing our networking services.',
                      theme,
                    ),
                    _buildPolicySection(
                      'Profile Visibility & Matching',
                      'Your profile information, including your university, course, or location, may be visible to other users to facilitate connections. We use this data to suggest relevant matches within the PeerConnect community.',
                      theme,
                    ),
                    _buildPolicySection(
                      'Location & Migration Data Usage',
                      'We collect location data (e.g., origin city, migrated city/country) to help you connect with peers from similar backgrounds or in the same geographic area. You can manage visibility in your settings.',
                      theme,
                    ),
                    _buildPolicySection(
                      'Messaging & Communication Privacy',
                      'Messages sent through our platform are securely stored. We do not read your private communications unless required for moderation purposes or to investigate reported code of conduct violations.',
                      theme,
                    ),
                    _buildPolicySection(
                      'Data Security & Storage',
                      'We implement robust security measures to protect your personal information from unauthorized access, alteration, or destruction. Your data is stored securely using industry-standard practices.',
                      theme,
                    ),
                    _buildPolicySection(
                      'Third-Party Services Disclaimer',
                      'We may use third-party services for analytics or infrastructure. These services have their own privacy policies. We do not sell your personal data to third parties for marketing purposes.',
                      theme,
                    ),
                    _buildPolicySection(
                      'User Responsibility & Code of Conduct',
                      'Users are expected to maintain a respectful environment. Sharing sensitive personal information of others or engaging in abusive behavior violates our terms and may result in account termination.',
                      theme,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: isDark ? 0.22 : 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _isChecked,
                        onChanged: (value) {
                          setState(() {
                            _isChecked = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          'I have read all the policies carefully',
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                          ),
                          child: const Text('Cancel', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isChecked
                              ? () {
                                  // Mock saving consent
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Privacy policies accepted.')),
                                  );
                                  Navigator.pop(context);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                            disabledBackgroundColor: isDark ? AppColors.darkBorder : AppColors.border,
                            disabledForegroundColor: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                          ),
                          child: const Text('Accept', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicySection(String title, String content, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
