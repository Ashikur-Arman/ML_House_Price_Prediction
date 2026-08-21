/// All 11 locations + 4 quality tiers offered in the UI. The GBM predictor
/// service encodes these using the `location_categories` /
/// `quality_categories` order stored in assets/cost_model.json at runtime,
/// so the order of these UI lists does not need to match that file.
const List<String> kCostLocations = [
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

const List<String> kConstructionQualities = [
  'Economy',
  'Standard',
  'Premium',
  'Luxury',
];

/// Raw (un-normalized) input from the user for the construction-cost model.
/// Order MUST match training:
/// [land_area_katha, num_floors, rooms_per_floor, bathrooms_per_floor,
///  distance_to_main_road_km, has_lift, has_parking, has_generator,
///  has_rooftop_garden, loc_<one-hot x 11>, qual_<one-hot x 4>]
class ConstructionFeatures {
  final double landAreaKatha;
  final double numFloors;
  final double roomsPerFloor;
  final double bathroomsPerFloor;
  final double distanceToMainRoadKm;
  final bool hasLift;
  final bool hasParking;
  final bool hasGenerator;
  final bool hasRooftopGarden;
  final String locationArea;
  final String constructionQuality;

  const ConstructionFeatures({
    required this.landAreaKatha,
    required this.numFloors,
    required this.roomsPerFloor,
    required this.bathroomsPerFloor,
    required this.distanceToMainRoadKm,
    required this.hasLift,
    required this.hasParking,
    required this.hasGenerator,
    required this.hasRooftopGarden,
    required this.locationArea,
    required this.constructionQuality,
  });

  List<double> toRawList() {
    final locationOneHot =
        kCostLocations.map((loc) => loc == locationArea ? 1.0 : 0.0).toList();
    final qualityOneHot = kConstructionQualities
        .map((q) => q == constructionQuality ? 1.0 : 0.0)
        .toList();

    return [
      landAreaKatha,
      numFloors,
      roomsPerFloor,
      bathroomsPerFloor,
      distanceToMainRoadKm,
      hasLift ? 1.0 : 0.0,
      hasParking ? 1.0 : 0.0,
      hasGenerator ? 1.0 : 0.0,
      hasRooftopGarden ? 1.0 : 0.0,
      ...locationOneHot,
      ...qualityOneHot,
    ];
  }
}
