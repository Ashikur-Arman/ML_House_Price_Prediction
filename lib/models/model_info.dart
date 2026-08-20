/// Static info about the trained KNN model — from our Jupyter notebook results.
class ModelInfo {
  static const String algorithmName = "K-Nearest Neighbors (KNN) Regression";
  static const int kNeighbors = 9;
  static const double r2Score = 0.8948; // 89.48% variance explained
  static const double maeValue = 14.25; // avg error in lakh BDT
  static const int trainingSize = 1600; // number of houses used to train
}