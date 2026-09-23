import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../routes/route_paths.dart';
import '../../data/services/sell_api_service.dart';
import '../providers/sell_flow_provider.dart';

/// Screen 2 of Sell Flow: Select specific model under the chosen brand.
class SellModelsScreen extends ConsumerStatefulWidget {
  const SellModelsScreen({super.key});

  @override
  ConsumerState<SellModelsScreen> createState() => _SellModelsScreenState();
}

class _SellModelsScreenState extends ConsumerState<SellModelsScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final sellState = ref.watch(sellFlowNotifierProvider);
    final apiService = ref.watch(sellApiServiceProvider);
    final brand = sellState.selectedBrand;

    final brandId = brand?.id ?? 'br_apple';
    final brandName = brand?.name ?? 'Apple';

    return Scaffold(
      appBar: CustomAppBar(title: 'Select $brandName Model'),
      body: FutureBuilder(
        future: apiService.getModels(brandId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          final allModels = snapshot.data!;
          final filtered = allModels.where((m) => m.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

          return Column(
            children: [
              Padding(
                padding: AppSpacing.screenPadding,
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search $brandName model...',
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.neutral500),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: AppSpacing.screenPadding,
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final model = filtered[index];
                    return AppCard(
                      onTap: () {
                        ref.read(sellFlowNotifierProvider.notifier).setModel(model);
                        context.push(RoutePaths.sellVariants);
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: AppColors.neutral100,
                              borderRadius: AppSpacing.roundedSm,
                            ),
                            child: const Center(
                              child: Icon(Icons.phone_iphone_rounded, color: AppColors.neutral700, size: 28),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  model.name,
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  model.series,
                                  style: const TextStyle(fontSize: 12, color: AppColors.neutral500),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Upto', style: TextStyle(fontSize: 10, color: AppColors.neutral500)),
                              Text(
                                CurrencyFormatter.format(model.baseResalePrice),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.neutral500),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
