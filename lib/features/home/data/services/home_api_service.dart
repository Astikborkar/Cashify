import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/badge_pill.dart';
import '../../../../routes/route_paths.dart';
import '../../domain/models/banner_model.dart';
import '../../domain/models/category_model.dart';
import '../../domain/models/product_summary_model.dart';
import '../../domain/models/trending_sell_device_model.dart';

final homeApiServiceProvider = Provider<HomeApiService>((ref) {
  return HomeApiService();
});

class HomeApiService {
  Future<List<BannerModel>> getBanners() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      BannerModel(
        id: 'b1',
        title: 'Sell Your Old Phone\nAt Best Market Value',
        subtitle: 'Free 24hr doorstep pickup & instant payment via UPI.',
        badgeText: 'INSTANT CASH GUARANTEE',
        ctaText: 'Sell Now →',
        actionUrl: RoutePaths.sell,
        gradientColors: [Color(0xFF009624), Color(0xFF00C853)],
      ),
      BannerModel(
        id: 'b2',
        title: 'Certified Refurbished\nSuperb Grade Phones',
        subtitle: '32-point inspection, 6 months warranty & 7 days refund.',
        badgeText: 'SAVE UP TO 60%',
        ctaText: 'Shop Deals →',
        actionUrl: RoutePaths.buy,
        gradientColors: [Color(0xFF0039CB), Color(0xFF2962FF)],
      ),
      BannerModel(
        id: 'b3',
        title: 'Doorstep Phone Repair\nIn Just 45 Minutes',
        subtitle: 'Cracked screen or dead battery? We fix it in front of you.',
        badgeText: 'GENUINE PARTS ONLY',
        ctaText: 'Book Repair →',
        actionUrl: RoutePaths.repair,
        gradientColors: [Color(0xFFE65100), Color(0xFFFFB300)],
      ),
    ];
  }

  List<CategoryModel> getCategories() {
    return const [
      CategoryModel(
        id: 'cat_sell_phone',
        name: 'Sell Phone',
        slug: 'sell-phone',
        icon: Icons.phone_android_rounded,
        subtitle: 'Instant Cash',
        backgroundColor: AppColors.primaryLight,
        iconColor: AppColors.primaryDark,
        targetRoute: RoutePaths.sell,
      ),
      CategoryModel(
        id: 'cat_sell_laptop',
        name: 'Sell Laptop',
        slug: 'sell-laptop',
        icon: Icons.laptop_mac_rounded,
        subtitle: 'Up to ₹65k',
        backgroundColor: AppColors.secondaryLight,
        iconColor: AppColors.secondaryDark,
        targetRoute: RoutePaths.sell,
      ),
      CategoryModel(
        id: 'cat_buy_phones',
        name: 'Buy Refurbished',
        slug: 'buy-phones',
        icon: Icons.shopping_bag_outlined,
        subtitle: '6-Mo Warranty',
        backgroundColor: AppColors.accentLight,
        iconColor: Color(0xFFC67C00),
        targetRoute: RoutePaths.buy,
      ),
      CategoryModel(
        id: 'cat_repair',
        name: 'Doorstep Repair',
        slug: 'repair',
        icon: Icons.build_rounded,
        subtitle: 'From ₹499',
        backgroundColor: Color(0xFFEDE7F6),
        iconColor: Color(0xFF673AB7),
        targetRoute: RoutePaths.repair,
      ),
      CategoryModel(
        id: 'cat_smartwatch',
        name: 'Smartwatch',
        slug: 'smartwatch',
        icon: Icons.watch_rounded,
        subtitle: 'Quick QC',
        backgroundColor: Color(0xFFE0F7FA),
        iconColor: Color(0xFF00838F),
        targetRoute: RoutePaths.sell,
      ),
      CategoryModel(
        id: 'cat_tablets',
        name: 'Tablets / iPad',
        slug: 'tablets',
        icon: Icons.tablet_mac_rounded,
        subtitle: 'Top Resale',
        backgroundColor: Color(0xFFFBE9E7),
        iconColor: Color(0xFFD84315),
        targetRoute: RoutePaths.sell,
      ),
      CategoryModel(
        id: 'cat_earbuds',
        name: 'Earbuds & Audio',
        slug: 'earbuds',
        icon: Icons.headphones_rounded,
        subtitle: 'All Brands',
        backgroundColor: Color(0xFFE8EAF6),
        iconColor: Color(0xFF3F51B5),
        targetRoute: RoutePaths.sell,
      ),
      CategoryModel(
        id: 'cat_exchange',
        name: 'Exchange Phone',
        slug: 'exchange',
        icon: Icons.sync_alt_rounded,
        subtitle: 'Trade-in Bonus',
        backgroundColor: Color(0xFFE0F2F1),
        iconColor: Color(0xFF00695C),
        targetRoute: RoutePaths.buy,
      ),
    ];
  }

  Future<List<TrendingSellDeviceModel>> getTrendingSellDevices() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      TrendingSellDeviceModel(
        id: 'dev_1',
        brand: 'Apple',
        modelName: 'iPhone 13',
        variantInfo: '128 GB (Midnight)',
        maxQuotePrice: 28500,
        badge: 'Top Traded',
      ),
      TrendingSellDeviceModel(
        id: 'dev_2',
        brand: 'Apple',
        modelName: 'iPhone 14 Pro',
        variantInfo: '128 GB (Deep Purple)',
        maxQuotePrice: 52000,
        badge: 'High Value',
      ),
      TrendingSellDeviceModel(
        id: 'dev_3',
        brand: 'Samsung',
        modelName: 'Galaxy S23 5G',
        variantInfo: '256 GB (Phantom Black)',
        maxQuotePrice: 38000,
        badge: 'Trending',
      ),
      TrendingSellDeviceModel(
        id: 'dev_4',
        brand: 'OnePlus',
        modelName: 'OnePlus 11 5G',
        variantInfo: '128 GB (Titan Black)',
        maxQuotePrice: 29500,
        badge: 'Fast Pickup',
      ),
      TrendingSellDeviceModel(
        id: 'dev_5',
        brand: 'Google',
        modelName: 'Pixel 7a',
        variantInfo: '128 GB (Sea)',
        maxQuotePrice: 19500,
        badge: 'Instant Cash',
      ),
    ];
  }

  Future<List<ProductSummaryModel>> getRefurbishedHotDeals() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return const [
      ProductSummaryModel(
        id: 'prod_1',
        title: 'Apple iPhone 13 (Midnight, 128 GB)',
        brand: 'Apple',
        grade: BadgeType.gradeSuperb,
        gradeText: 'Superb Grade',
        refurbishedPrice: 38999,
        mrp: 59900,
        discountPercent: 35,
        rating: 4.9,
        reviewsCount: 320,
        warrantyMonths: 6,
      ),
      ProductSummaryModel(
        id: 'prod_2',
        title: 'Samsung Galaxy S22 Ultra 5G (Burgundy, 256 GB)',
        brand: 'Samsung',
        grade: BadgeType.gradeGood,
        gradeText: 'Good Grade',
        refurbishedPrice: 47999,
        mrp: 109999,
        discountPercent: 56,
        rating: 4.8,
        reviewsCount: 198,
        warrantyMonths: 6,
      ),
      ProductSummaryModel(
        id: 'prod_3',
        title: 'OnePlus 11R 5G (Galactic Silver, 128 GB)',
        brand: 'OnePlus',
        grade: BadgeType.gradeSuperb,
        gradeText: 'Superb Grade',
        refurbishedPrice: 26999,
        mrp: 39999,
        discountPercent: 32,
        rating: 4.7,
        reviewsCount: 140,
        warrantyMonths: 6,
      ),
      ProductSummaryModel(
        id: 'prod_4',
        title: 'Google Pixel 7 (Snow, 128 GB)',
        brand: 'Google',
        grade: BadgeType.gradeFair,
        gradeText: 'Fair Grade',
        refurbishedPrice: 23999,
        mrp: 59999,
        discountPercent: 60,
        rating: 4.6,
        reviewsCount: 95,
        warrantyMonths: 6,
      ),
    ];
  }

  Future<List<String>> searchSuggestions(String query) async {
    if (query.trim().isEmpty) return [];
    await Future.delayed(const Duration(milliseconds: 150));
    final catalog = [
      'Apple iPhone 13',
      'Apple iPhone 14 Pro',
      'Apple iPhone 15',
      'Apple iPhone 12 Mini',
      'Samsung Galaxy S23 Ultra',
      'Samsung Galaxy S22 5G',
      'Samsung Galaxy Z Fold 4',
      'OnePlus 11 5G',
      'OnePlus Nord CE 3',
      'Google Pixel 7 Pro',
      'Google Pixel 8',
      'Xiaomi 13 Pro',
      'MacBook Air M1 2020',
      'MacBook Pro 14 M2',
      'iPad Air 5th Gen',
    ];
    return catalog
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
