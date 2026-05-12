import 'package:flutter/material.dart';
import '../utils/constants.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: AppConstants.backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy & Terms',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppConstants.textPrimary),
            ),
            const SizedBox(height: 8),
            const Text(
              'Last Updated: May 10, 2026',
              style: TextStyle(color: AppConstants.textMuted, fontSize: 13),
            ),
            const SizedBox(height: 32),
            
            _buildSection(
              '1. Data Privacy',
              'We prioritize your data security. Your personal information, including name, email, and location, is encrypted and stored securely using Firebase Firestore. We do not sell your data to third parties.',
            ),
            _buildSection(
              '2. User Protection',
              'Guardian Net is designed to be a safe space. Any form of harassment, bullying, or inappropriate behavior will result in immediate account suspension.',
            ),
            _buildSection(
              '3. Firebase Data Handling',
              'We use Firebase Authentication for secure login, Cloud Firestore for real-time data sync, and Firebase Storage for your profile photos. By using this app, you agree to their data processing terms.',
            ),
            _buildSection(
              '4. Community Guidelines',
              'Users are expected to provide accurate information to maintain trust. False representation of roles (Student/Guardian) is strictly prohibited.',
            ),
            
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushReplacementNamed(context, '/role');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Accept & Continue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppConstants.secondaryColor),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(color: AppConstants.textSecondary, height: 1.6, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
