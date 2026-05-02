import 'package:cloud_firestore/cloud_firestore.dart';

class Ad {
  final String adId;
  final String title;
  final String description;
  final String? imageUrl;
  final String targetCountry;
  final String? linkUrl;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final List<String> likes;

  Ad({
    required this.adId,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.targetCountry,
    this.linkUrl,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.likes,
  });

  factory Ad.fromJson(Map<String, dynamic> json) {
    final startValue = json['start_date'] ?? json['startDate'];
    final endValue = json['end_date'] ?? json['endDate'];
    final createdAtValue = json['created_at'] ?? json['createdAt'];

    DateTime parseDate(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
      return DateTime.now();
    }

    return Ad(
      adId: json['ad_id'] ?? json['adId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? json['imageUrl'],
      targetCountry: json['target_country'] ?? json['targetCountry'] ?? '',
      linkUrl: json['link_url'] ?? json['linkUrl'],
      startDate: parseDate(startValue),
      endDate: parseDate(endValue),
      createdAt: parseDate(createdAtValue),
      likes: List<String>.from(json['likes'] as List<dynamic>? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ad_id': adId,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'target_country': targetCountry,
      'link_url': linkUrl,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'likes': likes,
    };
  }
}
