import 'package:flutter/material.dart';
import '../utils/constants.dart';

// ── Data Model ──
class Advertisement {
  final String id;
  final String title;
  final String type;
  final String description;
  final String contact;
  final String website;
  final String location;
  final String image;

  const Advertisement({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
    required this.contact,
    required this.website,
    required this.location,
    required this.image,
  });
}

// ── Static data ──
const _adsData = [
  Advertisement(
    id: '1',
    title: 'PG Diploma Admission',
    type: 'Education',
    description: 'PG Diploma in Advertising and MSL Management Associate program. Focus on student success and career growth.',
    contact: '+91 9833806739',
    website: 'Not Available',
    location: 'St. Pauls Institute',
    image: 'assets/images/ad3.jpg',
  ),
  Advertisement(
    id: '2',
    title: 'PG Abroad After MBBS',
    type: 'Education / Study Abroad',
    description: 'Opportunities for Indian MBBS students to pursue PG abroad with course and fee guidance.',
    contact: 'Not Available',
    website: 'Careers360',
    location: 'Global Medical Education',
    image: 'assets/images/ad4.jpg',
  ),
  Advertisement(
    id: '3',
    title: 'Work in Germany',
    type: 'Job Opportunity (International)',
    description: 'Technical job opportunities in Germany for professionals with minimum 5 years experience.',
    contact: '+91 9998011396, +91 7043991743',
    website: 'www.globalgateways.co',
    location: 'Germany / India',
    image: 'assets/images/ad5.jpg',
  ),
  Advertisement(
    id: '4',
    title: 'Kitchen Staff Hiring',
    type: 'Job Opportunity',
    description: 'Hiring kitchen staff for part-time and full-time roles. Suitable for basic cooking and kitchen work.',
    contact: 'Apply within or send CV',
    website: 'Not Available',
    location: 'Local Restaurant',
    image: 'assets/images/ad1.jpg',
  ),
  Advertisement(
    id: '5',
    title: 'Restaurant Staff Hiring',
    type: 'Job Opportunity',
    description: 'Hiring Commis Chef, Receptionist, and Kitchen Staff. Includes meals and flexible shifts.',
    contact: '6356385085',
    website: 'Not Available',
    location: 'Rajkot',
    image: 'assets/images/ad2.jpg',
  ),
];

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final Set<String> _likedAdIds = {};

  void _toggleLike(String adId) {
    setState(() {
      if (_likedAdIds.contains(adId)) {
        _likedAdIds.remove(adId);
      } else {
        _likedAdIds.add(adId);
      }
    });
  }

  void _openAdDetails(Advertisement ad) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final isLiked = _likedAdIds.contains(ad.id);
            return _AdDetailSheet(
              ad: ad,
              isLiked: isLiked,
              onToggleLike: () {
                _toggleLike(ad.id);
                setModalState(() {});
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ELITE OPPORTUNITIES',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppConstants.goldColor, letterSpacing: 2),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Curated Excellence',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppConstants.textPrimary),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Discover premium career paths and educational programs designed for the modern professional.',
                    style: TextStyle(fontSize: 14, color: AppConstants.textSecondary, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final ad = _adsData[index];
                  return _AdCard(
                    ad: ad,
                    isLiked: _likedAdIds.contains(ad.id),
                    onToggleLike: () => _toggleLike(ad.id),
                    onTap: () => _openAdDetails(ad),
                  );
                },
                childCount: _adsData.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                mainAxisExtent: 360,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdCard extends StatelessWidget {
  final Advertisement ad;
  final bool isLiked;
  final VoidCallback onToggleLike;
  final VoidCallback onTap;

  const _AdCard({
    required this.ad,
    required this.isLiked,
    required this.onToggleLike,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppConstants.surfaceCard,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: AppConstants.goldColor.withValues(alpha: 0.1)),
          boxShadow: AppConstants.premiumShadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    ad.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(color: AppConstants.primaryDark),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: GestureDetector(
                      onTap: onToggleLike,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(color: AppConstants.backgroundColor, shape: BoxShape.circle),
                        child: Icon(
                          isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: isLiked ? Colors.redAccent : AppConstants.goldColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ad.type.toUpperCase(),
                      style: const TextStyle(color: AppConstants.goldColor, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ad.title,
                      style: const TextStyle(color: AppConstants.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ad.description,
                      style: const TextStyle(color: AppConstants.textSecondary, fontSize: 12, height: 1.4),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdDetailSheet extends StatelessWidget {
  final Advertisement ad;
  final bool isLiked;
  final VoidCallback onToggleLike;

  const _AdDetailSheet({
    required this.ad,
    required this.isLiked,
    required this.onToggleLike,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppConstants.navyAccent,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: AppConstants.goldColor.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Image.asset(
                      ad.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 250,
                      errorBuilder: (_, __, ___) => Container(color: AppConstants.primaryDark, height: 250),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          ad.title,
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppConstants.textPrimary),
                        ),
                      ),
                      IconButton(
                        icon: Icon(isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: isLiked ? Colors.redAccent : AppConstants.goldColor, size: 32),
                        onPressed: onToggleLike,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: AppConstants.goldColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                    child: Text(ad.type, style: const TextStyle(color: AppConstants.goldColor, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  const SizedBox(height: 32),
                  const Text('PROGRAM OVERVIEW', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppConstants.textPrimary, letterSpacing: 1.5)),
                  const SizedBox(height: 12),
                  Text(ad.description, style: const TextStyle(color: AppConstants.textSecondary, height: 1.6, fontSize: 15)),
                  const SizedBox(height: 32),
                  _buildDetailItem(Icons.phone_outlined, 'CONTACT PROTOCOL', ad.contact),
                  _buildDetailItem(Icons.language_outlined, 'PORTAL ACCESS', ad.website),
                  _buildDetailItem(Icons.location_on_outlined, 'BASE LOCATION', ad.location),
                  const SizedBox(height: 32),
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
                      child: const Text('ENGAGE OPPORTUNITY', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppConstants.primaryDark, borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: AppConstants.goldColor, size: 20),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: AppConstants.textMuted, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(color: AppConstants.textPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
