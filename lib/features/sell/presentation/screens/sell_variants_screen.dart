import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../routes/route_paths.dart';
import '../../data/services/sell_api_service.dart';
import '../../domain/models/condition_assessment.dart';
import '../../domain/models/device_catalog_models.dart';
import '../providers/sell_flow_provider.dart';

/// Screen 3 of Sell Flow: Choose storage variant, enter IMEI, and declare accessories.
class SellVariantsScreen extends ConsumerStatefulWidget {
  const SellVariantsScreen({super.key});

  @override
  ConsumerState<SellVariantsScreen> createState() => _SellVariantsScreenState();
}

class _SellVariantsScreenState extends ConsumerState<SellVariantsScreen> {
  final _imeiController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  VariantModel? _selectedVariant;
  WarrantyDuration _selectedWarranty = WarrantyDuration.outOfWarranty;
  bool _hasBox = true;
  bool _hasCharger = true;
  bool _hasBill = true;

  @override
  void dispose() {
    _imeiController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (_selectedVariant == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your storage variant')),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      final notifier = ref.read(sellFlowNotifierProvider.notifier);
      notifier.setVariant(_selectedVariant!);
      notifier.updateAssessment(
        ref.read(sellFlowNotifierProvider).assessment.copyWith(
          imei: _imeiController.text.trim(),
          warranty: _selectedWarranty,
          hasOriginalBox: _hasBox,
          hasOriginalCharger: _hasCharger,
          hasValidBill: _hasBill,
        ),
      );
      context.push(RoutePaths.sellQuestionnaire);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sellState = ref.watch(sellFlowNotifierProvider);
    final apiService = ref.watch(sellApiServiceProvider);
    final model = sellState.selectedModel;
    final modelName = model?.name ?? 'iPhone 13';

    return Scaffold(
      appBar: CustomAppBar(title: '$modelName Details'),
      body: FutureBuilder(
        future: apiService.getVariants(model?.id ?? 'm_ip13'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          final variants = snapshot.data!;
          _selectedVariant ??= variants.first;

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Storage Variant',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: variants.map((v) {
                      final isSelected = _selectedVariant?.id == v.id;
                      return ChoiceChip(
                        label: Text('${v.storageGb} GB (${v.colorName})'),
                        selected: isSelected,
                        selectedColor: AppColors.primaryLight,
                        labelStyle: TextStyle(
                          color: isSelected ? AppColors.primaryDark : AppColors.neutral900,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 13,
                        ),
                        onSelected: (_) => setState(() => _selectedVariant = v),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // IMEI Input with Luhn Check
                  const Text(
                    'Device IMEI Number',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Dial *#06# on your phone to find your 15-digit IMEI',
                    style: TextStyle(fontSize: 12, color: AppColors.neutral500),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(
                    hint: '356938035643809',
                    controller: _imeiController,
                    keyboardType: TextInputType.number,
                    prefix: const Icon(Icons.qr_code_scanner_rounded, size: 20, color: AppColors.neutral500),
                    validator: Validators.validateImei,
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Warranty Status
                  const Text(
                    'Remaining Manufacturer Warranty',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildWarrantyChip('Under 3 Months', WarrantyDuration.under3Months),
                      _buildWarrantyChip('3 - 6 Months', WarrantyDuration.threeToSixMonths),
                      _buildWarrantyChip('6 - 11 Months', WarrantyDuration.sixToElevenMonths),
                      _buildWarrantyChip('Out of Warranty', WarrantyDuration.outOfWarranty),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Original Accessories Checklist
                  const Text(
                    'Original Accessories Available (+5% Bonus)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  CheckboxListTile(
                    title: const Text('Original Device Box', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    value: _hasBox,
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) => setState(() => _hasBox = val ?? true),
                  ),
                  CheckboxListTile(
                    title: const Text('Original Working Charger & Cable', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    value: _hasCharger,
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) => setState(() => _hasCharger = val ?? true),
                  ),
                  CheckboxListTile(
                    title: const Text('Valid VAT Purchase Invoice', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    value: _hasBill,
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) => setState(() => _hasBill = val ?? true),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  AppButton(
                    text: 'Continue to Condition Check',
                    onPressed: _handleContinue,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWarrantyChip(String label, WarrantyDuration duration) {
    final isSelected = _selectedWarranty == duration;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primaryLight,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primaryDark : AppColors.neutral900,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        fontSize: 12,
      ),
      onSelected: (_) => setState(() => _selectedWarranty = duration),
    );
  }
}
