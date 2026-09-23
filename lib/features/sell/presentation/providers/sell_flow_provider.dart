import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/sell_api_service.dart';
import '../../domain/models/condition_assessment.dart';
import '../../domain/models/device_catalog_models.dart';
import '../../domain/models/diagnostic_test_item.dart';
import '../../domain/models/quote_breakdown_model.dart';

class SellFlowState {
  final String categoryId;
  final BrandModel? selectedBrand;
  final DeviceModelItem? selectedModel;
  final VariantModel? selectedVariant;
  final ConditionAssessment assessment;
  final List<DiagnosticTestItem> diagnosticTests;
  final QuoteBreakdownModel? calculatedQuote;
  final bool isCalculating;
  final String? error;

  const SellFlowState({
    this.categoryId = 'cat_sell_phone',
    this.selectedBrand,
    this.selectedModel,
    this.selectedVariant,
    this.assessment = const ConditionAssessment(),
    this.diagnosticTests = const [],
    this.calculatedQuote,
    this.isCalculating = false,
    this.error,
  });

  SellFlowState copyWith({
    String? categoryId,
    BrandModel? selectedBrand,
    DeviceModelItem? selectedModel,
    VariantModel? selectedVariant,
    ConditionAssessment? assessment,
    List<DiagnosticTestItem>? diagnosticTests,
    QuoteBreakdownModel? calculatedQuote,
    bool? isCalculating,
    String? error,
  }) {
    return SellFlowState(
      categoryId: categoryId ?? this.categoryId,
      selectedBrand: selectedBrand ?? this.selectedBrand,
      selectedModel: selectedModel ?? this.selectedModel,
      selectedVariant: selectedVariant ?? this.selectedVariant,
      assessment: assessment ?? this.assessment,
      diagnosticTests: diagnosticTests ?? this.diagnosticTests,
      calculatedQuote: calculatedQuote ?? this.calculatedQuote,
      isCalculating: isCalculating ?? this.isCalculating,
      error: error,
    );
  }
}

final sellFlowNotifierProvider = StateNotifierProvider<SellFlowNotifier, SellFlowState>((ref) {
  final apiService = ref.read(sellApiServiceProvider);
  return SellFlowNotifier(apiService);
});

class SellFlowNotifier extends StateNotifier<SellFlowState> {
  final SellApiService _apiService;

  SellFlowNotifier(this._apiService) : super(const SellFlowState()) {
    _initDefaultDiagnostics();
  }

  void _initDefaultDiagnostics() {
    final defaultTests = [
      const DiagnosticTestItem(
        key: 'touch_matrix',
        name: 'Screen Touch Matrix',
        description: 'Verifies digitizer responsiveness across full screen',
        icon: Icons.touch_app_rounded,
      ),
      const DiagnosticTestItem(
        key: 'dead_pixels',
        name: 'Display Color & Dead Pixels',
        description: 'Checks primary RGB colors for stuck pixels or screen burn',
        icon: Icons.palette_rounded,
      ),
      const DiagnosticTestItem(
        key: 'microphone',
        name: 'Microphone & Waveform',
        description: 'Records speech amplitude to test audio fidelity',
        icon: Icons.mic_rounded,
      ),
      const DiagnosticTestItem(
        key: 'speaker',
        name: 'Loudspeaker Acoustic Code',
        description: 'Plays frequency tone to test speaker clarity',
        icon: Icons.volume_up_rounded,
      ),
      const DiagnosticTestItem(
        key: 'camera',
        name: 'Front & Rear Camera',
        description: 'Validates optical autofocus and sensor capture',
        icon: Icons.camera_alt_rounded,
      ),
      const DiagnosticTestItem(
        key: 'vibration_sensors',
        name: 'Vibration & Gyroscope',
        description: 'Tests haptic motor and 3-axis motion sensors',
        icon: Icons.vibration_rounded,
      ),
    ];
    state = state.copyWith(diagnosticTests: defaultTests);
  }

  void setBrand(BrandModel brand) {
    state = state.copyWith(selectedBrand: brand, selectedModel: null, selectedVariant: null);
  }

  void setModel(DeviceModelItem model) {
    state = state.copyWith(selectedModel: model, selectedVariant: null);
  }

  void setVariant(VariantModel variant) {
    state = state.copyWith(selectedVariant: variant);
  }

  void updateAssessment(ConditionAssessment updated) {
    state = state.copyWith(assessment: updated);
  }

  void updateDiagnosticResult(String testKey, DiagnosticStatus status, {String? reason}) {
    final updatedList = state.diagnosticTests.map((t) {
      if (t.key == testKey) {
        return t.copyWith(status: status, errorReason: reason);
      }
      return t;
    }).toList();
    state = state.copyWith(diagnosticTests: updatedList);
  }

  Future<void> computeAiQuote() async {
    if (state.selectedModel == null || state.selectedVariant == null) return;
    state = state.copyWith(isCalculating: true, error: null);

    try {
      final quote = await _apiService.calculateAiQuote(
        model: state.selectedModel!,
        variant: state.selectedVariant!,
        assessment: state.assessment,
        diagnosticResults: state.diagnosticTests,
      );
      state = state.copyWith(calculatedQuote: quote, isCalculating: false);
    } catch (e) {
      state = state.copyWith(isCalculating: false, error: 'Valuation calculation failed: $e');
    }
  }

  void reset() {
    state = const SellFlowState();
    _initDefaultDiagnostics();
  }
}
