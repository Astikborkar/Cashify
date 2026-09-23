enum AddressTag {
  home,
  work,
  other,
}

class SavedAddress {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String flatHouseNumber;
  final String streetArea;
  final String landmark;
  final String city;
  final String state;
  final String pincode;
  final AddressTag tag;
  final bool isDefault;

  const SavedAddress({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.flatHouseNumber,
    required this.streetArea,
    required this.landmark,
    required this.city,
    required this.state,
    required this.pincode,
    required this.tag,
    this.isDefault = false,
  });

  SavedAddress copyWith({
    String? id,
    String? fullName,
    String? phoneNumber,
    String? flatHouseNumber,
    String? streetArea,
    String? landmark,
    String? city,
    String? state,
    String? pincode,
    AddressTag? tag,
    bool? isDefault,
  }) {
    return SavedAddress(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      flatHouseNumber: flatHouseNumber ?? this.flatHouseNumber,
      streetArea: streetArea ?? this.streetArea,
      landmark: landmark ?? this.landmark,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      tag: tag ?? this.tag,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  String get formattedAddress => '$flatHouseNumber, $streetArea, near $landmark, $city, $state - $pincode';
}
