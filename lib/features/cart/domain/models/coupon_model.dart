/// Coupon and promotional discount model.
class CouponModel {
  final String code;
  final String title;
  final String description;
  final double discountPercent;
  final double maxDiscountAmount;
  final double minOrderAmount;

  const CouponModel({
    required this.code,
    required this.title,
    required this.description,
    this.discountPercent = 10,
    this.maxDiscountAmount = 2500,
    this.minOrderAmount = 15000,
  });

  double calculateDiscount(double subtotal) {
    if (subtotal < minOrderAmount) return 0;
    final discount = subtotal * (discountPercent / 100);
    return discount > maxDiscountAmount ? maxDiscountAmount : discount;
  }
}
