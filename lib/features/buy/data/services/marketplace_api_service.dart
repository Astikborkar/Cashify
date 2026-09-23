import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/badge_pill.dart';
import '../../cart/domain/models/coupon_model.dart';
import '../domain/models/refurbished_product_model.dart';

final marketplaceApiServiceProvider = Provider<MarketplaceApiService>((ref) {
  return MarketplaceApiService();
});

class MarketplaceApiService {
  static const List<RefurbishedProductModel> _mockCatalog = [
    RefurbishedProductModel(
      id: 'prod_ip13_mid',
      title: 'Apple iPhone 13 (Midnight, 128 GB)',
      brand: 'Apple',
      modelName: 'iPhone 13',
      grade: BadgeType.gradeSuperb,
      gradeText: 'Superb Grade',
      price: 38999,
      mrp: 59900,
      discountPercent: 35,
      rating: 4.9,
      reviewsCount: 320,
      warrantyMonths: 6,
      qcPointsPassed: 32,
      emiPerMonth: 2166,
      storageOptions: ['128 GB', '256 GB', '512 GB'],
      colorOptions: ['Midnight', 'Starlight', 'Blue', 'Pink'],
      specs: {
        'Display': '6.1-inch Super Retina XDR OLED',
        'Processor': 'A15 Bionic chip (6-core CPU)',
        'Camera': 'Dual 12MP (Wide + Ultra-Wide) with Cinematic mode',
        'Battery': '3240 mAh (All-day battery life)',
        'OS': 'iOS 17 eligible',
        'Security': 'Face ID facial recognition',
      },
    ),
    RefurbishedProductModel(
      id: 'prod_s22_ultra',
      title: 'Samsung Galaxy S22 Ultra 5G (Burgundy, 256 GB)',
      brand: 'Samsung',
      modelName: 'Galaxy S22 Ultra',
      grade: BadgeType.gradeSuperb,
      gradeText: 'Superb Grade',
      price: 47999,
      mrp: 109999,
      discountPercent: 56,
      rating: 4.8,
      reviewsCount: 198,
      warrantyMonths: 6,
      qcPointsPassed: 32,
      emiPerMonth: 2666,
      storageOptions: ['256 GB', '512 GB'],
      colorOptions: ['Burgundy', 'Phantom Black', 'Green'],
      specs: {
        'Display': '6.8-inch Dynamic AMOLED 2X 120Hz',
        'Processor': 'Snapdragon 8 Gen 1 (4nm)',
        'Camera': 'Quad 108MP + 12MP + 10MP + 10MP (100x Space Zoom)',
        'Battery': '5000 mAh (45W Super Fast Charging)',
        'Stylus': 'Embedded S Pen support',
      },
    ),
    RefurbishedProductModel(
      id: 'prod_oneplus_11r',
      title: 'OnePlus 11R 5G (Galactic Silver, 128 GB)',
      brand: 'OnePlus',
      modelName: 'OnePlus 11R',
      grade: BadgeType.gradeGood,
      gradeText: 'Good Grade',
      price: 26999,
      mrp: 39999,
      discountPercent: 32,
      rating: 4.7,
      reviewsCount: 140,
      warrantyMonths: 6,
      qcPointsPassed: 32,
      emiPerMonth: 1499,
      storageOptions: ['128 GB', '256 GB'],
      colorOptions: ['Galactic Silver', 'Sonic Black'],
      specs: {
        'Display': '6.74-inch 120Hz Super Fluid AMOLED',
        'Processor': 'Snapdragon 8+ Gen 1',
        'Camera': '50MP Sony IMX890 with OIS',
        'Battery': '5000 mAh (100W SUPERVOOC Charge in 25 mins)',
      },
    ),
    RefurbishedProductModel(
      id: 'prod_pixel_7',
      title: 'Google Pixel 7 5G (Snow, 128 GB)',
      brand: 'Google',
      modelName: 'Pixel 7',
      grade: BadgeType.gradeFair,
      gradeText: 'Fair Grade',
      price: 23999,
      mrp: 59999,
      discountPercent: 60,
      rating: 4.6,
      reviewsCount: 95,
      warrantyMonths: 6,
      qcPointsPassed: 32,
      emiPerMonth: 1333,
      storageOptions: ['128 GB'],
      colorOptions: ['Snow', 'Obsidian', 'Lemongrass'],
      specs: {
        'Display': '6.3-inch FHD+ 90Hz Smooth Display',
        'Processor': 'Google Tensor G2 with Titan M2 security',
        'Camera': '50MP Octa PD Quad Bayer with Real Tone',
        'Battery': '4355 mAh (Fast Wireless Charging)',
      },
    ),
  ];

  Future<List<RefurbishedProductModel>> getProducts({
    String? brand,
    BadgeType? grade,
    String? sortBy,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    var list = List<RefurbishedProductModel>.from(_mockCatalog);

    if (brand != null && brand != 'All') {
      list = list.where((p) => p.brand.toLowerCase() == brand.toLowerCase()).toList();
    }
    if (grade != null) {
      list = list.where((p) => p.grade == grade).toList();
    }
    if (sortBy == 'price_low_high') {
      list.sort((a, b) => a.price.compareTo(b.price));
    } else if (sortBy == 'price_high_low') {
      list.sort((a, b) => b.price.compareTo(a.price));
    } else if (sortBy == 'discount') {
      list.sort((a, b) => b.discountPercent.compareTo(a.discountPercent));
    }

    return list;
  }

  Future<RefurbishedProductModel?> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _mockCatalog.firstWhere((p) => p.id == id);
    } catch (_) {
      return _mockCatalog.first;
    }
  }

  Future<List<CouponModel>> getAvailableCoupons() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return const [
      CouponModel(
        code: 'CASHIFYNEW',
        title: 'Flat 10% Off',
        description: 'Get 10% off up to ₹2,500 on your first refurbished order.',
        discountPercent: 10,
        maxDiscountAmount: 2500,
        minOrderAmount: 15000,
      ),
      CouponModel(
        code: 'SUPERB500',
        title: 'Flat ₹500 Off',
        description: 'Instant discount on any Superb Grade smartphone.',
        discountPercent: 5,
        maxDiscountAmount: 500,
        minOrderAmount: 10000,
      ),
    ];
  }
}
