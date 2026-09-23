import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/condition_assessment.dart';
import '../../domain/models/device_catalog_models.dart';
import '../../domain/models/diagnostic_test_item.dart';
import '../../domain/models/quote_breakdown_model.dart';

final sellApiServiceProvider = Provider<SellApiService>((ref) {
  return SellApiService();
});

class SellApiService {
  Future<List<BrandModel>> getBrands(String categoryId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return const [
      BrandModel(id: 'br_apple', name: 'Apple', logoUrl: 'assets/icons/apple.png', modelsCount: 38),
      BrandModel(id: 'br_samsung', name: 'Samsung', logoUrl: 'assets/icons/samsung.png', modelsCount: 64),
      BrandModel(id: 'br_oneplus', name: 'OnePlus', logoUrl: 'assets/icons/oneplus.png', modelsCount: 22),
      BrandModel(id: 'br_xiaomi', name: 'Xiaomi / Redmi', logoUrl: 'assets/icons/xiaomi.png', modelsCount: 45),
      BrandModel(id: 'br_google', name: 'Google Pixel', logoUrl: 'assets/icons/google.png', modelsCount: 16),
      BrandModel(id: 'br_realme', name: 'Realme', logoUrl: 'assets/icons/realme.png', modelsCount: 32),
      BrandModel(id: 'br_vivo', name: 'Vivo', logoUrl: 'assets/icons/vivo.png', modelsCount: 28),
      BrandModel(id: 'br_oppo', name: 'Oppo', logoUrl: 'assets/icons/oppo.png', modelsCount: 26),
    ];
  }

  Future<List<DeviceModelItem>> getModels(String brandId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (brandId == 'br_apple') {
      return const [
        DeviceModelItem(id: 'm_ip14pro', brandId: 'br_apple', name: 'iPhone 14 Pro', series: '14 Series', baseResalePrice: 58000, releaseYear: 2022),
        DeviceModelItem(id: 'm_ip14', brandId: 'br_apple', name: 'iPhone 14', series: '14 Series', baseResalePrice: 42000, releaseYear: 2022),
        DeviceModelItem(id: 'm_ip13pro', brandId: 'br_apple', name: 'iPhone 13 Pro', series: '13 Series', baseResalePrice: 48000, releaseYear: 2021),
        DeviceModelItem(id: 'm_ip13', brandId: 'br_apple', name: 'iPhone 13', series: '13 Series', baseResalePrice: 35000, releaseYear: 2021),
        DeviceModelItem(id: 'm_ip12', brandId: 'br_apple', name: 'iPhone 12', series: '12 Series', baseResalePrice: 24000, releaseYear: 2020),
        DeviceModelItem(id: 'm_ip11', brandId: 'br_apple', name: 'iPhone 11', series: '11 Series', baseResalePrice: 17000, releaseYear: 2019),
      ];
    } else {
      return const [
        DeviceModelItem(id: 'm_s23ultra', brandId: 'br_samsung', name: 'Galaxy S23 Ultra', series: 'S Series', baseResalePrice: 56000, releaseYear: 2023),
        DeviceModelItem(id: 'm_s23', brandId: 'br_samsung', name: 'Galaxy S23 5G', series: 'S Series', baseResalePrice: 36000, releaseYear: 2023),
        DeviceModelItem(id: 'm_s22', brandId: 'br_samsung', name: 'Galaxy S22 5G', series: 'S Series', baseResalePrice: 28000, releaseYear: 2022),
        DeviceModelItem(id: 'm_zfold4', brandId: 'br_samsung', name: 'Galaxy Z Fold 4', series: 'Z Series', baseResalePrice: 49000, releaseYear: 2022),
      ];
    }
  }

  Future<List<VariantModel>> getVariants(String modelId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [
      VariantModel(id: 'v_128', modelId: 'm_ip13', storageGb: 128, ramGb: 4, colorName: 'Midnight Black', basePrice: 35000),
      VariantModel(id: 'v_256', modelId: 'm_ip13', storageGb: 256, ramGb: 4, colorName: 'Starlight White', basePrice: 39000),
      VariantModel(id: 'v_512', modelId: 'm_ip13', storageGb: 512, ramGb: 4, colorName: 'Sierra Blue', basePrice: 43000),
    ];
  }

  /// AI Valuation Engine applying the dynamic pricing algorithm from agents.md
  Future<QuoteBreakdownModel> calculateAiQuote({
    required DeviceModelItem model,
    required VariantModel variant,
    required ConditionAssessment assessment,
    required List<DiagnosticTestItem> diagnosticResults,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    double baseValue = variant.basePrice;
    final List<QuoteAdjustmentItem> adjustments = [
      QuoteAdjustmentItem(label: 'Base ${variant.storageGb}GB Market Valuation', amount: baseValue),
    ];

    // 1. Screen wear deduction
    if (assessment.screen == ScreenCondition.minorScratches) {
      final ded = baseValue * 0.05;
      baseValue -= ded;
      adjustments.add(QuoteAdjustmentItem(label: 'Screen Micro-scratches', amount: -ded));
    } else if (assessment.screen == ScreenCondition.heavyScratches) {
      final ded = baseValue * 0.12;
      baseValue -= ded;
      adjustments.add(QuoteAdjustmentItem(label: 'Heavy Screen Scratches', amount: -ded));
    } else if (assessment.screen == ScreenCondition.crackedGlass) {
      final ded = baseValue * 0.35;
      baseValue -= ded;
      adjustments.add(QuoteAdjustmentItem(label: 'Cracked Glass / Touch Defect', amount: -ded));
    }

    // 2. Body wear deduction
    if (assessment.body == BodyCondition.minorScratches) {
      final ded = baseValue * 0.04;
      baseValue -= ded;
      adjustments.add(QuoteAdjustmentItem(label: 'Body Hairline Scratches', amount: -ded));
    } else if (assessment.body == BodyCondition.heavyDents) {
      final ded = baseValue * 0.15;
      baseValue -= ded;
      adjustments.add(QuoteAdjustmentItem(label: 'Chassis Dents & Scuffs', amount: -ded));
    } else if (assessment.body == BodyCondition.bentChassis) {
      final ded = baseValue * 0.30;
      baseValue -= ded;
      adjustments.add(QuoteAdjustmentItem(label: 'Bent Frame / Housing', amount: -ded));
    }

    // 3. Functional defects
    for (final issue in assessment.functionalIssues) {
      if (issue == 'battery_degraded') {
        final ded = 3500.0;
        baseValue -= ded;
        adjustments.add(const QuoteAdjustmentItem(label: 'Battery Health <80%', amount: -3500));
      } else if (issue == 'camera_faulty') {
        final ded = 4200.0;
        baseValue -= ded;
        adjustments.add(const QuoteAdjustmentItem(label: 'Camera Sensor Fault', amount: -4200));
      } else if (issue == 'speaker_mic_issue') {
        final ded = 1800.0;
        baseValue -= ded;
        adjustments.add(const QuoteAdjustmentItem(label: 'Speaker / Microphone Defect', amount: -1800));
      }
    }

    // 4. Diagnostic test failures
    int passedCount = 0;
    for (final t in diagnosticResults) {
      if (t.status == DiagnosticStatus.passed) {
        passedCount++;
      } else if (t.status == DiagnosticStatus.failed) {
        baseValue -= 800;
        adjustments.add(QuoteAdjustmentItem(label: '${t.name} QC Failure', amount: -800));
      }
    }

    // 5. Accessories bonuses (+5% to +8%)
    if (assessment.hasOriginalBox && assessment.hasOriginalCharger) {
      const bonus = 1200.0;
      baseValue += bonus;
      adjustments.add(const QuoteAdjustmentItem(label: 'Original Box & Charger Bonus', amount: bonus, isBonus: true));
    }
    if (assessment.hasValidBill) {
      const bonus = 800.0;
      baseValue += bonus;
      adjustments.add(const QuoteAdjustmentItem(label: 'Valid Invoice Bonus', amount: bonus, isBonus: true));
    }

    // Health Score calculation (0 - 100)
    final healthScore = diagnosticResults.isNotEmpty
        ? ((passedCount / diagnosticResults.length) * 100).round()
        : 90;

    return QuoteBreakdownModel(
      baseMarketValue: variant.basePrice,
      finalOfferPrice: baseValue.clamp(1000.0, 150000.0),
      adjustments: adjustments,
      confidenceScore: 0.96,
      priceLockDays: 7,
      deviceHealthScore: healthScore,
      quoteGeneratedAt: DateTime.now(),
    );
  }
}
