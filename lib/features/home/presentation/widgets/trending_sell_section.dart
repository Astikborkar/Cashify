import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/badge_pill.dart';
import '../../../../routes/route_paths.dart';
import '../../domain/models/trending_sell_device_model.dart';

/// Horizontal carousel displaying popular trade-in models and instant estimated buyback quotes.
class TrendingSellSection extends StatelessWidget {
  final List<TrendingSellDeviceModel> devices;

  const TrendingSellSection({
    super.key,
    required this.devices,
  });

  @override
  Widget build(BuildContext context) {
    if (devices.isEmpty) return const SizedBox.shrink();

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
                    'Trending Buyback Phones',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Get guaranteed maximum value today',
                    style: TextStyle(fontSize: 12, color: AppColors.neutral700),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => context.go(RoutePaths.sell),
                child: const Text('View All →', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 195,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            scrollDirection: Axis.horizontal,
            itemCount: devices.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              final item = devices[index];
              return Container(
                width: 165,
                child: AppCard(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  onTap: () => context.go(RoutePaths.sell),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BadgePill(text: item.badge, type: BadgeType.gradeSuperb),
                          const Icon(Icons.bolt_rounded, size: 16, color: AppColors.accent),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Center(
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppColors.neutral100,
                            borderRadius: AppSpacing.roundedSm,
                          ),
                          child: const Icon(Icons.phone_iphone_rounded, size: 32, color: AppColors.neutral700),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.modelName,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            item.variantInfo,
                            style: const TextStyle(fontSize: 11, color: AppColors.neutral500),
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: AppSpacing.roundedSm,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Get up to', style: TextStyle(fontSize: 9, color: AppColors.neutral700)),
                            Text(
                              CurrencyFormatter.format(item.maxQuotePrice),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ],
                        ),
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
