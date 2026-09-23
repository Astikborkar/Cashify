/// Brand representation in the device catalog.
class BrandModel {
  final String id;
  final String name;
  final String logoUrl;
  final int modelsCount;

  const BrandModel({
    required this.id,
    required this.name,
    required this.logoUrl,
    this.modelsCount = 20,
  });
}

/// Exact device model under a brand.
class DeviceModelItem {
  final String id;
  final String brandId;
  final String name;
  final String series;
  final double baseResalePrice;
  final String? imageUrl;
  final int releaseYear;

  const DeviceModelItem({
    required this.id,
    required this.brandId,
    required this.name,
    required this.series,
    required this.baseResalePrice,
    this.imageUrl,
    this.releaseYear = 2022,
  });
}

/// Storage, RAM, and Color configuration variant.
class VariantModel {
  final String id;
  final String modelId;
  final int storageGb;
  final int ramGb;
  final String colorName;
  final double basePrice;

  const VariantModel({
    required this.id,
    required this.modelId,
    required this.storageGb,
    required this.ramGb,
    required this.colorName,
    required this.basePrice,
  });

  String get label => '$storageGb GB / $ramGb GB RAM ($colorName)';
}
