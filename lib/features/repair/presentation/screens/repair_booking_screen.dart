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
import '../providers/repair_flow_provider.dart';

/// Screen for selecting doorstep repair address, appointment time slot, and booking confirmation.
class RepairBookingScreen extends ConsumerStatefulWidget {
  const RepairBookingScreen({super.key});

  @override
  ConsumerState<RepairBookingScreen> createState() => _RepairBookingScreenState();
}

class _RepairBookingScreenState extends ConsumerState<RepairBookingScreen> {
  int _selectedDateIndex = 0;
  int _selectedSlotIndex = 0;

  final dates = [
    {'day': 'Today', 'date': '24 Sep'},
    {'day': 'Tomorrow', 'date': '25 Sep'},
    {'day': 'Wednesday', 'date': '26 Sep'},
  ];

  final timeSlots = [
    '10:00 AM - 12:00 PM',
    '12:00 PM - 02:00 PM',
    '02:00 PM - 04:00 PM',
    '04:00 PM - 06:00 PM',
  ];

  Future<void> _handleConfirm() async {
    final success = await ref.read(repairFlowNotifierProvider.notifier).bookRepair(
      address: '#402, Green View Apts, Indiranagar, Bengaluru - 560038',
      date: dates[_selectedDateIndex]['day']!,
      slot: timeSlots[_selectedSlotIndex],
    );

    if (!mounted) return;

    if (success) {
      final orderId = ref.read(repairFlowNotifierProvider).activeOrder?.orderId ?? 'REP-84920';
      context.push(RoutePaths.repairTracking.replaceAll(':orderId', orderId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final repairState = ref.watch(repairFlowNotifierProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Book Repair Slot'),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selected Issues Review Card
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        repairState.selectedDeviceModel,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                      ),
                      const BadgePill(text: '6-Mo Warranty', type: BadgeType.warranty),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ...repairState.selectedIssues.map((issue) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Expanded(child: Text(issue.name, style: const TextStyle(fontSize: 13))),
                          Text(CurrencyFormatter.format(issue.totalPrice), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    );
                  }),
                  if (repairState.bundleDiscount > 0) ...[
                    const Divider(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('15% Combo Labor Discount:', style: TextStyle(fontSize: 13, color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                        Text('- ${CurrencyFormatter.format(repairState.bundleDiscount)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primaryDark)),
                      ],
                    ),
                  ],
                  const Divider(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Estimated Cost:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                      Text(
                        CurrencyFormatter.format(repairState.totalEstimatedCost),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.neutral900),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Doorstep Address
            const Text('Doorstep Repair Location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: AppSpacing.sm),
            AppCard(
              child: Row(
                children: [
                  const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 24),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Home Location', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                        Text(
                          '#402, Green View Apts, 12th Main, Indiranagar, Bengaluru - 560038',
                          style: TextStyle(fontSize: 12, color: AppColors.neutral700),
                        ),
                      ],
                    ),
                  ),
                  TextButton(onPressed: () {}, child: const Text('Change')),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Date Selection
            const Text('Select Date', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: List.generate(dates.length, (index) {
                final d = dates[index];
                final isSelected = _selectedDateIndex == index;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: index < dates.length - 1 ? 8 : 0),
                    child: AppCard(
                      isSelected: isSelected,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      onTap: () => setState(() => _selectedDateIndex = index),
                      child: Column(
                        children: [
                          Text(d['day']!, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? AppColors.primaryDark : AppColors.neutral700)),
                          Text(d['date']!, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: isSelected ? AppColors.primaryDark : AppColors.neutral900)),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Time Slot Selection
            const Text('Select Time Slot', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(timeSlots.length, (index) {
                final s = timeSlots[index];
                final isSelected = _selectedSlotIndex == index;
                return ChoiceChip(
                  label: Text(s),
                  selected: isSelected,
                  selectedColor: AppColors.primaryLight,
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primaryDark : AppColors.neutral900,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 12,
                  ),
                  onSelected: (_) => setState(() => _selectedSlotIndex = index),
                );
              }),
            ),

            const SizedBox(height: AppSpacing.xl),

            AppButton(
              text: 'Confirm Doorstep Repair Booking',
              isLoading: repairState.isBooking,
              onPressed: _handleConfirm,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
