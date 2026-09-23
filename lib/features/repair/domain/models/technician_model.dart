/// Certified doorstep technician profile and live telemetry.
class TechnicianModel {
  final String id;
  final String name;
  final String phone;
  final double rating;
  final int completedRepairs;
  final String vehicleNumber;
  final double latitude;
  final double longitude;
  final int etaMinutes;
  final String verificationOtp;
  final bool isVaccinated;
  final bool isIdVerified;

  const TechnicianModel({
    required this.id,
    required this.name,
    required this.phone,
    this.rating = 4.92,
    this.completedRepairs = 648,
    this.vehicleNumber = 'KA 03 HM 4821',
    this.latitude = 12.9716,
    this.longitude = 77.5946,
    this.etaMinutes = 18,
    this.verificationOtp = '4921',
    this.isVaccinated = true,
    this.isIdVerified = true,
  });

  TechnicianModel copyWith({
    double? latitude,
    double? longitude,
    int? etaMinutes,
  }) {
    return TechnicianModel(
      id: id,
      name: name,
      phone: phone,
      rating: rating,
      completedRepairs: completedRepairs,
      vehicleNumber: vehicleNumber,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      etaMinutes: etaMinutes ?? this.etaMinutes,
      verificationOtp: verificationOtp,
      isVaccinated: isVaccinated,
      isIdVerified: isIdVerified,
    );
  }
}
