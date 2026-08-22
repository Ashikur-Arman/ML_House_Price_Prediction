/// Static info about the trained House Price Gradient Boosting model —
/// from train_dhaka_price_gbm.ipynb results (held-out 20% test split).
///
/// The SAME split (random_state=42) was used to re-score the old KNN
/// model in the notebook (Cell 2) before scoring this one (Cell 6-7), so
/// the numbers here and in [ModelInfo] are directly, fairly comparable —
/// see [ModelComparisonGrid].
///
/// Chosen over the untuned default GradientBoostingRegressor (R²=0.9605,
/// MAE=19.99) via GridSearchCV over n_estimators/learning_rate/max_depth/
/// subsample (Cell 6) — this is the resulting best estimator.
class HouseGbmModelInfo {
  static const String algorithmName = "Gradient Boosting Regression (Tuned)";
  static const int numTrees = 500;
  static const int maxDepth = 4;
  static const double learningRate = 0.05;
  static const double subsample = 0.8;
  static const double r2Score = 0.9715; // 97.15% variance explained
  static const double maeValue = 17.47; // avg error in lakh BDT
  static const double rmseValue = 25.74; // lakh BDT
  static const double mapeValue = 8.53; // mean absolute % error
  static const int trainingSize = 2000; // 80% of 2500 houses used to train
}
