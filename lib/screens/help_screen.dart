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

// ══════════════════════════════════════════════════
//  HELP SCREEN
// ══════════════════════════════════════════════════
class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  // Maintaining liked ads state locally by storing their IDs
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
        // StatefulBuilder allows updating the like button inside the bottom sheet
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppConstants.paddingMd, AppConstants.paddingMd, AppConstants.paddingMd, AppConstants.paddingSm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Featured Opportunities',
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: AppConstants.secondaryColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Discover jobs, education, and services curated for you.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppConstants.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.paddingMd),
            sliver: SliverLayoutBuilder(
              builder: (context, constraints) {
                int columns = constraints.crossAxisExtent >= 600 ? 2 : 1;
                
                return SliverGrid(
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
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: AppConstants.paddingMd,
                    mainAxisSpacing: AppConstants.paddingMd,
                    mainAxisExtent: 340, // Increased height for posters
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════
//  AD CARD
// ══════════════════════════════════════════════════
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
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: AppConstants.animationMedium,
        decoration: BoxDecoration(
          color: AppConstants.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppConstants.secondaryColor.withValues(alpha: 0.3),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Image
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'ad_image_${ad.id}',
                    child: Image.asset(
                      ad.image,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppConstants.surfaceCardLight,
                          child: const Center(child: Icon(Icons.broken_image, size: 36, color: AppConstants.secondaryColor)),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppConstants.backgroundColor.withValues(alpha: 0.72),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? AppConstants.accentColor : AppConstants.backgroundColor,
                          size: 20,
                        ),
                        onPressed: onToggleLike,
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Bottom Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ad.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppConstants.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.category_outlined,
                        size: 14,
                        color: AppConstants.secondaryColor,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          ad.type,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppConstants.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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

// ══════════════════════════════════════════════════
//  AD DETAIL BOTTOM SHEET
// ══════════════════════════════════════════════════
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
    final theme = Theme.of(context);
    
    // Panel should cover ~75% of screen height
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Container(
      height: screenHeight * 0.75,
      decoration: const BoxDecoration(
        color: AppConstants.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppConstants.secondaryColor.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Hero(
                    tag: 'ad_image_${ad.id}',
                    child: SizedBox(
                      height: 220,
                      width: double.infinity,
                        child: Image.asset(
                          ad.image,
                          fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppConstants.surfaceCardLight,
                            child: const Center(child: Icon(Icons.broken_image, size: 48, color: AppConstants.secondaryColor)),
                          );
                        },
                      ),
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(AppConstants.paddingLg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title & Like
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                ad.title,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: AppConstants.textPrimary,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                isLiked ? Icons.favorite : Icons.favorite_border,
                                color: isLiked ? AppConstants.accentColor : AppConstants.textSecondary,
                                size: 28,
                              ),
                              onPressed: onToggleLike,
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Type Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppConstants.secondaryColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            ad.type,
                            style: const TextStyle(
                              color: AppConstants.secondaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Description
                        Text(
                          'Description',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: AppConstants.textPrimary),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ad.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                            color: AppConstants.textSecondary,
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Details Section
                        _buildDetailRow(context, Icons.phone_outlined, 'Contact', ad.contact),
                        const SizedBox(height: 16),
                        _buildDetailRow(context, Icons.language_outlined, 'Website', ad.website),
                        const SizedBox(height: 16),
                        _buildDetailRow(context, Icons.location_on_outlined, 'Location', ad.location),
                      ],
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

  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppConstants.secondaryColor.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: AppConstants.secondaryColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppConstants.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: AppConstants.textPrimary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
