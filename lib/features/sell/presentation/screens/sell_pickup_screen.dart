import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/badge_pill.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../routes/route_paths.dart';
import '../providers/sell_flow_provider.dart';

/// Screen 7 of Sell Flow: Schedule pickup time slot and select payment method for doorstep payout.
class SellPickupScreen extends ConsumerStatefulWidget {
  const SellPickupScreen({super.key});

  @override
  ConsumerState<SellPickupScreen> createState() => _SellPickupScreenState();
}

class _SellPickupScreenState extends ConsumerState<SellPickupScreen> {
  int _selectedDateIndex = 0;
  int _selectedSlotIndex = 0;
  String _paymentMethod = 'upi';
  final _upiController = TextEditingController(text: 'rahul.sharma@okaxis');
  bool _isSubmitting = false;

  final dates = [
    {'day': 'Today', 'date': '24 Sep'},
    {'day': 'Tomorrow', 'date': '25 Sep'},
    {'day': 'Wednesday', 'date': '26 Sep'},
  ];

  final timeSlots = [
    '09:00 AM - 12:00 PM',
    '12:00 PM - 03:00 PM',
    '03:00 PM - 06:00 PM',
    'Express (Within 2 Hours)',
  ];

  @override
  void dispose() {
    _upiController.dispose();
    super.dispose();
  }

  Future<void> _handleConfirmPickup() async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: AppSpacing.roundedLg),
          title: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 28),
              SizedBox(width: 8),
              Text('Pickup Confirmed!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your pickup agent will arrive during your selected slot.'),
              const SizedBox(height: AppSpacing.md),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: AppSpacing.roundedMd,
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Handover Verification OTP', style: TextStyle(fontSize: 11, color: AppColors.neutral700)),
                    Text('8492', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.primaryDark)),
                    Text('Share this code with the pickup agent only upon inspection.', style: TextStyle(fontSize: 10, color: AppColors.neutral500)),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.go(RoutePaths.home);
              },
              child: const Text('Back to Home'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sellState = ref.watch(sellFlowNotifierProvider);
    final finalPrice = sellState.calculatedQuote?.finalOfferPrice ?? 28400.0;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Schedule Pickup'),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doorstep Address
            const Text(
              '1. Pickup Address',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppCard(
              child: Row(
                children: [
                  const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 24),
                  const SizedBox(width: AppSpacing.md),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Home (Default)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                        Text(
                          '#402, Green View Apts, 12th Main, Indiranagar, Bengaluru - 560038',
                          style: TextStyle(fontSize: 12, color: AppColors.neutral700),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Change', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Date Selection
            const Text(
              '2. Select Pickup Date',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: List.generate(dates.length, (index) {
                final d = dates[index];
                final isSelected = _selectedDateIndex == index;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: index < dates.length - 1 ? 8 : 0),
                    child: AppCard(
                      isSelected: isSelected,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      onTap: () => setState(() => _selectedDateIndex = index),
                      child: Column(
                        children: [
                          Text(
                            d['day']!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? AppColors.primaryDark : AppColors.neutral700,
                            ),
                          ),
                          Text(
                            d['date']!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: isSelected ? AppColors.primaryDark : AppColors.neutral900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Slot Selection
            const Text(
              '3. Select Time Slot',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(timeSlots.length, (index) {
                final slot = timeSlots[index];
                final isSelected = _selectedSlotIndex == index;
                return ChoiceChip(
                  label: Text(slot),
                  selected: isSelected,
                  selectedColor: AppColors.primaryLight,
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primaryDark : AppColors.neutral900,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 12,
                  ),
                  onSelected: (_) => setState(() => _selectedSlotIndex = index),
                );
              }),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Payout Method Choice
            const Text(
              '4. Instant Payout Method',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildPaymentRadio('upi', 'UPI ID (Instant Transfer)', Icons.account_balance_wallet_rounded),
            if (_paymentMethod == 'upi') ...[
              const SizedBox(height: AppSpacing.xs),
              AppTextField(
                controller: _upiController,
                hint: 'user@upi',
                prefix: const Icon(Icons.flash_on_rounded, size: 20, color: AppColors.primary),
              ),
            ],
            const SizedBox(height: AppSpacing.xs),
            _buildPaymentRadio('bank', 'Direct Bank IMPS Transfer', Icons.account_balance_rounded),
            const SizedBox(height: AppSpacing.xs),
            _buildPaymentRadio('wallet', 'Cashify Wallet (+5% Extra Cash Bonus)', Icons.card_giftcard_rounded),

            const SizedBox(height: AppSpacing.xl),

            // Summary Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.neutral100,
                borderRadius: AppSpacing.roundedMd,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Cash to Receive:', style: TextStyle(fontWeight: FontWeight.w600)),
                  Text(
                    CurrencyFormatter.format(finalPrice),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primaryDark),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            AppButton(
              text: 'Confirm Pickup & Lock Offer',
              isLoading: _isSubmitting,
              onPressed: _handleConfirmPickup,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentRadio(String value, String title, IconData icon) {
    final isSelected = _paymentMethod == value;
    return AppCard(
      isSelected: isSelected,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      onTap: () => setState(() => _paymentMethod = value),
      child: Row(
        children: [
          Icon(icon, color: isSelected ? AppColors.primary : AppColors.neutral500, size: 20),
          const SizedBox(width: 10),
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
