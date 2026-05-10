import 'package:flutter/material.dart';
import 'package:peerconnect/models/ad.dart';
import 'package:peerconnect/utils/constants.dart';

class AdDetailsScreen extends StatelessWidget {
  final Ad ad;

  const AdDetailsScreen({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    final String dateStr = '${ad.endDate.year}-${ad.endDate.month.toString().padLeft(2, '0')}-${ad.endDate.day.toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('OPPORTUNITY DETAILS', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 14)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (ad.imageUrl != null && ad.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Image.network(
                  ad.imageUrl!,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _fallbackImage(),
                ),
              )
            else
              _fallbackImage(),
            const SizedBox(height: 32),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: AppConstants.goldColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                  child: const Text('PREMIUM', style: TextStyle(color: AppConstants.goldColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                ),
                const Spacer(),
                const Icon(Icons.share_outlined, color: AppConstants.goldColor, size: 20),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              ad.title,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppConstants.textPrimary),
            ),
            const SizedBox(height: 12),
            Text(
              ad.description,
              style: const TextStyle(fontSize: 15, color: AppConstants.textSecondary, height: 1.6),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppConstants.surfaceCard,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppConstants.goldColor.withValues(alpha: 0.1)),
              ),
              child: Column(
                children: [
                  _buildInfoRow(Icons.public_rounded, 'PROTOCOL', 'Global Access'),
                  const Divider(color: AppConstants.primaryDark, height: 32),
                  _buildInfoRow(Icons.calendar_today_rounded, 'VALID UNTIL', dateStr),
                  const Divider(color: AppConstants.primaryDark, height: 32),
                  _buildInfoRow(Icons.verified_user_rounded, 'SECURITY', 'Verified Source'),
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.goldColor,
                  foregroundColor: AppConstants.backgroundColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('ACCESS OPPORTUNITY', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fallbackImage() {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        color: AppConstants.primaryDark,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppConstants.goldColor.withValues(alpha: 0.1)),
      ),
      child: const Center(
        child: Icon(Icons.star_rounded, size: 64, color: AppConstants.goldColor),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppConstants.goldColor, size: 20),
        const SizedBox(width: 16),
        Text(label, style: const TextStyle(color: AppConstants.textMuted, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
        const Spacer(),
        Text(value, style: const TextStyle(color: AppConstants.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }
}
