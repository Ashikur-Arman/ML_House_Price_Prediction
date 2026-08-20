import 'training_point.dart';

/// Details about one nearest neighbor used by KNN.
class NeighborResult {
  final int index;
  final double distance;
  final double weight;
  final double price;
  final TrainingPoint trainingPoint;

  const NeighborResult({
    required this.index,
    required this.distance,
    required this.weight,
    required this.price,
    required this.trainingPoint,
  });
}

/// Complete result returned by the KNN predictor.
///
/// This contains not only the final price but also the
/// information required to explain how KNN produced the result.
class KnnPredictionResult {
  final double predictedPrice;
  final List<NeighborResult> neighbors;

  final int k;
  final String algorithm;
  final String distanceMetric;
  final String weightingMethod;
  final String normalizationMethod;

  final bool exactMatch;

  const KnnPredictionResult({
    required this.predictedPrice,
    required this.neighbors,
    required this.k,
    required this.algorithm,
    required this.distanceMetric,
    required this.weightingMethod,
    required this.normalizationMethod,
    required this.exactMatch,
  });

  double get totalWeight {
    return neighbors.fold(
      0.0,
          (sum, neighbor) => sum + neighbor.weight,
    );
  }

  double get averageNeighborPrice {
    if (neighbors.isEmpty) {
      return 0;
    }

    final total = neighbors.fold(
      0.0,
          (sum, neighbor) => sum + neighbor.price,
    );

    return total / neighbors.length;
  }

  double get nearestDistance {
    if (neighbors.isEmpty) {
      return 0;
    }

    return neighbors.first.distance;
  }

  double get farthestDistance {
    if (neighbors.isEmpty) {
      return 0;
    }

    return neighbors.last.distance;
  }
}