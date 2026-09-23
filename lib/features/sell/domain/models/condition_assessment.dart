enum ScreenCondition {
  flawless,
  minorScratches,
  heavyScratches,
  crackedGlass,
}

enum BodyCondition {
  flawless,
  minorScratches,
  heavyDents,
  bentChassis,
}

enum WarrantyDuration {
  under3Months,
  threeToSixMonths,
  sixToElevenMonths,
  outOfWarranty,
}

/// Comprehensive physical and functional condition questionnaire assessment.
class ConditionAssessment {
  final ScreenCondition screen;
  final BodyCondition body;
  final WarrantyDuration warranty;
  final bool hasOriginalBox;
  final bool hasOriginalCharger;
  final bool hasValidBill;
  final Set<String> functionalIssues;
  final String? imei;

  const ConditionAssessment({
    this.screen = ScreenCondition.flawless,
    this.body = BodyCondition.flawless,
    this.warranty = WarrantyDuration.outOfWarranty,
    this.hasOriginalBox = true,
    this.hasOriginalCharger = true,
    this.hasValidBill = true,
    this.functionalIssues = const {},
    this.imei,
  });

  ConditionAssessment copyWith({
    ScreenCondition? screen,
    BodyCondition? body,
    WarrantyDuration? warranty,
    bool? hasOriginalBox,
    bool? hasOriginalCharger,
    bool? hasValidBill,
    Set<String>? functionalIssues,
    String? imei,
  }) {
    return ConditionAssessment(
      screen: screen ?? this.screen,
      body: body ?? this.body,
      warranty: warranty ?? this.warranty,
      hasOriginalBox: hasOriginalBox ?? this.hasOriginalBox,
      hasOriginalCharger: hasOriginalCharger ?? this.hasOriginalCharger,
      hasValidBill: hasValidBill ?? this.hasValidBill,
      functionalIssues: functionalIssues ?? this.functionalIssues,
      imei: imei ?? this.imei,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'screen': screen.name,
      'body': body.name,
      'warranty': warranty.name,
      'has_original_box': hasOriginalBox,
      'has_original_charger': hasOriginalCharger,
      'has_valid_bill': hasValidBill,
      'functional_issues': functionalIssues.toList(),
      'imei': imei,
    };
  }
}
