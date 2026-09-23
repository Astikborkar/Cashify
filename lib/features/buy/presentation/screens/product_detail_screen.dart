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
import '../../cart/presentation/providers/cart_provider.dart';
import '../data/services/marketplace_api_service.dart';
import '../domain/models/refurbished_product_model.dart';
import '../providers/marketplace_provider.dart';

/// Screen displaying high-resolution details, 32-point inspection certificate, and warranty terms.
class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _selectedStorageIndex = 0;
  int _selectedColorIndex = 0;
  bool _addExtendedWarranty = false;
  BadgeType _selectedGrade = BadgeType.gradeSuperb;

  @override
  Widget build(BuildContext context) {
    final apiService = ref.watch(marketplaceApiServiceProvider);
    final wishlist = ref.watch(wishlistNotifierProvider);
    final isWishlisted = wishlist.contains(widget.productId);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Product Details',
        actions: [
          IconButton(
            icon: Icon(
              isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isWishlisted ? AppColors.error : AppColors.neutral900,
            ),
            onPressed: () {
              ref.read(wishlistNotifierProvider.notifier).toggleWishlist(widget.productId);
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.neutral900),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<RefurbishedProductModel?>(
        future: apiService.getProductById(widget.productId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          final product = snapshot.data!;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: AppSpacing.screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image Carousel Placeholder
                      Center(
                        child: Container(
                          width: double.infinity,
                          height: 240,
                          decoration: BoxDecoration(
                            color: AppColors.neutral100,
                            borderRadius: AppSpacing.roundedLg,
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Icon(Icons.phone_iphone_rounded, size: 120, color: AppColors.neutral700),
                              ),
                              Positioned(
                                top: 12,
                                left: 12,
                                child: BadgePill(text: product.gradeText, type: _selectedGrade),
                              ),
                              Positioned(
                                top: 12,
                                right: 12,
                                child: BadgePill(text: '${product.discountPercent.toInt()}% OFF', type: BadgeType.discount),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // Title & Ratings
                      Text(
                        product.title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, height: 1.3),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: AppSpacing.roundedSm,
                            ),
                            child: Row(
                              children: [
                                Text('${product.rating}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                                const SizedBox(width: 2),
                                const Icon(Icons.star_rounded, color: Colors.white, size: 12),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('${product.reviewsCount} verified reviews', style: const TextStyle(fontSize: 12, color: AppColors.neutral500)),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // Price Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            CurrencyFormatter.format(product.price),
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.neutral900),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            CurrencyFormatter.format(product.mrp),
                            style: const TextStyle(fontSize: 14, decoration: TextDecoration.lineThrough, color: AppColors.neutral500),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Save ${CurrencyFormatter.format(product.mrp - product.price)}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                          ),
                        ],
                      ),
                      Text(
                        'or No Cost EMI starting from ₹${product.emiPerMonth.toInt()}/month',
                        style: const TextStyle(fontSize: 12, color: AppColors.neutral700),
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // Grade Selector
                      const Text('Choose Refurbished Grade', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          _buildGradeOption('Superb', 'Like new, no scratches', BadgeType.gradeSuperb),
                          const SizedBox(width: 8),
                          _buildGradeOption('Good', 'Minor hairline marks', BadgeType.gradeGood),
                          const SizedBox(width: 8),
                          _buildGradeOption('Fair', 'Visible body scuffs', BadgeType.gradeFair),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // Storage Capacity
                      const Text('Select Storage Capacity', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: 8,
                        children: List.generate(product.storageOptions.length, (index) {
                          final opt = product.storageOptions[index];
                          final isSelected = _selectedStorageIndex == index;
                          return ChoiceChip(
                            label: Text(opt),
                            selected: isSelected,
                            selectedColor: AppColors.primaryLight,
                            labelStyle: TextStyle(
                              color: isSelected ? AppColors.primaryDark : AppColors.neutral900,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              fontSize: 12,
                            ),
                            onSelected: (_) => setState(() => _selectedStorageIndex = index),
                          );
                        }),
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // 32-Point Quality Certification Card
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: AppSpacing.roundedLg,
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.verified_user_rounded, color: AppColors.primaryDark, size: 24),
                                const SizedBox(width: 8),
                                Text(
                                  '${product.qcPointsPassed}-Point Quality Certified',
                                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.primaryDark),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Screen, Touch, Camera, Speaker, Mic, Battery & Biometrics verified 100% functional by certified technicians.',
                              style: TextStyle(fontSize: 12, color: AppColors.neutral700),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // Accidental & Extended Warranty Addon
                      AppCard(
                        isSelected: _addExtendedWarranty,
                        onTap: () => setState(() => _addExtendedWarranty = !_addExtendedWarranty),
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Row(
                          children: [
                            const Icon(Icons.shield_rounded, color: AppColors.secondary, size: 28),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Add 1-Year Full Protection Plan',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    'Covers screen damage & liquid spills + 6 months warranty extension.',
                                    style: TextStyle(fontSize: 11, color: AppColors.neutral500),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '+ ₹999',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: _addExtendedWarranty ? AppColors.primaryDark : AppColors.neutral900,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              _addExtendedWarranty ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                              color: _addExtendedWarranty ? AppColors.primary : AppColors.neutral500,
                              size: 22,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // Technical Hardware Specifications
                      const Text('Technical Specifications', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: AppSpacing.sm),
                      AppCard(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: product.specs.entries.map((entry) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 90,
                                        child: Text(
                                          entry.key,
                                          style: const TextStyle(fontSize: 12, color: AppColors.neutral500, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          entry.value,
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.neutral900),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(height: 1),
                              ],
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),

              // Sticky Bottom Action Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceLight,
                  boxShadow: [
                    BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, -4)),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(borderRadius: AppSpacing.roundedMd),
                            minimumSize: const Size.fromHeight(48),
                          ),
                          onPressed: () {
                            ref.read(cartNotifierProvider.notifier).addToCart(
                              product,
                              hasWarrantyUpgrade: _addExtendedWarranty,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.title} added to cart!'),
                                action: SnackBarAction(
                                  label: 'View Cart',
                                  textColor: Colors.white,
                                  onPressed: () => context.push(RoutePaths.cart),
                                ),
                              ),
                            );
                          },
                          child: const Text('Add to Cart', style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: AppSpacing.roundedMd),
                            minimumSize: const Size.fromHeight(48),
                          ),
                          onPressed: () {
                            ref.read(cartNotifierProvider.notifier).addToCart(
                              product,
                              hasWarrantyUpgrade: _addExtendedWarranty,
                            );
                            context.push(RoutePaths.cart);
                          },
                          child: const Text('Buy Now', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGradeOption(String title, String desc, BadgeType grade) {
    final isSelected = _selectedGrade == grade;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedGrade = grade),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryLight : AppColors.surfaceLight,
            borderRadius: AppSpacing.roundedMd,
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.borderLight,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? AppColors.primaryDark : AppColors.neutral900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: const TextStyle(fontSize: 10, color: AppColors.neutral500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
