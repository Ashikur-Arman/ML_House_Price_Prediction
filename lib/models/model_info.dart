/// Static info about the trained KNN model — from our Jupyter notebook results.
class ModelInfo {
  static const String algorithmName = "K-Nearest Neighbors (KNN) Regression";
  static const int kNeighbors = 7;
  static const double r2Score = 0.8484; // 84.84% variance explained
  static const double maeValue = 43.19; // avg error in lakh BDT
  static const int trainingSize = 2000; // number of houses used to train
}