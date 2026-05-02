import 'package:flutter/material.dart';
import '../utils/constants.dart';

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

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Privacy Policies'),
        backgroundColor: AppConstants.surfaceCard,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.paddingLg),
              child: Container(
                decoration: BoxDecoration(
                  color: AppConstants.surfaceCard,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
                  border: Border.all(color: AppConstants.primaryColor.withValues(alpha: 0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
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
            padding: const EdgeInsets.all(AppConstants.paddingLg),
            decoration: BoxDecoration(
              color: AppConstants.surfaceCard,
              boxShadow: [
                BoxShadow(
                  color: AppConstants.primaryColor.withValues(alpha: 0.08),
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
                        activeColor: AppConstants.primaryColor,
                        onChanged: (value) {
                          setState(() {
                            _isChecked = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          'I have read all the policies carefully',
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: AppConstants.textPrimary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.paddingLg),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingLg),
                            side: const BorderSide(color: AppConstants.primaryColor),
                          ),
                          child: const Text('Cancel', style: TextStyle(fontSize: 16, color: AppConstants.primaryColor)),
                        ),
                      ),
                      const SizedBox(width: AppConstants.paddingLg),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isChecked
                              ? () {
                                  // Mock saving consent
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Privacy policies accepted.')),
                                  );
                                  Navigator.pushReplacementNamed(context, '/role');
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingLg),
                            backgroundColor: AppConstants.primaryColor,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: AppConstants.surfaceCardLight,
                            disabledForegroundColor: AppConstants.textMuted,
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
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryColor,
            ),
          ),
          const SizedBox(height: AppConstants.paddingSm),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: AppConstants.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
