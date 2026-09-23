import '../../../../core/widgets/badge_pill.dart';

/// Comprehensive certified refurbished product model.
class RefurbishedProductModel {
  final String id;
  final String title;
  final String brand;
  final String modelName;
  final BadgeType grade;
  final String gradeText;
  final double price;
  final double mrp;
  final double discountPercent;
  final double rating;
  final int reviewsCount;
  final int warrantyMonths;
  final int qcPointsPassed;
  final List<String> images;
  final Map<String, String> specs;
  final List<String> storageOptions;
  final List<String> colorOptions;
  final double emiPerMonth;
  final bool inStock;

  const RefurbishedProductModel({
    required this.id,
    required this.title,
    required this.brand,
    required this.modelName,
    required this.grade,
    required this.gradeText,
    required this.price,
    required this.mrp,
    required this.discountPercent,
    this.rating = 4.8,
    this.reviewsCount = 142,
    this.warrantyMonths = 6,
    this.qcPointsPassed = 32,
    this.images = const [],
    this.specs = const {},
    this.storageOptions = const ['128 GB', '256 GB'],
    this.colorOptions = const ['Midnight', 'Starlight', 'Blue'],
    this.emiPerMonth = 2499,
    this.inStock = true,
  });
}
