/// One "similar house" that contributed to the final prediction.
class NeighborInfo {
  final double price;
  final double distance;
  final double weightPercent; // how much this neighbor influenced the result

  const NeighborInfo({
    required this.price,
    required this.distance,
    required this.weightPercent,
  });
}

/// Full result of a prediction — the price + which houses influenced it.
class PredictionResult {
  final double predictedPrice;
  final List<NeighborInfo> topNeighbors;

  const PredictionResult({
    required this.predictedPrice,
    required this.topNeighbors,
  });
}