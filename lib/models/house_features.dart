/// Raw (un-normalized) input from the user.
/// Order MUST match training: [area_sqft, bedrooms, bathrooms, age_years, distance_to_city_km]
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

  List<double> toRawList() =>
      [areaSqft, bedrooms, bathrooms, ageYears, distanceToCityKm];
}