import 'package:flutter/material.dart';

enum DiagnosticStatus { pending, running, passed, failed, skipped }

/// Test definition and state within the automated hardware diagnostics suite.
class DiagnosticTestItem {
  final String key;
  final String name;
  final String description;
  final IconData icon;
  final DiagnosticStatus status;
  final String? errorReason;

  const DiagnosticTestItem({
    required this.key,
    required this.name,
    required this.description,
    required this.icon,
    this.status = DiagnosticStatus.pending,
    this.errorReason,
  });

  DiagnosticTestItem copyWith({
    DiagnosticStatus? status,
    String? errorReason,
  }) {
    return DiagnosticTestItem(
      key: key,
      name: name,
      description: description,
      icon: icon,
      status: status ?? this.status,
      errorReason: errorReason ?? this.errorReason,
    );
  }
}
