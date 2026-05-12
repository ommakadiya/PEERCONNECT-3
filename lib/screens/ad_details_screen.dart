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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppConstants.textPrimary, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Ad Details', style: TextStyle(color: AppConstants.textPrimary, fontSize: 18)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.paddingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (ad.imageUrl != null && ad.imageUrl!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
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
                  const SizedBox(height: AppConstants.paddingLg),
                  
                  // Title and ad tag
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          ad.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppConstants.secondaryColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(AppConstants.borderRadiusSm),
                          border: Border.all(color: AppConstants.secondaryColor.withValues(alpha: 0.5)),
                        ),
                        child: const Text(
                          'Sponsored',
                          style: TextStyle(
                            color: AppConstants.secondaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.paddingSm),
                  
                  // Description
                  Text(
                    ad.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppConstants.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingXl),
                  
                  // Target Info
                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingLg),
                    decoration: BoxDecoration(
                      color: AppConstants.surfaceCard,
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
                      border: Border.all(color: AppConstants.primaryColor.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(Icons.public, 'Target Country', ad.targetCountry),
                        const Divider(color: AppConstants.surfaceDark, height: 24),
                        _buildInfoRow(Icons.calendar_today, 'Valid Until', dateStr),
                        const Divider(color: AppConstants.surfaceDark, height: 24),
                        _buildInfoRow(Icons.thumb_up_alt_outlined, 'Likes', '${ad.likes.length} people like this'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppConstants.paddingXl),
                  
                  // Action Button
                  if (ad.linkUrl != null && ad.linkUrl!.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          // Launch URL
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Opening ${ad.linkUrl}...')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.secondaryColor,
                          foregroundColor: AppConstants.backgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
                          ),
                        ),
                        child: const Text(
                          'Visit Link',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _fallbackImage() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: AppConstants.surfaceCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
        border: Border.all(color: AppConstants.secondaryColor.withValues(alpha: 0.3)),
      ),
      child: const Center(
        child: Icon(Icons.campaign_rounded, size: 64, color: AppConstants.secondaryColor),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppConstants.accentColor, size: 20),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(color: AppConstants.textMuted, fontSize: 14),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: AppConstants.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
