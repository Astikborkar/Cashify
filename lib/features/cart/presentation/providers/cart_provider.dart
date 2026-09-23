import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../buy/data/services/marketplace_api_service.dart';
import '../../buy/domain/models/refurbished_product_model.dart';
import '../../domain/models/cart_item_model.dart';
import '../../domain/models/coupon_model.dart';

class CartState {
  final List<CartItemModel> items;
  final CouponModel? appliedCoupon;
  final String? couponError;

  const CartState({
    this.items = const [],
    this.appliedCoupon,
    this.couponError,
  });

  int get totalItemsCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => items.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));

  double get warrantyAddonTotal => items.fold(0.0, (sum, item) => sum + (item.hasWarrantyUpgrade ? item.warrantyUpgradeCost * item.quantity : 0.0));

  double get couponDiscount => appliedCoupon != null ? appliedCoupon!.calculateDiscount(subtotal) : 0.0;

  double get deliveryFee => 0.0; // Free doorstep delivery

  double get grandTotal => (subtotal + warrantyAddonTotal - couponDiscount + deliveryFee).clamp(0.0, double.infinity);

  CartState copyWith({
    List<CartItemModel>? items,
    CouponModel? appliedCoupon,
    bool clearCoupon = false,
    String? couponError,
  }) {
    return CartState(
      items: items ?? this.items,
      appliedCoupon: clearCoupon ? null : (appliedCoupon ?? this.appliedCoupon),
      couponError: couponError,
    );
  }
}

final cartNotifierProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  final apiService = ref.read(marketplaceApiServiceProvider);
  return CartNotifier(apiService);
});

class CartNotifier extends StateNotifier<CartState> {
  final MarketplaceApiService _apiService;

  CartNotifier(this._apiService) : super(const CartState()) {
    _initSampleItem();
  }

  void _initSampleItem() {
    _apiService.getProductById('prod_ip13_mid').then((prod) {
      if (prod != null) {
        state = state.copyWith(items: [
          CartItemModel(product: prod, quantity: 1, hasWarrantyUpgrade: true),
        ]);
      }
    });
  }

  void addToCart(RefurbishedProductModel product, {bool hasWarrantyUpgrade = false}) {
    final index = state.items.indexWhere((i) => i.product.id == product.id);
    if (index >= 0) {
      final updated = List<CartItemModel>.from(state.items);
      updated[index] = updated[index].copyWith(quantity: updated[index].quantity + 1);
      state = state.copyWith(items: updated);
    } else {
      state = state.copyWith(
        items: [...state.items, CartItemModel(product: product, quantity: 1, hasWarrantyUpgrade: hasWarrantyUpgrade)],
      );
    }
  }

  void removeFromCart(String productId) {
    final updated = state.items.where((i) => i.product.id != productId).toList();
    state = state.copyWith(items: updated);
  }

  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(productId);
      return;
    }
    final updated = state.items.map((i) {
      if (i.product.id == productId) {
        return i.copyWith(quantity: newQuantity);
      }
      return i;
    }).toList();
    state = state.copyWith(items: updated);
  }

  void toggleWarrantyUpgrade(String productId) {
    final updated = state.items.map((i) {
      if (i.product.id == productId) {
        return i.copyWith(hasWarrantyUpgrade: !i.hasWarrantyUpgrade);
      }
      return i;
    }).toList();
    state = state.copyWith(items: updated);
  }

  Future<bool> applyCoupon(String code) async {
    final coupons = await _apiService.getAvailableCoupons();
    try {
      final match = coupons.firstWhere((c) => c.code.toUpperCase() == code.trim().toUpperCase());
      if (state.subtotal < match.minOrderAmount) {
        state = state.copyWith(couponError: 'Minimum order amount for this coupon is ₹${match.minOrderAmount.toInt()}');
        return false;
      }
      state = state.copyWith(appliedCoupon: match, couponError: null);
      return true;
    } catch (_) {
      state = state.copyWith(couponError: 'Invalid coupon code. Try CASHIFYNEW');
      return false;
    }
  }

  void removeCoupon() {
    state = state.copyWith(clearCoupon: true, couponError: null);
  }

  void clearCart() {
    state = const CartState();
  }
}
