/// All 11 locations used during training — order MUST exactly match the
/// `locations` list saved in assets/scaler_params.json (alphabetically sorted).
const List<String> kLocations = [
  'Badda',
  'Banani',
  'Bashundhara R/A',
  'Dhanmondi',
  'Gulshan',
  'Mirpur',
  'Mohammadpur',
  'Old Dhaka',
  'Rampura',
  'Savar',
  'Uttara',
];

/// Raw (un-normalized) input from the user.
/// Order MUST match training:
/// [area_sqft, bedrooms, bathrooms, age_years, distance_to_city_km,
///  floor_no, has_lift, has_parking, loc_<one-hot x 11>]
class HouseFeatures {
  final double areaSqft;
  final double bedrooms;
  final double bathrooms;
  final double ageYears;
  final double distanceToCityKm;
  final double floorNo;
  final bool hasLift;
  final bool hasParking;
  final String locationArea;

  const HouseFeatures({
    required this.areaSqft,
    required this.bedrooms,
    required this.bathrooms,
    required this.ageYears,
    required this.distanceToCityKm,
    required this.floorNo,
    required this.hasLift,
    required this.hasParking,
    required this.locationArea,
  });

  List<double> toRawList() {
    final locationOneHot = kLocations
        .map((loc) => loc == locationArea ? 1.0 : 0.0)
        .toList();

    return [
      areaSqft,
      bedrooms,
      bathrooms,
      ageYears,
      distanceToCityKm,
      floorNo,
      hasLift ? 1.0 : 0.0,
      hasParking ? 1.0 : 0.0,
      ...locationOneHot,
    ];
  }
}
