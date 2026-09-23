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

/// Screen displaying customer saved wishlist items.
class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlist = ref.watch(wishlistNotifierProvider);
    final apiService = ref.watch(marketplaceApiServiceProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'My Wishlist'),
      body: wishlist.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border_rounded, size: 64, color: AppColors.neutral300),
                  const SizedBox(height: AppSpacing.md),
                  const Text('Your wishlist is empty', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  const Text('Save items you want to buy later', style: TextStyle(color: AppColors.neutral500, fontSize: 13)),
                  const SizedBox(height: AppSpacing.lg),
                  ElevatedButton(
                    onPressed: () => context.go(RoutePaths.buy),
                    child: const Text('Explore Deals'),
                  ),
                ],
              ),
            )
          : FutureBuilder<List<RefurbishedProductModel>>(
              future: apiService.getProducts(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                }

                final savedItems = snapshot.data!.where((p) => wishlist.contains(p.id)).toList();

                return ListView.separated(
                  padding: AppSpacing.screenPadding,
                  itemCount: savedItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final item = savedItems[index];

                    return AppCard(
                      child: Row(
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
                                BadgePill(text: item.gradeText, type: item.grade),
                                const SizedBox(height: 2),
                                Text(
                                  item.title,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  CurrencyFormatter.format(item.price),
                                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
                                onPressed: () {
                                  ref.read(wishlistNotifierProvider.notifier).toggleWishlist(item.id);
                                },
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  minimumSize: const Size(80, 32),
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  shape: RoundedRectangleBorder(borderRadius: AppSpacing.roundedSm),
                                ),
                                onPressed: () {
                                  ref.read(cartNotifierProvider.notifier).addToCart(item);
                                  ref.read(wishlistNotifierProvider.notifier).toggleWishlist(item.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${item.title} moved to cart!')),
                                  );
                                },
                                child: const Text('Move to Cart', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
