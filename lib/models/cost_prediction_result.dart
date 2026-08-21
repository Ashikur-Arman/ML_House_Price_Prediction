import 'cost_gbm_model.dart';

/// Result of a Construction Cost prediction. Unlike the house-price KNN
/// model, Gradient Boosting has no "similar houses" — instead we show
/// which features drove the estimate most, globally, via feature
/// importances computed during training (notebook Cell 8).
class CostPredictionResult {
  final double predictedPrice;
  final List<FeatureImportance> featureImportances;

  const CostPredictionResult({
    required this.predictedPrice,
    required this.featureImportances,
  });
}
