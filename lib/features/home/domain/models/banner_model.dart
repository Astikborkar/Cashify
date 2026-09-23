import 'package:flutter/material.dart';

/// Marketing promotional hero banner model.
class BannerModel {
  final String id;
  final String title;
  final String subtitle;
  final String? badgeText;
  final String ctaText;
  final String actionUrl;
  final List<Color> gradientColors;
  final String? imageUrl;

  const BannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    this.badgeText,
    required this.ctaText,
    required this.actionUrl,
    required this.gradientColors,
    this.imageUrl,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      badgeText: json['badge_text'] as String?,
      ctaText: (json['cta_text'] as String?) ?? 'Explore Now',
      actionUrl: (json['action_url'] as String?) ?? '/sell',
      gradientColors: [
        const Color(0xFF009624),
        const Color(0xFF00C853),
      ],
      imageUrl: json['image_url'] as String?,
    );
  }
}
