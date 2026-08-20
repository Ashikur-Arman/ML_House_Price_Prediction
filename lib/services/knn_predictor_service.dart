import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart' show rootBundle;

import '../models/house_features.dart';
import '../models/knn_prediction_result.dart';
import '../models/training_point.dart';

/// Fully on-device KNN regression.
///
/// This implementation mirrors:
///
/// KNeighborsRegressor(
///     n_neighbors=9,
///     weights='distance',
///     p=2
/// )
///
/// No server.
/// No API.
/// No internet.
/// Prediction happens locally on the device.
class KnnPredictorService {
  static const String _trainDataAsset =
      'assets/train_data_for_dart.json';

  static const String _scalerAsset =
      'assets/scaler_params.json';

  
  static const int k = 11;

  late List<TrainingPoint> _trainingData;
  late List<double> _mean;
  late List<double> _std;

  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  int get trainingDataCount {
    if (!_isLoaded) {
      return 0;
    }

    return _trainingData.length;
  }

  /// Loads training data and scaler parameters from Flutter assets.
  Future<void> loadData() async {
    if (_isLoaded) {
      return;
    }

    final trainJsonStr =
    await rootBundle.loadString(_trainDataAsset);

    final decodedTrainData =
    jsonDecode(trainJsonStr);

    if (decodedTrainData is! List) {
      throw const FormatException(
        'Training data JSON must contain a list.',
      );
    }

    _trainingData = decodedTrainData
        .map(
          (e) => TrainingPoint.fromJson(
        Map<String, dynamic>.from(e as Map),
      ),
    )
        .toList();

    if (_trainingData.isEmpty) {
      throw StateError(
        'Training dataset is empty.',
      );
    }

    final scalerJsonStr =
    await rootBundle.loadString(_scalerAsset);

    final scalerJson =
    jsonDecode(scalerJsonStr);

    if (scalerJson is! Map) {
      throw const FormatException(
        'Scaler JSON must contain an object.',
      );
    }

    final scalerMap =
    Map<String, dynamic>.from(scalerJson);

    _mean = (scalerMap['mean'] as List)
        .map((e) => (e as num).toDouble())
        .toList();

    _std = (scalerMap['std'] as List)
        .map((e) => (e as num).toDouble())
        .toList();

    if (_mean.length != 5 || _std.length != 5) {
      throw StateError(
        'Scaler must contain exactly 5 mean/std values.',
      );
    }

    for (final value in _std) {
      if (value == 0) {
        throw StateError(
          'Scaler standard deviation cannot be zero.',
        );
      }
    }

    for (final point in _trainingData) {
      if (point.features.length != 5) {
        throw StateError(
          'Every training point must contain exactly 5 features.',
        );
      }
    }

    _isLoaded = true;
  }

  /// Same normalization used during Python training:
  ///
  /// normalized = (raw - mean) / std
  List<double> _normalize(List<double> raw) {
    if (raw.length != _mean.length) {
      throw ArgumentError(
        'Expected ${_mean.length} features, '
            'but received ${raw.length}.',
      );
    }

    return List<double>.generate(
      raw.length,
          (i) => (raw[i] - _mean[i]) / _std[i],
    );
  }

  /// Euclidean distance.
  ///
  /// This is equivalent to p=2 in sklearn.
  double _euclideanDistance(
      List<double> a,
      List<double> b,
      ) {
    if (a.length != b.length) {
      throw ArgumentError(
        'Feature dimensions do not match.',
      );
    }

    double sumSq = 0;

    for (int i = 0; i < a.length; i++) {
      final diff = a[i] - b[i];
      sumSq += diff * diff;
    }

    return sqrt(sumSq);
  }

  /// Predict house price and return detailed KNN information.
  KnnPredictionResult predictDetailed(
      HouseFeatures input,
      ) {
    if (!_isLoaded) {
      throw StateError(
        'Data not loaded. Call loadData() first.',
      );
    }

    final rawInput = input.toRawList();

    if (rawInput.any((value) => !value.isFinite)) {
      throw ArgumentError(
        'All input values must be finite numbers.',
      );
    }

    final queryNormalized =
    _normalize(rawInput);

    // ----------------------------------------------------------
    // STEP 1:
    // Calculate distance from the query house to every
    // training house.
    // ----------------------------------------------------------

    final distances = _trainingData
        .map(
          (point) => _euclideanDistance(
        queryNormalized,
        point.features,
      ),
    )
        .toList();

    // ----------------------------------------------------------
    // STEP 2:
    // Create indexes for all training examples.
    // ----------------------------------------------------------

    final indices = List<int>.generate(
      distances.length,
          (i) => i,
    );

    // ----------------------------------------------------------
    // STEP 3:
    // Sort by nearest distance.
    // ----------------------------------------------------------

    indices.sort(
          (a, b) {
        return distances[a].compareTo(
          distances[b],
        );
      },
    );

    // ----------------------------------------------------------
    // STEP 4:
    // Take K nearest neighbors.
    //
    // If dataset somehow has less than K examples,
    // use the available number safely.
    // ----------------------------------------------------------

    final actualK = min(
      k,
      _trainingData.length,
    );

    final nearestIndices =
    indices.take(actualK).toList();

    // ----------------------------------------------------------
    // STEP 5:
    // Exact match.
    //
    // sklearn distance-weighted KNN gives special treatment
    // to zero-distance neighbors.
    // ----------------------------------------------------------

    for (final index in nearestIndices) {
      if (distances[index] < 1e-10) {
        final exactPoint =
        _trainingData[index];

        final exactNeighbor = NeighborResult(
          index: index,
          distance: 0,
          weight: double.infinity,
          price: exactPoint.price,
          trainingPoint: exactPoint,
        );

        return KnnPredictionResult(
          predictedPrice: exactPoint.price,
          neighbors: [exactNeighbor],
          k: actualK,
          algorithm: 'KNN Regression',
          distanceMetric: 'Euclidean Distance',
          weightingMethod: 'Distance Weighted',
          normalizationMethod: 'Standardization: (x - mean) / std',
          exactMatch: true,
        );
      }
    }

    // ----------------------------------------------------------
    // STEP 6:
    // Distance-weighted prediction.
    //
    // weight = 1 / distance
    // ----------------------------------------------------------

    double weightedSum = 0;
    double weightTotal = 0;

    final neighbors = <NeighborResult>[];

    for (final index in nearestIndices) {
      final distance = distances[index];

      final weight = 1.0 / distance;

      final point = _trainingData[index];

      weightedSum +=
          weight * point.price;

      weightTotal += weight;

      neighbors.add(
        NeighborResult(
          index: index,
          distance: distance,
          weight: weight,
          price: point.price,
          trainingPoint: point,
        ),
      );
    }

    final predictedPrice =
        weightedSum / weightTotal;

    return KnnPredictionResult(
      predictedPrice: predictedPrice,
      neighbors: neighbors,
      k: actualK,
      algorithm: 'KNN Regression',
      distanceMetric: 'Euclidean Distance',
      weightingMethod: 'Distance Weighted',
      normalizationMethod:
      'Standardization: (x - mean) / std',
      exactMatch: false,
    );
  }

  /// Simple prediction method.
  ///
  /// Useful if another part of the application only needs
  /// the final price.
  double predict(
      HouseFeatures input,
      ) {
    return predictDetailed(input).predictedPrice;
  }
}