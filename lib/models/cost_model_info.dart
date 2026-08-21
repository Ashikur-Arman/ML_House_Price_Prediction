/// Static info about the trained Construction Cost model — from the
/// train_cost_estimator.ipynb notebook results (held-out test split).
///
/// Model: GradientBoostingRegressor(n_estimators=200, max_depth=3,
/// learning_rate=0.1) — chosen over HistGradientBoosting (R²≈0.995, but its
/// internal histogram trees can't be hand-re-implemented in Dart) because
/// plain decision trees inside GradientBoosting CAN be traversed on-device,
/// the same way KNN was implemented for the house-price model.
class CostModelInfo {
  static const String algorithmName = "Gradient Boosting Regression";
  static const int numTrees = 200;
  static const int maxDepth = 3;
  static const double learningRate = 0.1;
  static const double r2Score = 0.9944; // 99.44% variance explained
  static const double maeValue = 29.59; // avg error in lakh BDT
  static const int trainingSize = 2400; // 80% of 3000 houses used to train
}
