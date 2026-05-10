import 'package:flutter/material.dart';
import 'package:peerconnect/models/user_model.dart';
import 'package:peerconnect/utils/constants.dart';

class ProfileDetailsScreen extends StatefulWidget {
  final UserModel user;
  final bool isConnected;
  final VoidCallback onConnectToggle;

  const ProfileDetailsScreen({
    super.key,
    required this.user,
    required this.isConnected,
    required this.onConnectToggle,
  });

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  String _maskEmail(String email) {
    if (email.isEmpty) return 'N/A';
    if (widget.isConnected) return email;
    
    final parts = email.split('@');
    if (parts.length != 2) return '***';
    final name = parts[0];
    if (name.length <= 3) return '***@${parts[1]}';
    return '${name.substring(0, 3)}****@${parts[1]}';
  }

  String _maskPhone(String phone) {
    if (phone.isEmpty) return 'N/A';
    if (widget.isConnected) return phone;

    if (phone.length <= 4) return '***';
    if (phone.startsWith('+')) {
      final code = phone.substring(0, 3);
      final rest = phone.substring(3);
      if (rest.length <= 4) return '$code ***';
      return '$code ******${rest.substring(rest.length - 4)}';
    }
    return '******${phone.substring(phone.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final theme = Theme.of(context);

    String displayName = user.firstName.isNotEmpty
        ? '${user.firstName} ${user.lastName}'.trim()
        : user.name;
    if (displayName.isEmpty) displayName = 'Unknown User';

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Profile Details'),
        backgroundColor: AppConstants.surfaceCard,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppConstants.surfaceCard,
                border: Border(bottom: BorderSide(color: AppConstants.primaryColor.withValues(alpha: 0.3))),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppConstants.primaryColor,
                    backgroundImage: user.photoUrl.isNotEmpty ? NetworkImage(user.photoUrl) : null,
                    child: user.photoUrl.isEmpty ? Text(
                      displayName[0].toUpperCase(),
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                    ) : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    displayName,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: AppConstants.textPrimary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on_rounded, size: 14, color: AppConstants.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        user.originCity.isNotEmpty ? user.originCity : 'Unknown Location',
                        style: theme.textTheme.bodySmall?.copyWith(color: AppConstants.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: widget.onConnectToggle,
                    icon: Icon(widget.isConnected ? Icons.check_rounded : Icons.person_add_outlined, size: 16),
                    label: Text(widget.isConnected ? 'Connected' : '+ Connect', style: const TextStyle(fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.isConnected ? AppConstants.successColor : AppConstants.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _SectionCard(
                    title: 'STUDENT DETAILS',
                    theme: theme,
                    child: Column(
                      children: [
                        _InfoRow(label: 'Email ID', value: _maskEmail(user.email), theme: theme),
                        _InfoRow(label: 'Phone Number', value: _maskPhone(user.phoneNumber), theme: theme),
                        _InfoRow(label: 'Education Course', value: user.educationCourse, theme: theme),
                        _InfoRow(label: 'Specialization', value: user.specialization, theme: theme),
                        _InfoRow(label: 'College Name', value: user.collegeName, theme: theme),
                        _InfoRow(label: 'Job Type', value: user.jobType, theme: theme),
                        _InfoRow(label: 'Job Company', value: user.jobCompany, theme: theme),
                        _InfoRow(label: 'Origin City', value: user.originCity, theme: theme),
                        _InfoRow(label: 'Migrated City', value: user.migratedCity, theme: theme),
                        _InfoRow(label: 'Migrated Country', value: user.migratedCountry, theme: theme),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: 'PARENT DETAILS',
                    theme: theme,
                    child: Column(
                      children: [
                        _InfoRow(label: 'Parent Name', value: '${user.parentDetails.firstName} ${user.parentDetails.lastName}'.trim(), theme: theme),
                        _InfoRow(label: 'Parent Email ID', value: _maskEmail(user.parentDetails.emailId), theme: theme),
                        _InfoRow(label: 'Parent Phone Number', value: _maskPhone(user.parentDetails.phoneNumber), theme: theme),
                        _InfoRow(label: 'Parent Occupation', value: user.parentDetails.occupation, theme: theme),
                        _InfoRow(label: 'Parent Origin City', value: user.parentDetails.originCity, theme: theme),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final ThemeData theme;
  final Widget child;

  const _SectionCard({required this.title, required this.theme, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.primaryColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppConstants.secondaryColor)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;

  const _InfoRow({required this.label, required this.value, required this.theme});

  @override
  Widget build(BuildContext context) {
    final displayValue = value.isEmpty ? 'N/A' : value;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: Text(label, style: const TextStyle(color: AppConstants.textMuted))),
          Expanded(flex: 3, child: Text(displayValue, style: const TextStyle(color: AppConstants.textPrimary, fontWeight: FontWeight.w500), textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}
