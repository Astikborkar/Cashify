import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../routes/route_paths.dart';

/// Screen confirming placed purchase order with order ID, delivery estimate, and invoice download.
class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Animated Success Icon
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primaryDark,
                  size: 54,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'Order Confirmed!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              const Text(
                'Thank you for shopping with Cashify! Your certified refurbished device is being prepared for dispatch.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.neutral700, height: 1.4),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Order Details Summary Card
              AppCard(
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order Reference:', style: TextStyle(fontSize: 13, color: AppColors.neutral500)),
                        Text('#CSH-981248', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.neutral900)),
                      ],
                    ),
                    const Divider(height: 16),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Estimated Delivery:', style: TextStyle(fontSize: 13, color: AppColors.neutral500)),
                        Text('Thursday, 26 Sep', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
                      ],
                    ),
                    const Divider(height: 16),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Warranty Certificate:', style: TextStyle(fontSize: 13, color: AppColors.neutral500)),
                        Text('6 Months Doorstep', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              OutlinedButton.icon(
                icon: const Icon(Icons.download_rounded, size: 18),
                label: const Text('Download Invoice PDF'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(46),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Downloading invoice #CSH-981248.pdf...')),
                  );
                },
              ),

              const Spacer(),

              AppButton(
                text: 'Track Order Status',
                onPressed: () => context.go(RoutePaths.profile),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                text: 'Continue Shopping',
                variant: ButtonVariant.ghost,
                onPressed: () => context.go(RoutePaths.buy),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
