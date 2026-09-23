import '../../buy/domain/models/refurbished_product_model.dart';

/// Single item within the customer shopping cart.
class CartItemModel {
  final RefurbishedProductModel product;
  final int quantity;
  final bool hasWarrantyUpgrade;
  final double warrantyUpgradeCost;

  const CartItemModel({
    required this.product,
    this.quantity = 1,
    this.hasWarrantyUpgrade = false,
    this.warrantyUpgradeCost = 999.0,
  });

  double get itemTotal => (product.price * quantity) + (hasWarrantyUpgrade ? warrantyUpgradeCost * quantity : 0);

  CartItemModel copyWith({
    RefurbishedProductModel? product,
    int? quantity,
    bool? hasWarrantyUpgrade,
    double? warrantyUpgradeCost,
  }) {
    return CartItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      hasWarrantyUpgrade: hasWarrantyUpgrade ?? this.hasWarrantyUpgrade,
      warrantyUpgradeCost: warrantyUpgradeCost ?? this.warrantyUpgradeCost,
    );
  }
}
