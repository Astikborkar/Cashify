import 'repair_issue_model.dart';
import 'technician_model.dart';

enum RepairOrderStatus {
  booked,
  technicianAssigned,
  enRoute,
  inProgress,
  completed,
  cancelled,
}

/// Comprehensive repair booking order model.
class RepairOrderModel {
  final String orderId;
  final String deviceModelName;
  final List<RepairIssueModel> selectedIssues;
  final String address;
  final String scheduledDate;
  final String scheduledTimeSlot;
  final double partsSubtotal;
  final double laborSubtotal;
  final double bundleDiscount;
  final double totalAmount;
  final RepairOrderStatus status;
  final TechnicianModel? technician;
  final DateTime bookedAt;

  const RepairOrderModel({
    required this.orderId,
    required this.deviceModelName,
    required this.selectedIssues,
    required this.address,
    required this.scheduledDate,
    required this.scheduledTimeSlot,
    required this.partsSubtotal,
    required this.laborSubtotal,
    required this.bundleDiscount,
    required this.totalAmount,
    this.status = RepairOrderStatus.booked,
    this.technician,
    required this.bookedAt,
  });

  RepairOrderModel copyWith({
    RepairOrderStatus? status,
    TechnicianModel? technician,
  }) {
    return RepairOrderModel(
      orderId: orderId,
      deviceModelName: deviceModelName,
      selectedIssues: selectedIssues,
      address: address,
      scheduledDate: scheduledDate,
      scheduledTimeSlot: scheduledTimeSlot,
      partsSubtotal: partsSubtotal,
      laborSubtotal: laborSubtotal,
      bundleDiscount: bundleDiscount,
      totalAmount: totalAmount,
      status: status ?? this.status,
      technician: technician ?? this.technician,
      bookedAt: bookedAt,
    );
  }
}
