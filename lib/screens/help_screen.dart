import 'package:flutter/material.dart';
import 'package:peerconnect/utils/constants.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  // Mock ads data
  static const List<String> ads = [
    'Ad 1: Amazing Product!',
    'Ad 2: Great Service!',
    'Ad 3: Buy Now!',
    'Ad 4: Special Offer!',
    'Ad 5: New Features!',
    'Ad 6: Join Us!',
    'Ad 7: Exclusive Deal!',
    'Ad 8: Limited Time!',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppConstants.backgroundGradient),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Help & Ads',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppConstants.textPrimary),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemCount: ads.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: AppConstants.surfaceCard,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            ads[index],
                            style: const TextStyle(color: AppConstants.textPrimary, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}