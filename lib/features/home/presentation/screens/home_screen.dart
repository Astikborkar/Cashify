import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../routes/route_paths.dart';
import '../providers/home_provider.dart';
import '../widgets/banner_slider_widget.dart';
import '../widgets/category_grid_widget.dart';
import '../widgets/city_selector_bottom_sheet.dart';
import '../widgets/refurbished_deals_section.dart';
import '../widgets/trending_sell_section.dart';

/// Dynamic Home Dashboard powered by Riverpod HomeNotifier.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _showCitySelector(BuildContext context, WidgetRef ref, String currentCity) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CitySelectorBottomSheet(
        currentCity: currentCity,
        onCitySelected: (city, pincode) {
          ref.read(homeNotifierProvider.notifier).updateLocation(city, pincode);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: AppSpacing.md,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: AppSpacing.roundedSm,
              ),
              child: const Icon(Icons.flash_on_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: AppSpacing.sm),
            GestureDetector(
              onTap: () => _showCitySelector(context, ref, homeState.selectedCity),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cashify',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.neutral900,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${homeState.selectedCity}, ${homeState.selectedPincode}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.primaryDark),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: AppColors.neutral900),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.neutral900),
            onPressed: () => context.push(RoutePaths.cart),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => ref.read(homeNotifierProvider.notifier).loadHomeData(),
        child: homeState.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Input Trigger
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: AppCard(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        borderRadius: AppSpacing.roundedMd,
                        onTap: () => context.push(RoutePaths.search),
                        child: const Row(
                          children: [
                            Icon(Icons.search_rounded, color: AppColors.neutral500),
                            SizedBox(width: 10),
                            Text(
                              'Search phone models, repairs, deals...',
                              style: TextStyle(color: AppColors.neutral500, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // 1. Hero Banners Carousel
                    BannerSliderWidget(banners: homeState.banners),

                    const SizedBox(height: AppSpacing.lg),

                    // 2. Core Service Category Grid
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: const Text(
                        'What would you like to do?',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    CategoryGridWidget(categories: homeState.categories),

                    const SizedBox(height: AppSpacing.lg),

                    // 3. Trending Buyback Section (Sell Phone)
                    TrendingSellSection(devices: homeState.trendingSellDevices),

                    const SizedBox(height: AppSpacing.lg),

                    // 4. Certified Refurbished Deals (Buy Phone)
                    RefurbishedDealsSection(deals: homeState.refurbishedHotDeals),

                    const SizedBox(height: AppSpacing.lg),

                    // 5. Why Choose Cashify Trust Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: AppSpacing.roundedLg,
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Why Trust Cashify?',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: AppSpacing.md),
                            Row(
                              children: [
                                _TrustItem(
                                  icon: Icons.payments_rounded,
                                  title: 'Instant Payout',
                                  subtitle: 'Direct to UPI / Bank',
                                ),
                                _TrustItem(
                                  icon: Icons.local_shipping_rounded,
                                  title: 'Free Pickup',
                                  subtitle: 'At your doorstep',
                                ),
                              ],
                            ),
                            SizedBox(height: AppSpacing.md),
                            Row(
                              children: [
                                _TrustItem(
                                  icon: Icons.verified_user_rounded,
                                  title: '32-Pt Inspection',
                                  subtitle: 'Certified Quality',
                                ),
                                _TrustItem(
                                  icon: Icons.security_rounded,
                                  title: '6 Mo Warranty',
                                  subtitle: '7-Day Replacement',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
      ),
    );
  }
}

class _TrustItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _TrustItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: AppSpacing.roundedSm,
            ),
            child: Icon(icon, size: 20, color: AppColors.primaryDark),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: AppColors.neutral500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
