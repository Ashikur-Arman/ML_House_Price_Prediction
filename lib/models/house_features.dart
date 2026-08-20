/// Raw (un-normalized) input provided by the user.
///
/// IMPORTANT:
/// The order of these features MUST remain exactly the same
/// as the order used during model training:
///
/// [area_sqft, bedrooms, bathrooms, age_years, distance_to_city_km]
class HouseFeatures {
  final double areaSqft;
  final double bedrooms;
  final double bathrooms;
  final double ageYears;
  final double distanceToCityKm;

  const HouseFeatures({
    required this.areaSqft,
    required this.bedrooms,
    required this.bathrooms,
    required this.ageYears,
    required this.distanceToCityKm,
  });

  List<double> toRawList() {
    return [
      areaSqft,
      bedrooms,
      bathrooms,
      ageYears,
      distanceToCityKm,
    ];
  }

  HouseFeatures copyWith({
    double? areaSqft,
    double? bedrooms,
    double? bathrooms,
    double? ageYears,
    double? distanceToCityKm,
  }) {
    return HouseFeatures(
      areaSqft: areaSqft ?? this.areaSqft,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      ageYears: ageYears ?? this.ageYears,
      distanceToCityKm: distanceToCityKm ?? this.distanceToCityKm,
    );
  }
}