/// High-demand device model for instant sell buyback highlights.
class TrendingSellDeviceModel {
  final String id;
  final String brand;
  final String modelName;
  final String variantInfo;
  final double maxQuotePrice;
  final String? imageUrl;
  final String badge;

  const TrendingSellDeviceModel({
    required this.id,
    required this.brand,
    required this.modelName,
    required this.variantInfo,
    required this.maxQuotePrice,
    this.imageUrl,
    this.badge = 'High Demand',
  });

  factory TrendingSellDeviceModel.fromJson(Map<String, dynamic> json) {
    return TrendingSellDeviceModel(
      id: json['id'] as String,
      brand: json['brand'] as String,
      modelName: json['model_name'] as String,
      variantInfo: (json['variant_info'] as String?) ?? '128 GB',
      maxQuotePrice: (json['max_quote_price'] as num).toDouble(),
      imageUrl: json['image_url'] as String?,
      badge: (json['badge'] as String?) ?? 'High Demand',
    );
  }
}
