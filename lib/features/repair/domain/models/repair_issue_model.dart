import 'package:flutter/material.dart';

enum RepairPartGrade { oemCertified, premiumGrade }

/// Repair issue service item with parts cost, labor cost, and turnaround time.
class RepairIssueModel {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final double partsCost;
  final double laborCost;
  final int warrantyMonths;
  final int turnaroundMinutes;
  final RepairPartGrade partGrade;

  const RepairIssueModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.partsCost,
    this.laborCost = 399.0,
    this.warrantyMonths = 6,
    this.turnaroundMinutes = 45,
    this.partGrade = RepairPartGrade.oemCertified,
  });

  double get totalPrice => partsCost + laborCost;
}
