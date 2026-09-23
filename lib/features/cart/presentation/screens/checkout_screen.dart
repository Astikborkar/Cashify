import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../routes/route_paths.dart';
import '../presentation/providers/cart_provider.dart';

/// Checkout Screen for delivery address selection, shipping speed, and Razorpay/COD payment.
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  int _addressIndex = 0;
  String _shippingSpeed = 'standard';
  String _paymentMethod = 'razorpay';
  bool _isProcessing = false;

  Future<void> _handlePlaceOrder() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;
    setState(() => _isProcessing = false);

    ref.read(cartNotifierProvider.notifier).clearCart();
    context.go(RoutePaths.orderSuccess);
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartNotifierProvider);
    final expressFee = _shippingSpeed == 'express' ? 149.0 : 0.0;
    final finalPayable = cartState.grandTotal + expressFee;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Checkout'),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Delivery Address
            const Text('1. Delivery Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: AppSpacing.sm),
            AppCard(
              isSelected: _addressIndex == 0,
              onTap: () => setState(() => _addressIndex = 0),
              child: Row(
                children: [
                  const Icon(Icons.home_rounded, color: AppColors.primary, size: 24),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Home (Primary)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                        Text(
                          'Rahul Sharma, +91 98765 43210\n#402, Green View Apts, 12th Main, Indiranagar, Bengaluru - 560038',
                          style: TextStyle(fontSize: 12, color: AppColors.neutral700, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _addressIndex == 0 ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
                    color: _addressIndex == 0 ? AppColors.primary : AppColors.neutral300,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // 2. Shipping Speed
            const Text('2. Shipping Options', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    isSelected: _shippingSpeed == 'standard',
                    onTap: () => setState(() => _shippingSpeed = 'standard'),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Standard Delivery', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                        Text('2 - 3 Business Days', style: TextStyle(fontSize: 11, color: AppColors.neutral500)),
                        SizedBox(height: 4),
                        Text('FREE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primaryDark)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppCard(
                    isSelected: _shippingSpeed == 'express',
                    onTap: () => setState(() => _shippingSpeed = 'express'),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Express 24-Hour', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                        Text('Guaranteed Next Day', style: TextStyle(fontSize: 11, color: AppColors.neutral500)),
                        SizedBox(height: 4),
                        Text('+ ₹149', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.neutral900)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // 3. Payment Method
            const Text('3. Select Payment Gateway', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: AppSpacing.sm),
            _buildPaymentOption('razorpay', 'Razorpay Secure (UPI, Cards, NetBanking)', Icons.credit_card_rounded),
            const SizedBox(height: AppSpacing.xs),
            _buildPaymentOption('cod', 'Cash on Delivery (COD with SMS OTP)', Icons.local_atm_rounded),
            const SizedBox(height: AppSpacing.xs),
            _buildPaymentOption('wallet', 'Cashify Wallet (Balance: ₹1,250)', Icons.account_balance_wallet_rounded),

            const SizedBox(height: AppSpacing.lg),

            // Price Summary
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.neutral100,
                borderRadius: AppSpacing.roundedMd,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Items Total:', style: TextStyle(fontSize: 13, color: AppColors.neutral700)),
                      Text(CurrencyFormatter.format(cartState.subtotal), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  if (cartState.couponDiscount > 0) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Coupon Savings:', style: TextStyle(fontSize: 13, color: AppColors.error)),
                        Text('- ${CurrencyFormatter.format(cartState.couponDiscount)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.error)),
                      ],
                    ),
                  ],
                  if (expressFee > 0) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Express Shipping:', style: TextStyle(fontSize: 13, color: AppColors.neutral700)),
                        Text('+ ${CurrencyFormatter.format(expressFee)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Amount Payable:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                      Text(
                        CurrencyFormatter.format(finalPayable),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primaryDark),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            AppButton(
              text: 'Place Order & Pay →',
              isLoading: _isProcessing,
              onPressed: _handlePlaceOrder,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String value, String title, IconData icon) {
    final isSelected = _paymentMethod == value;
    return AppCard(
      isSelected: isSelected,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      onTap: () => setState(() => _paymentMethod = value),
      child: Row(
        children: [
          Icon(icon, color: isSelected ? AppColors.primary : AppColors.neutral500, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primaryDark : AppColors.neutral900,
              ),
            ),
          ),
          Icon(
            isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
            color: isSelected ? AppColors.primary : AppColors.neutral300,
            size: 20,
          ),
        ],
      ),
    );
  }
}
