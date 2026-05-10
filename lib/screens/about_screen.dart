import 'package:flutter/material.dart';
import '../utils/constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('About Guardian Net'),
        backgroundColor: AppConstants.backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLg),
        child: Column(
          children: [
            const SizedBox(height: 40),
            // App Logo
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppConstants.surfaceCard,
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.primaryColor.withValues(alpha: 0.2),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset('assets/Final_profile_logo.png', fit: BoxFit.contain),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Guardian Net',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppConstants.textPrimary,
                letterSpacing: 1.1,
              ),
            ),
            const Text(
              'Version 1.0.0',
              style: TextStyle(color: AppConstants.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 40),
            
            _buildAboutCard(
              'Our Mission',
              'Guardian Net helps students and families stay connected safely while migrating to new cities and countries. We bridge the gap between guardians and students through a trusted community-oriented platform.',
              Icons.auto_awesome_rounded,
            ),
            const SizedBox(height: 16),
            _buildAboutCard(
              'Privacy & Safety',
              'Safety is our top priority. We use advanced encryption and community verification to ensure a secure networking environment for both students and guardians.',
              Icons.security_rounded,
            ),
            const SizedBox(height: 16),
            _buildAboutCard(
              'Support',
              'Have questions or need help? Contact our support team anytime.',
              Icons.support_agent_rounded,
              trailing: TextButton(
                onPressed: () {},
                child: const Text('Contact Us', style: TextStyle(color: AppConstants.primaryColor)),
              ),
            ),
            
            const SizedBox(height: 40),
            const Text(
              'Developed with ❤️ for the student community.',
              style: TextStyle(color: AppConstants.textMuted, fontSize: 12),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutCard(String title, String content, IconData icon, {Widget? trailing}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppConstants.primaryColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppConstants.primaryColor, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppConstants.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(color: AppConstants.textSecondary, height: 1.5, fontSize: 14),
          ),
          if (trailing != null) ...[
            const SizedBox(height: 8),
            trailing,
          ],
        ],
      ),
    );
  }
}
