import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/repair_api_service.dart';
import '../domain/models/repair_issue_model.dart';
import '../domain/models/repair_order_model.dart';

class RepairFlowState {
  final String selectedDeviceModel;
  final List<RepairIssueModel> selectedIssues;
  final RepairOrderModel? activeOrder;
  final bool isBooking;
  final String? error;

  const RepairFlowState({
    this.selectedDeviceModel = 'Apple iPhone 13',
    this.selectedIssues = const [],
    this.activeOrder,
    this.isBooking = false,
    this.error,
  });

  double get partsSubtotal => selectedIssues.fold(0.0, (sum, i) => sum + i.partsCost);
  double get laborSubtotal => selectedIssues.fold(0.0, (sum, i) => sum + i.laborCost);
  double get bundleDiscount => selectedIssues.length > 1 ? laborSubtotal * 0.15 : 0.0;
  double get totalEstimatedCost => (partsSubtotal + laborSubtotal - bundleDiscount).clamp(0.0, double.infinity);
  int get estimatedTurnaroundMinutes => selectedIssues.fold(0, (sum, i) => sum + i.turnaroundMinutes);

  RepairFlowState copyWith({
    String? selectedDeviceModel,
    List<RepairIssueModel>? selectedIssues,
    RepairOrderModel? activeOrder,
    bool? isBooking,
    String? error,
  }) {
    return RepairFlowState(
      selectedDeviceModel: selectedDeviceModel ?? this.selectedDeviceModel,
      selectedIssues: selectedIssues ?? this.selectedIssues,
      activeOrder: activeOrder ?? this.activeOrder,
      isBooking: isBooking ?? this.isBooking,
      error: error,
    );
  }
}

final repairFlowNotifierProvider = StateNotifierProvider<RepairFlowNotifier, RepairFlowState>((ref) {
  final apiService = ref.read(repairApiServiceProvider);
  return RepairFlowNotifier(apiService);
});

class RepairFlowNotifier extends StateNotifier<RepairFlowState> {
  final RepairApiService _apiService;

  RepairFlowNotifier(this._apiService) : super(const RepairFlowState());

  void setDeviceModel(String modelName) {
    state = state.copyWith(selectedDeviceModel: modelName);
  }

  void toggleIssue(RepairIssueModel issue) {
    final exists = state.selectedIssues.any((i) => i.id == issue.id);
    if (exists) {
      final updated = state.selectedIssues.where((i) => i.id != issue.id).toList();
      state = state.copyWith(selectedIssues: updated);
    } else {
      state = state.copyWith(selectedIssues: [...state.selectedIssues, issue]);
    }
  }

  Future<bool> bookRepair({
    required String address,
    required String date,
    required String slot,
  }) async {
    if (state.selectedIssues.isEmpty) return false;
    state = state.copyWith(isBooking: true, error: null);

    try {
      final order = await _apiService.bookRepairOrder(
        deviceModelName: state.selectedDeviceModel,
        issues: state.selectedIssues,
        address: address,
        date: date,
        slot: slot,
      );
      state = state.copyWith(activeOrder: order, isBooking: false);
      return true;
    } catch (e) {
      state = state.copyWith(isBooking: false, error: 'Failed to book repair: $e');
      return false;
    }
  }

  void simulateTechnicianStep() {
    if (state.activeOrder?.technician != null) {
      final currentEta = state.activeOrder!.technician!.etaMinutes;
      if (currentEta > 2) {
        final updatedTech = state.activeOrder!.technician!.copyWith(
          etaMinutes: currentEta - 3,
        );
        state = state.copyWith(activeOrder: state.activeOrder!.copyWith(technician: updatedTech));
      }
    }
  }
}
