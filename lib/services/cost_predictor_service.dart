import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/construction_features.dart';
import '../models/cost_gbm_model.dart';
import '../models/cost_tree_node.dart';
import '../models/cost_prediction_result.dart';

/// Fully on-device Gradient Boosting regression — no server, no internet
/// required. Manually traverses the 200 decision trees exported from
/// sklearn's GradientBoostingRegressor (see train_cost_estimator.ipynb,
/// export_tree() / Cell 9). Verified against sklearn's own predict() with
/// max diff == 0.0 before export.
///
/// This is a separate service/asset from [KnnPredictorService] (house price
/// model) — the two models run completely independently.
class CostPredictorService {
  static const String _modelAsset = 'assets/cost_model.json';

  late CostGbmModel _model;
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;
  CostGbmModel get model => _model;

  Future<void> loadData() async {
    final jsonStr = await rootBundle.loadString(_modelAsset);
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;
    _model = CostGbmModel.fromJson(json);
    _isLoaded = true;
  }

  /// Encodes raw input into the exact vector order the trees were trained
  /// on: one-hot(location) + one-hot(quality) + scaled(numeric features).
  List<double> _encode(ConstructionFeatures input) {
    final vec = <double>[];

    for (final loc in _model.locationCategories) {
      vec.add(loc == input.locationArea ? 1.0 : 0.0);
    }
    for (final q in _model.qualityCategories) {
      vec.add(q == input.constructionQuality ? 1.0 : 0.0);
    }

    final rawNumeric = <String, double>{
      'land_area_katha': input.landAreaKatha,
      'num_floors': input.numFloors,
      'rooms_per_floor': input.roomsPerFloor,
      'bathrooms_per_floor': input.bathroomsPerFloor,
      'distance_to_main_road_km': input.distanceToMainRoadKm,
      'has_lift': input.hasLift ? 1.0 : 0.0,
      'has_parking': input.hasParking ? 1.0 : 0.0,
      'has_generator': input.hasGenerator ? 1.0 : 0.0,
      'has_rooftop_garden': input.hasRooftopGarden ? 1.0 : 0.0,
    };

    for (int i = 0; i < _model.numericFeatures.length; i++) {
      final raw = rawNumeric[_model.numericFeatures[i]]!;
      final scaled = (raw - _model.numericMean[i]) / _model.numericScale[i];
      vec.add(scaled);
    }

    return vec;
  }

  double _evalTree(List<CostTreeNode> nodes, List<double> x) {
    int idx = 0;
    while (!nodes[idx].leaf) {
      final node = nodes[idx];
      idx = x[node.feature!] <= node.threshold! ? node.left! : node.right!;
    }
    return nodes[idx].value!;
  }

  CostPredictionResult predict(ConstructionFeatures input) {
    if (!_isLoaded) {
      throw StateError('Data not loaded. Call loadData() first.');
    }

    final x = _encode(input);

    double total = _model.initPrediction;
    for (final tree in _model.trees) {
      total += _model.learningRate * _evalTree(tree, x);
    }

    return CostPredictionResult(
      predictedPrice: total,
      featureImportances: _model.featureImportances,
    );
  }
}
