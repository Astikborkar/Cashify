import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/badge_pill.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../routes/route_paths.dart';
import '../presentation/providers/cart_provider.dart';

/// Shopping Cart Screen managing selected devices, extended warranties, and discount coupons.
class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    final code = _couponController.text.trim();
    if (code.isNotEmpty) {
      ref.read(cartNotifierProvider.notifier).applyCoupon(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartNotifierProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'My Shopping Cart'),
      body: cartState.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 64, color: AppColors.neutral300),
                  const SizedBox(height: AppSpacing.md),
                  const Text('Your cart is empty', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  const Text('Explore certified refurbished electronics and deals.', style: TextStyle(color: AppColors.neutral500)),
                  const SizedBox(height: AppSpacing.lg),
                  ElevatedButton(
                    onPressed: () => context.go(RoutePaths.buy),
                    child: const Text('Start Shopping'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: AppSpacing.screenPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cart Items List
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cartState.items.length,
                          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                          itemBuilder: (context, index) {
                            final item = cartState.items[index];
                            final product = item.product;

                            return AppCard(
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 70,
                                        height: 85,
                                        decoration: BoxDecoration(
                                          color: AppColors.neutral100,
                                          borderRadius: AppSpacing.roundedSm,
                                        ),
                                        child: const Center(
                                          child: Icon(Icons.phone_iphone_rounded, size: 36, color: AppColors.neutral700),
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.md),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            BadgePill(text: product.gradeText, type: product.grade),
                                            const SizedBox(height: 4),
                                            Text(
                                              product.title,
                                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              CurrencyFormatter.format(product.price),
                                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Quantity Stepper
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove_circle_outline_rounded, size: 22, color: AppColors.neutral700),
                                            onPressed: () {
                                              ref.read(cartNotifierProvider.notifier).updateQuantity(product.id, item.quantity - 1);
                                            },
                                          ),
                                          Text(
                                            '${item.quantity}',
                                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.add_circle_outline_rounded, size: 22, color: AppColors.primary),
                                            onPressed: () {
                                              ref.read(cartNotifierProvider.notifier).updateQuantity(product.id, item.quantity + 1);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 16),
                                  // Warranty Upgrade Checkbox
                                  InkWell(
                                    onTap: () {
                                      ref.read(cartNotifierProvider.notifier).toggleWarrantyUpgrade(product.id);
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          item.hasWarrantyUpgrade ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                                          color: item.hasWarrantyUpgrade ? AppColors.primary : AppColors.neutral500,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        const Expanded(
                                          child: Text(
                                            '1-Year Accidental & Screen Protection',
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Text(
                                          '+ ${CurrencyFormatter.format(item.warrantyUpgradeCost)}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: item.hasWarrantyUpgrade ? AppColors.primaryDark : AppColors.neutral700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // Coupon Input Card
                        AppCard(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.local_offer_rounded, color: AppColors.primary, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      controller: _couponController,
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                      decoration: const InputDecoration(
                                        hintText: 'Enter promo code (e.g. CASHIFYNEW)',
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        filled: false,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                  ),
                                  if (cartState.appliedCoupon != null)
                                    TextButton(
                                      onPressed: () {
                                        ref.read(cartNotifierProvider.notifier).removeCoupon();
                                        _couponController.clear();
                                      },
                                      child: const Text('Remove', style: TextStyle(color: AppColors.error)),
                                    )
                                  else
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        minimumSize: const Size(60, 34),
                                        shape: RoundedRectangleBorder(borderRadius: AppSpacing.roundedSm),
                                      ),
                                      onPressed: _applyCoupon,
                                      child: const Text('Apply', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                                    ),
                                ],
                              ),
                              if (cartState.couponError != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    cartState.couponError!,
                                    style: const TextStyle(color: AppColors.error, fontSize: 11),
                                  ),
                                ),
                              if (cartState.appliedCoupon != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    'Coupon ${cartState.appliedCoupon!.code} applied! ${cartState.appliedCoupon!.title}',
                                    style: const TextStyle(color: AppColors.primaryDark, fontSize: 11, fontWeight: FontWeight.w600),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // Price Details Summary Card
                        AppCard(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Price Details', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                              const SizedBox(height: AppSpacing.md),
                              _buildPriceRow('Items Total (${cartState.totalItemsCount})', CurrencyFormatter.format(cartState.subtotal)),
                              if (cartState.warrantyAddonTotal > 0)
                                _buildPriceRow('Protection Plans', '+ ${CurrencyFormatter.format(cartState.warrantyAddonTotal)}'),
                              if (cartState.couponDiscount > 0)
                                _buildPriceRow('Coupon Discount', '- ${CurrencyFormatter.format(cartState.couponDiscount)}', isDiscount: true),
                              _buildPriceRow('Doorstep Delivery', 'FREE', isHighlight: true),
                              const Divider(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Grand Total Payable', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                                  Text(
                                    CurrencyFormatter.format(cartState.grandTotal),
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primaryDark),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: AppSpacing.xl),
                      ],
                    ),
                  ),
                ),

                // Sticky Bottom Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceLight,
                    boxShadow: [BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, -4))],
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Total Amount', style: TextStyle(fontSize: 11, color: AppColors.neutral500)),
                            Text(
                              CurrencyFormatter.format(cartState.grandTotal),
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.neutral900),
                            ),
                          ],
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(
                          child: AppButton(
                            text: 'Proceed to Checkout →',
                            onPressed: () => context.push(RoutePaths.checkout),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
  }

  Widget _buildPriceRow(String label, String value, {bool isDiscount = false, bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.neutral700)),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDiscount ? AppColors.error : (isHighlight ? AppColors.primaryDark : AppColors.neutral900),
            ),
          ),
        ],
      ),
    );
  }
}
