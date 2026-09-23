/// Single deduction or bonus line item in the valuation breakdown.
class QuoteAdjustmentItem {
  final String label;
  final double amount;
  final bool isBonus;

  const QuoteAdjustmentItem({
    required this.label,
    required this.amount,
    this.isBonus = false,
  });
}

/// Comprehensive AI Quote result matching agents.md specification.
class QuoteBreakdownModel {
  final double baseMarketValue;
  final double finalOfferPrice;
  final List<QuoteAdjustmentItem> adjustments;
  final double confidenceScore;
  final int priceLockDays;
  final int deviceHealthScore;
  final DateTime quoteGeneratedAt;

  const QuoteBreakdownModel({
    required this.baseMarketValue,
    required this.finalOfferPrice,
    required this.adjustments,
    this.confidenceScore = 0.96,
    this.priceLockDays = 7,
    this.deviceHealthScore = 92,
    required this.quoteGeneratedAt,
  });

  DateTime get expiresAt => quoteGeneratedAt.add(Duration(days: priceLockDays));
}
