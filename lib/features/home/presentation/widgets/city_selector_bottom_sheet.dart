import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// Modal bottom sheet allowing users to switch active delivery & pickup city.
class CitySelectorBottomSheet extends StatelessWidget {
  final String currentCity;
  final Function(String city, String pincode) onCitySelected;

  const CitySelectorBottomSheet({
    super.key,
    required this.currentCity,
    required this.onCitySelected,
  });

  static const List<Map<String, String>> popularCities = [
    {'name': 'Bengaluru', 'pincode': '560001', 'state': 'Karnataka'},
    {'name': 'Delhi NCR', 'pincode': '110001', 'state': 'Delhi'},
    {'name': 'Mumbai', 'pincode': '400001', 'state': 'Maharashtra'},
    {'name': 'Hyderabad', 'pincode': '500001', 'state': 'Telangana'},
    {'name': 'Pune', 'pincode': '411001', 'state': 'Maharashtra'},
    {'name': 'Chennai', 'pincode': '600001', 'state': 'Tamil Nadu'},
    {'name': 'Kolkata', 'pincode': '700001', 'state': 'West Bengal'},
    {'name': 'Ahmedabad', 'pincode': '380001', 'state': 'Gujarat'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Select Your City',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 22),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // Auto-detect GPS button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: AppSpacing.roundedMd,
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.my_location_rounded, color: AppColors.primaryDark, size: 22),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Use Current Location',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.primaryDark),
                      ),
                      Text(
                        'Using GPS for exact doorstep serviceability',
                        style: TextStyle(fontSize: 11, color: AppColors.neutral700),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    onCitySelected('Bengaluru', '560001');
                    Navigator.pop(context);
                  },
                  child: const Text('Detect', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Popular Metro Cities',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.neutral700),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: popularCities.map((c) {
              final isSelected = c['name'] == currentCity;
              return ChoiceChip(
                label: Text(c['name']!),
                selected: isSelected,
                selectedColor: AppColors.primaryLight,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primaryDark : AppColors.neutral900,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 13,
                ),
                onSelected: (_) {
                  onCitySelected(c['name']!, c['pincode']!);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
