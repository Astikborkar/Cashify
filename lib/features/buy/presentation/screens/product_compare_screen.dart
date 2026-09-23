import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/custom_app_bar.dart';

/// Screen comparing specifications and prices of certified refurbished models side-by-side.
class ProductCompareScreen extends StatelessWidget {
  const ProductCompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Compare Devices'),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          children: [
            // Side by Side Header Cards
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    child: Column(
                      children: [
                        const Icon(Icons.phone_iphone_rounded, size: 48, color: AppColors.neutral700),
                        const SizedBox(height: 6),
                        const Text('iPhone 13', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                        const Text('128 GB', style: TextStyle(fontSize: 11, color: AppColors.neutral500)),
                        const SizedBox(height: 4),
                        Text(
                          CurrencyFormatter.format(38999),
                          style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primaryDark),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppCard(
                    child: Column(
                      children: [
                        const Icon(Icons.phone_android_rounded, size: 48, color: AppColors.neutral700),
                        const SizedBox(height: 6),
                        const Text('Galaxy S22 Ultra', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                        const Text('256 GB', style: TextStyle(fontSize: 11, color: AppColors.neutral500)),
                        const SizedBox(height: 4),
                        Text(
                          CurrencyFormatter.format(47999),
                          style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primaryDark),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // Comparison Rows
            _buildCompareRow('Display', '6.1" OLED 60Hz', '6.8" AMOLED 120Hz'),
            _buildCompareRow('Processor', 'Apple A15 Bionic', 'Snapdragon 8 Gen 1'),
            _buildCompareRow('Main Camera', 'Dual 12MP + 12MP', 'Quad 108MP + 12MP'),
            _buildCompareRow('Battery', '3,240 mAh', '5,000 mAh'),
            _buildCompareRow('Quality Grade', 'Superb (Like New)', 'Superb (Like New)'),
            _buildCompareRow('Warranty', '6 Months Free', '6 Months Free'),
            _buildCompareRow('Original MRP', '₹ 59,900', '₹ 1,09,999'),
            _buildCompareRow('Savings', '35% Discount', '56% Discount'),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildCompareRow(String feature, String val1, String val2) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          color: AppColors.neutral100,
          child: Text(
            feature,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.neutral700),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(val1, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(val2, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
