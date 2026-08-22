import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/house_features.dart';
import '../models/house_gbm_model.dart';
import '../models/house_gbm_prediction_result.dart';

/// Fully on-device Gradient Boosting regression for house price — no
/// server, no internet required. Manually traverses the 500 decision
/// trees exported from sklearn's GradientBoostingRegressor (see
/// train_dhaka_price_gbm.ipynb, Cell 9). The traversal + summation logic
/// here was verified against the notebook's own sample prediction
/// (Gulshan, 2200 sqft, ... -> 444.91 lakh BDT) with an exact match
/// before being wired up to this screen.
///
/// Takes the exact same [HouseFeatures] input as `KnnPredictorService` —
/// the two models are independent, swappable predictors over one shared
/// input shape, so the same form/fields can drive either one.
class HouseGbmPredictorService {
  static const String _modelAsset = 'assets/gbm_model_for_dart.json';
  static const String _scalerAsset = 'assets/house_gbm_scaler_params.json';

  late HouseGbmModel _model;
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;
  HouseGbmModel get model => _model;

  Future<void> loadData() async {
    final modelJsonStr = await rootBundle.loadString(_modelAsset);
    final scalerJsonStr = await rootBundle.loadString(_scalerAsset);

    _model = HouseGbmModel.fromJson(
      modelJson: jsonDecode(modelJsonStr) as Map<String, dynamic>,
      scalerJson: jsonDecode(scalerJsonStr) as Map<String, dynamic>,
    );
    _isLoaded = true;
  }

  List<double> _normalize(List<double> raw) {
    return List.generate(
      raw.length,
      (i) => (raw[i] - _model.mean[i]) / _model.std[i],
    );
  }

  HouseGbmPredictionResult predict(HouseFeatures input) {
    if (!_isLoaded) {
      throw StateError('Data not loaded. Call loadData() first.');
    }

    final x = _normalize(input.toRawList());

    // GBM prediction = init_value + sum over all trees of
    // (learning_rate * that tree's leaf value) — same accumulation
    // sklearn's GradientBoostingRegressor.predict() performs internally.
    double total = _model.initValue;
    for (final tree in _model.trees) {
      total += _model.learningRate * tree.predict(x);
    }

    return HouseGbmPredictionResult(
      predictedPrice: total,
      treesUsed: _model.trees.length,
      featureUsage: _model.featureUsage,
    );
  }
}
