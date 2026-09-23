import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../routes/route_paths.dart';

/// Sell Flow Root Screen: Select device category to start instant valuation.
class SellScreen extends StatelessWidget {
  const SellScreen({super.key});

  static const List<Map<String, dynamic>> categories = [
    {'title': 'Phone', 'icon': Icons.phone_android_rounded, 'tag': 'Most Popular'},
    {'title': 'Laptop', 'icon': Icons.laptop_mac_rounded, 'tag': 'Upto ₹65,000'},
    {'title': 'Tablet', 'icon': Icons.tablet_mac_rounded, 'tag': 'Instant Cash'},
    {'title': 'Smartwatch', 'icon': Icons.watch_rounded, 'tag': 'Doorstep QC'},
    {'title': 'Earbuds', 'icon': Icons.headphones_rounded, 'tag': 'Best Value'},
    {'title': 'Console', 'icon': Icons.sports_esports_rounded, 'tag': 'Fast Pickup'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Sell Your Device',
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Select What You Want To Sell',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            const Text(
              'Choose your product category to get an instant AI quote',
              style: TextStyle(fontSize: 13, color: AppColors.neutral700),
            ),
            const SizedBox(height: AppSpacing.lg),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                childAspectRatio: 1.15,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                return AppCard(
                  onTap: () {
                    context.push(RoutePaths.sellBrands);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: AppSpacing.roundedMd,
                        ),
                        child: Icon(cat['icon'] as IconData, color: AppColors.primaryDark, size: 28),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        cat['title'] as String,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        cat['tag'] as String,
                        style: const TextStyle(fontSize: 11, color: AppColors.primaryDark, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
