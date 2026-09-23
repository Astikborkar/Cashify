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
import '../data/services/repair_api_service.dart';
import '../presentation/providers/repair_flow_provider.dart';

/// Screen for Doorstep Repair Services with device selection and issue highlights.
class RepairScreen extends ConsumerWidget {
  const RepairScreen({super.key});

  static const List<String> popularDevices = [
    'iPhone 13',
    'iPhone 14',
    'Galaxy S22',
    'OnePlus 11R',
    'Pixel 7',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repairState = ref.watch(repairFlowNotifierProvider);
    final apiService = ref.watch(repairApiServiceProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Doorstep Repair Services',
        showBackButton: false,
        actions: [
          if (repairState.activeOrder != null)
            TextButton.icon(
              icon: const Icon(Icons.location_on_rounded, size: 16, color: AppColors.primary),
              label: const Text('Live Track', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
              onPressed: () => context.push(
                RoutePaths.repairTracking.replaceAll(':orderId', repairState.activeOrder!.orderId),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trust Hero Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE65100), Color(0xFFFFB300)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: AppSpacing.roundedLg,
              ),
              child: const Row(
                children: [
                  Icon(Icons.build_circle_rounded, color: Colors.white, size: 44),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Phone Fixed at Your Doorstep',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.white),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Screen & battery replacement in 45 mins. OEM certified parts with 6-month warranty.',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Device Picker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Select Your Phone', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                TextButton(
                  onPressed: () {},
                  child: const Text('Change Model ▾', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: popularDevices.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final dev = popularDevices[index];
                  final isSelected = repairState.selectedDeviceModel == dev;
                  return ChoiceChip(
                    label: Text(dev),
                    selected: isSelected,
                    selectedColor: AppColors.primaryLight,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primaryDark : AppColors.neutral900,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 12,
                    ),
                    onSelected: (_) => ref.read(repairFlowNotifierProvider.notifier).setDeviceModel(dev),
                  );
                },
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Issues Catalog
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Common Repair Issues', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const BadgePill(text: '15% COMBO OFF', type: BadgeType.discount),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            FutureBuilder(
              future: apiService.getRepairIssues(repairState.selectedDeviceModel),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                }

                final issues = snapshot.data!;

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: issues.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
                  itemBuilder: (context, index) {
                    final issue = issues[index];
                    final isSelected = repairState.selectedIssues.any((i) => i.id == issue.id);

                    return AppCard(
                      isSelected: isSelected,
                      onTap: () {
                        ref.read(repairFlowNotifierProvider.notifier).toggleIssue(issue);
                      },
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primaryLight : AppColors.neutral100,
                              borderRadius: AppSpacing.roundedSm,
                            ),
                            child: Icon(
                              issue.icon,
                              color: isSelected ? AppColors.primaryDark : AppColors.neutral700,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  issue.name,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  '${issue.warrantyMonths} Mo Warranty • ${issue.turnaroundMinutes} Mins Doorstep',
                                  style: const TextStyle(fontSize: 11, color: AppColors.primaryDark, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                CurrencyFormatter.format(issue.totalPrice),
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.neutral900),
                              ),
                              Icon(
                                isSelected ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
                                color: isSelected ? AppColors.primary : AppColors.neutral500,
                                size: 18,
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

            const SizedBox(height: AppSpacing.xl),

            if (repairState.selectedIssues.isNotEmpty) ...[
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                backgroundColor: AppColors.primaryLight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${repairState.selectedIssues.length} issues selected',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.neutral700),
                        ),
                        Text(
                          CurrencyFormatter.format(repairState.totalEstimatedCost),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primaryDark),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: AppSpacing.roundedMd),
                      ),
                      onPressed: () => context.push(RoutePaths.repairBooking),
                      child: const Text('Book Doorstep Slot →', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ],
        ),
      ),
    );
  }
}
