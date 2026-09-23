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
import '../providers/sell_flow_provider.dart';

/// Screen 6 of Sell Flow: Display evaluated instant AI quote with itemized breakdown and price lock.
class SellQuoteScreen extends ConsumerStatefulWidget {
  const SellQuoteScreen({super.key});

  @override
  ConsumerState<SellQuoteScreen> createState() => _SellQuoteScreenState();
}

class _SellQuoteScreenState extends ConsumerState<SellQuoteScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _priceAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    final finalPrice = ref.read(sellFlowNotifierProvider).calculatedQuote?.finalOfferPrice ?? 28400.0;
    _priceAnimation = Tween<double>(begin: 0, end: finalPrice).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutExpo),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sellState = ref.watch(sellFlowNotifierProvider);
    final quote = sellState.calculatedQuote;
    final modelName = sellState.selectedModel?.name ?? 'Apple iPhone 13';
    final variantLabel = sellState.selectedVariant?.label ?? '128 GB';

    return Scaffold(
      appBar: const CustomAppBar(title: 'Evaluated Cash Offer'),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          children: [
            // Quote Hero Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF009624), Color(0xFF00C853)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: AppSpacing.roundedLg,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1F00C853),
                    blurRadius: 20,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const BadgePill(
                    text: 'PRICE LOCKED FOR 7 DAYS',
                    type: BadgeType.custom,
                    backgroundColor: Colors.white,
                    textColor: AppColors.primaryDark,
                    icon: Icons.lock_clock_rounded,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    modelName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  Text(
                    variantLabel,
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AnimatedBuilder(
                    animation: _priceAnimation,
                    builder: (context, _) {
                      return Text(
                        CurrencyFormatter.format(_priceAnimation.value.round()),
                        style: const TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Instant Bank Transfer / UPI at Doorstep Handover',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Confidence & QC summary pill
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: Row(
                      children: [
                        const Icon(Icons.verified_rounded, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('AI Valuation', style: TextStyle(fontSize: 10, color: AppColors.neutral500)),
                            Text(
                              '${((quote?.confidenceScore ?? 0.96) * 100).toInt()}% Confidence',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppCard(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: Row(
                      children: [
                        const Icon(Icons.health_and_safety_rounded, color: AppColors.secondary, size: 20),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Health Score', style: TextStyle(fontSize: 10, color: AppColors.neutral500)),
                            Text(
                              '${quote?.deviceHealthScore ?? 92}/100 Rating',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // Detailed Price Breakdown
            if (quote != null) ...[
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Price Breakdown & Adjustments',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ...quote.adjustments.map((adj) {
                      final isBonus = adj.amount > 0 && adj.label != quote.adjustments.first.label;
                      final isDeduction = adj.amount < 0;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                adj.label,
                                style: const TextStyle(fontSize: 13, color: AppColors.neutral700),
                              ),
                            ),
                            Text(
                              isDeduction
                                  ? '- ${CurrencyFormatter.format(adj.amount.abs())}'
                                  : (isBonus ? '+ ${CurrencyFormatter.format(adj.amount)}' : CurrencyFormatter.format(adj.amount)),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isDeduction
                                    ? AppColors.error
                                    : (isBonus ? AppColors.primaryDark : AppColors.neutral900),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Final Take-Home Cash',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                        ),
                        Text(
                          CurrencyFormatter.format(quote.finalOfferPrice),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: AppSpacing.xl),

            // Continue CTA
            AppButton(
              text: 'Schedule Free Doorstep Pickup',
              onPressed: () => context.push(RoutePaths.sellPickupSchedule),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
