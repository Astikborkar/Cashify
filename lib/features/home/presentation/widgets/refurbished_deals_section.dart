import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/badge_pill.dart';
import '../../../../routes/route_paths.dart';
import '../../domain/models/product_summary_model.dart';

/// Section showing hot deals on certified refurbished electronics.
class RefurbishedDealsSection extends StatelessWidget {
  final List<ProductSummaryModel> deals;

  const RefurbishedDealsSection({
    super.key,
    required this.deals,
  });

  @override
  Widget build(BuildContext context) {
    if (deals.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Certified Refurbished Deals',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '32-point inspection • 6 Months Warranty',
                    style: TextStyle(fontSize: 12, color: AppColors.neutral700),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => context.go(RoutePaths.buy),
                child: const Text('Explore →', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 240,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            scrollDirection: Axis.horizontal,
            itemCount: deals.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              final product = deals[index];
              return Container(
                width: 175,
                child: AppCard(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  onTap: () => context.go(RoutePaths.buy),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top Badges
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BadgePill(text: product.gradeText, type: product.grade),
                          BadgePill(text: '${product.discountPercent.toInt()}% OFF', type: BadgeType.discount),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Product Image Box
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.neutral100,
                            borderRadius: AppSpacing.roundedMd,
                          ),
                          child: const Icon(Icons.phone_iphone_rounded, size: 44, color: AppColors.neutral700),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Title
                      Text(
                        product.title,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, height: 1.2),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // Price Row
                      Row(
                        children: [
                          Text(
                            CurrencyFormatter.format(product.refurbishedPrice),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.neutral900,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            CurrencyFormatter.format(product.mrp),
                            style: const TextStyle(
                              fontSize: 11,
                              decoration: TextDecoration.lineThrough,
                              color: AppColors.neutral500,
                            ),
                          ),
                        ],
                      ),
                      // Warranty Assurance
                      Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, size: 12, color: AppColors.primaryDark),
                          const SizedBox(width: 4),
                          Text(
                            '${product.warrantyMonths} Mo Warranty',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
