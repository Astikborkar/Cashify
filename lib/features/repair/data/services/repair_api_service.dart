import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/repair_issue_model.dart';
import '../domain/models/repair_order_model.dart';
import '../domain/models/technician_model.dart';

final repairApiServiceProvider = Provider<RepairApiService>((ref) {
  return RepairApiService();
});

class RepairApiService {
  Future<List<RepairIssueModel>> getRepairIssues(String modelId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return const [
      RepairIssueModel(
        id: 'iss_screen',
        name: 'Screen & Touch Replacement',
        description: 'Original OLED digitizer assembly with true-tone programming.',
        icon: Icons.stay_current_portrait_rounded,
        partsCost: 2899,
        laborCost: 499,
        warrantyMonths: 6,
        turnaroundMinutes: 35,
      ),
      RepairIssueModel(
        id: 'iss_battery',
        name: 'OEM Battery Replacement',
        description: '100% health brand new certified high-density cell.',
        icon: Icons.battery_charging_full_rounded,
        partsCost: 1499,
        laborCost: 399,
        warrantyMonths: 6,
        turnaroundMinutes: 25,
      ),
      RepairIssueModel(
        id: 'iss_charging_port',
        name: 'Charging Port & Jack Repair',
        description: 'Fixes loose connection, slow charging, or water corrosion.',
        icon: Icons.power_rounded,
        partsCost: 799,
        laborCost: 299,
        warrantyMonths: 3,
        turnaroundMinutes: 20,
      ),
      RepairIssueModel(
        id: 'iss_camera',
        name: 'Camera Lens & Sensor Repair',
        description: 'Autofocus repair or full optical sensor replacement.',
        icon: Icons.camera_alt_rounded,
        partsCost: 1999,
        laborCost: 499,
        warrantyMonths: 6,
        turnaroundMinutes: 30,
      ),
      RepairIssueModel(
        id: 'iss_speaker_mic',
        name: 'Earpiece / Mic / Speaker',
        description: 'Acoustic mesh cleaning or new speaker driver overhaul.',
        icon: Icons.volume_up_rounded,
        partsCost: 699,
        laborCost: 299,
        warrantyMonths: 3,
        turnaroundMinutes: 20,
      ),
      RepairIssueModel(
        id: 'iss_back_glass',
        name: 'Rear Glass Panel Replacement',
        description: 'Laser removal of broken back panel & OEM color glass fitment.',
        icon: Icons.flip_to_back_rounded,
        partsCost: 1299,
        laborCost: 399,
        warrantyMonths: 6,
        turnaroundMinutes: 45,
      ),
    ];
  }

  Future<RepairOrderModel> bookRepairOrder({
    required String deviceModelName,
    required List<RepairIssueModel> issues,
    required String address,
    required String date,
    required String slot,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final partsSubtotal = issues.fold(0.0, (sum, i) => sum + i.partsCost);
    final laborSubtotal = issues.fold(0.0, (sum, i) => sum + i.laborCost);
    // Bundle discount: 15% labor discount if multiple issues booked together
    final bundleDiscount = issues.length > 1 ? laborSubtotal * 0.15 : 0.0;
    final totalAmount = partsSubtotal + laborSubtotal - bundleDiscount;

    return RepairOrderModel(
      orderId: 'REP-84920',
      deviceModelName: deviceModelName,
      selectedIssues: issues,
      address: address,
      scheduledDate: date,
      scheduledTimeSlot: slot,
      partsSubtotal: partsSubtotal,
      laborSubtotal: laborSubtotal,
      bundleDiscount: bundleDiscount,
      totalAmount: totalAmount,
      status: RepairOrderStatus.technicianAssigned,
      technician: const TechnicianModel(
        id: 'tech_vikram',
        name: 'Vikram Singh',
        phone: '+91 98452 11984',
        rating: 4.94,
        completedRepairs: 712,
        vehicleNumber: 'KA 03 HM 4821',
        etaMinutes: 18,
        verificationOtp: '8492',
      ),
      bookedAt: DateTime.now(),
    );
  }
}
