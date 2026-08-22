import 'house_gbm_model.dart';

/// Result of a House Price prediction from the new Gradient Boosting
/// model. Unlike the old KNN model there's no "similar houses" list —
/// instead we show which features the 500 trees split on most often, as a
/// stand-in for what drives this model's predictions (see
/// [HouseGbmModel.featureUsage]).
class HouseGbmPredictionResult {
  final double predictedPrice;
  final int treesUsed;
  final List<FeatureUsage> featureUsage;

  const HouseGbmPredictionResult({
    required this.predictedPrice,
    required this.treesUsed,
    required this.featureUsage,
  });
}
