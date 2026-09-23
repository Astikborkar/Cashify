import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../routes/route_paths.dart';
import '../../data/services/sell_api_service.dart';
import '../providers/sell_flow_provider.dart';

/// Screen 1 of Sell Flow: Select device brand with search filter.
class SellBrandsScreen extends ConsumerStatefulWidget {
  const SellBrandsScreen({super.key});

  @override
  ConsumerState<SellBrandsScreen> createState() => _SellBrandsScreenState();
}

class _SellBrandsScreenState extends ConsumerState<SellBrandsScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final apiService = ref.watch(sellApiServiceProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Select Brand'),
      body: FutureBuilder(
        future: apiService.getBrands('cat_sell_phone'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          final allBrands = snapshot.data!;
          final filtered = allBrands.where((b) => b.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

          return Column(
            children: [
              Padding(
                padding: AppSpacing.screenPadding,
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: const InputDecoration(
                    hintText: 'Search brand (e.g. Apple, Samsung)...',
                    prefixIcon: Icon(Icons.search_rounded, color: AppColors.neutral500),
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: AppSpacing.screenPadding,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    childAspectRatio: 1.4,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final brand = filtered[index];
                    return AppCard(
                      onTap: () {
                        ref.read(sellFlowNotifierProvider.notifier).setBrand(brand);
                        context.push(RoutePaths.sellModels);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.neutral100,
                              borderRadius: AppSpacing.roundedSm,
                            ),
                            child: const Icon(Icons.phone_android_rounded, size: 28, color: AppColors.neutral700),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            brand.name,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            '${brand.modelsCount} models',
                            style: const TextStyle(fontSize: 11, color: AppColors.neutral500),
                          ),
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
