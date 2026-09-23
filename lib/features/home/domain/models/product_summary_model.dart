import '../../../../core/widgets/badge_pill.dart';

/// Refurbished product summary card model for home and marketplace feeds.
class ProductSummaryModel {
  final String id;
  final String title;
  final String brand;
  final BadgeType grade;
  final String gradeText;
  final double refurbishedPrice;
  final double mrp;
  final double discountPercent;
  final double rating;
  final int reviewsCount;
  final int warrantyMonths;
  final String? imageUrl;

  const ProductSummaryModel({
    required this.id,
    required this.title,
    required this.brand,
    required this.grade,
    required this.gradeText,
    required this.refurbishedPrice,
    required this.mrp,
    required this.discountPercent,
    this.rating = 4.8,
    this.reviewsCount = 142,
    this.warrantyMonths = 6,
    this.imageUrl,
  });

  factory ProductSummaryModel.fromJson(Map<String, dynamic> json) {
    final gradeStr = (json['grade'] as String?)?.toLowerCase() ?? 'superb';
    BadgeType type = BadgeType.gradeSuperb;
    String label = 'Superb Grade';
    if (gradeStr == 'good') {
      type = BadgeType.gradeGood;
      label = 'Good Grade';
    } else if (gradeStr == 'fair') {
      type = BadgeType.gradeFair;
      label = 'Fair Grade';
    }

    final price = (json['refurbished_price'] as num).toDouble();
    final mrpVal = (json['mrp'] as num).toDouble();
    final discount = mrpVal > 0 ? (((mrpVal - price) / mrpVal) * 100).roundToDouble() : 0.0;

    return ProductSummaryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      brand: (json['brand'] as String?) ?? 'Apple',
      grade: type,
      gradeText: label,
      refurbishedPrice: price,
      mrp: mrpVal,
      discountPercent: discount,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      reviewsCount: (json['reviews_count'] as int?) ?? 120,
      warrantyMonths: (json['warranty_months'] as int?) ?? 6,
      imageUrl: json['image_url'] as String?,
    );
  }
}
