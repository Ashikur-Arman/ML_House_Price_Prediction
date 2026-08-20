import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import '../models/training_point.dart';
import '../models/house_features.dart';
import '../models/prediction_result.dart';

/// Fully on-device KNN regression — no server, no internet required.
/// Mirrors sklearn's KNeighborsRegressor(n_neighbors=9, weights='distance', p=2).
class KnnPredictorService {
  static const String _trainDataAsset = 'assets/train_data_for_dart.json';
  static const String _scalerAsset = 'assets/scaler_params.json';
  static const int _k = 9; // must match the k used during training

  late List<TrainingPoint> _trainingData;
  late List<double> _mean;
  late List<double> _std;
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  Future<void> loadData() async {
    final trainJsonStr = await rootBundle.loadString(_trainDataAsset);
    final List<dynamic> trainJsonList = jsonDecode(trainJsonStr);
    _trainingData =
        trainJsonList.map((e) => TrainingPoint.fromJson(e)).toList();

    final scalerJsonStr = await rootBundle.loadString(_scalerAsset);
    final scalerJson = jsonDecode(scalerJsonStr) as Map<String, dynamic>;
    _mean = (scalerJson['mean'] as List)
        .map((e) => (e as num).toDouble())
        .toList();
    _std = (scalerJson['std'] as List)
        .map((e) => (e as num).toDouble())
        .toList();

    _isLoaded = true;
  }

  List<double> _normalize(List<double> raw) {
    return List.generate(raw.length, (i) => (raw[i] - _mean[i]) / _std[i]);
  }

  double _euclideanDistance(List<double> a, List<double> b) {
    double sumSq = 0;
    for (int i = 0; i < a.length; i++) {
      final diff = a[i] - b[i];
      sumSq += diff * diff;
    }
    return sqrt(sumSq);
  }

  PredictionResult predict(HouseFeatures input) {
    if (!_isLoaded) {
      throw StateError('Data not loaded. Call loadData() first.');
    }

    final queryNormalized = _normalize(input.toRawList());

    final distances = _trainingData
        .map((p) => _euclideanDistance(queryNormalized, p.features))
        .toList();

    final indices = List<int>.generate(distances.length, (i) => i);
    indices.sort((a, b) => distances[a].compareTo(distances[b]));
    final nearestIndices = indices.take(_k).toList();

    // Exact match edge case
    for (final idx in nearestIndices) {
      if (distances[idx] == 0) {
        return PredictionResult(
          predictedPrice: _trainingData[idx].price,
          topNeighbors: [
            NeighborInfo(
              price: _trainingData[idx].price,
              distance: 0,
              weightPercent: 100,
            ),
          ],
        );
      }
    }

    // Distance-weighted average
    double weightedSum = 0;
    double weightTotal = 0;
    final rawWeights = <int, double>{};

    for (final idx in nearestIndices) {
      final weight = 1.0 / distances[idx];
      rawWeights[idx] = weight;
      weightedSum += weight * _trainingData[idx].price;
      weightTotal += weight;
    }

    final predictedPrice = weightedSum / weightTotal;

    // Build neighbor info sorted by influence (highest weight first)
    final neighborList = nearestIndices.map((idx) {
      return NeighborInfo(
        price: _trainingData[idx].price,
        distance: distances[idx],
        weightPercent: (rawWeights[idx]! / weightTotal) * 100,
      );
    }).toList()
      ..sort((a, b) => b.weightPercent.compareTo(a.weightPercent));

    return PredictionResult(
      predictedPrice: predictedPrice,
      topNeighbors: neighborList.take(5).toList(), // top 5 most influential
    );
  }
}