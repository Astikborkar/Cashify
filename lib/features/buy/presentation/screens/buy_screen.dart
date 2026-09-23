import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/badge_pill.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../routes/route_paths.dart';
import '../domain/models/refurbished_product_model.dart';
import '../providers/marketplace_provider.dart';

/// Screen for browsing certified refurbished electronics with filters, sorting, and grades.
class BuyScreen extends ConsumerWidget {
  const BuyScreen({super.key});

  static const List<String> brands = ['All', 'Apple', 'Samsung', 'OnePlus', 'Google'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(marketplaceNotifierProvider);
    final notifier = ref.read(marketplaceNotifierProvider.notifier);
    final wishlist = ref.watch(wishlistNotifierProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Certified Refurbished',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.compare_arrows_rounded, color: AppColors.neutral900),
            onPressed: () => context.push(RoutePaths.productCompare),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border_rounded, color: AppColors.neutral900),
            onPressed: () => context.push(RoutePaths.wishlist),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.neutral900),
            onPressed: () => context.push(RoutePaths.cart),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // Filter Bar 1: Brands
          SizedBox(
            height: 48,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
              scrollDirection: Axis.horizontal,
              itemCount: brands.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final b = brands[index];
                final isSelected = filterState.selectedBrand == b;
                return ChoiceChip(
                  label: Text(b),
                  selected: isSelected,
                  selectedColor: AppColors.primaryLight,
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primaryDark : AppColors.neutral900,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 12,
                  ),
                  onSelected: (_) => notifier.setBrand(b),
                );
              },
            ),
          ),

          // Filter Bar 2: Grades & Sort
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
            child: Row(
              children: [
                _buildGradeFilterChip(
                  label: 'All Grades',
                  isSelected: filterState.selectedGrade == null,
                  onTap: () => notifier.setGrade(null),
                ),
                const SizedBox(width: 6),
                _buildGradeFilterChip(
                  label: 'Superb',
                  isSelected: filterState.selectedGrade == BadgeType.gradeSuperb,
                  onTap: () => notifier.setGrade(BadgeType.gradeSuperb),
                ),
                const SizedBox(width: 6),
                _buildGradeFilterChip(
                  label: 'Good',
                  isSelected: filterState.selectedGrade == BadgeType.gradeGood,
                  onTap: () => notifier.setGrade(BadgeType.gradeGood),
                ),
                const SizedBox(width: 6),
                _buildGradeFilterChip(
                  label: 'Fair',
                  isSelected: filterState.selectedGrade == BadgeType.gradeFair,
                  onTap: () => notifier.setGrade(BadgeType.gradeFair),
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.sort_rounded, size: 20, color: AppColors.neutral700),
                  onSelected: (val) => notifier.setSortBy(val),
                  itemBuilder: (ctx) => [
                    const PopupMenuItem(value: 'popularity', child: Text('Most Popular')),
                    const PopupMenuItem(value: 'price_low_high', child: Text('Price: Low to High')),
                    const PopupMenuItem(value: 'price_high_low', child: Text('Price: High to Low')),
                    const PopupMenuItem(value: 'discount', child: Text('Highest Discount')),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Products List
          Expanded(
            child: filterState.isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : filterState.products.isEmpty
                    ? const Center(
                        child: Text('No devices found matching your filters.', style: TextStyle(color: AppColors.neutral500)),
                      )
                    : RefreshIndicator(
                        color: AppColors.primary,
                        onRefresh: () => notifier.fetchProducts(),
                        child: ListView.separated(
                          padding: AppSpacing.screenPadding,
                          itemCount: filterState.products.length,
                          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                          itemBuilder: (context, index) {
                            final product = filterState.products[index];
                            final isFav = wishlist.contains(product.id);

                            return AppCard(
                              onTap: () {
                                context.push(RoutePaths.productDetail.replaceAll(':id', product.id));
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product Thumbnail
                                  Container(
                                    width: 90,
                                    height: 115,
                                    decoration: BoxDecoration(
                                      color: AppColors.neutral100,
                                      borderRadius: AppSpacing.roundedMd,
                                    ),
                                    child: Center(
                                      child: Icon(Icons.phone_iphone_rounded, size: 50, color: AppColors.neutral700),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  // Info Column
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            BadgePill(text: product.gradeText, type: product.grade),
                                            GestureDetector(
                                              onTap: () {
                                                ref.read(wishlistNotifierProvider.notifier).toggleWishlist(product.id);
                                              },
                                              child: Icon(
                                                isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                                size: 20,
                                                color: isFav ? AppColors.error : AppColors.neutral500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: AppSpacing.xs),
                                        Text(
                                          product.title,
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: AppSpacing.xs),
                                        Row(
                                          children: [
                                            Text(
                                              CurrencyFormatter.format(product.price),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                                color: AppColors.neutral900,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              CurrencyFormatter.format(product.mrp),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                decoration: TextDecoration.lineThrough,
                                                color: AppColors.neutral500,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              '${product.discountPercent.toInt()}% off',
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.error,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(Icons.verified_rounded, size: 13, color: AppColors.primaryDark),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${product.warrantyMonths} Mo Warranty • 32-Pt QC',
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.primaryDark,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : Colors.transparent,
          borderRadius: AppSpacing.roundedPill,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? AppColors.primaryDark : AppColors.neutral700,
          ),
        ),
      ),
    );
  }
}
