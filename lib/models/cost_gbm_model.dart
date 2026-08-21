import 'cost_tree_node.dart';

/// One (feature, importance) pair, used to show "what drove the estimate"
/// on the analysis screen — mirrors the notebook's Cell 8 output.
class FeatureImportance {
  final String feature;
  final double importance;

  const FeatureImportance({required this.feature, required this.importance});

  factory FeatureImportance.fromJson(Map<String, dynamic> json) {
    return FeatureImportance(
      feature: json['feature'] as String,
      importance: (json['importance'] as num).toDouble(),
    );
  }
}

/// Fully on-device Gradient Boosting model — parsed from
/// assets/cost_model.json (exported by train_cost_estimator.ipynb).
///
/// Encoding order for a raw input row MUST be:
/// [one-hot(location, in `locationCategories` order),
///  one-hot(quality, in `qualityCategories` order),
///  scaled(numeric features, in `numericFeatures` order using
///  `numericMean` / `numericScale`)]
/// — this exactly matches sklearn's ColumnTransformer output order
/// (cat transformer first, then num transformer).
class CostGbmModel {
  final double initPrediction;
  final double learningRate;
  final List<String> locationCategories;
  final List<String> qualityCategories;
  final List<String> numericFeatures;
  final List<double> numericMean;
  final List<double> numericScale;
  final List<List<CostTreeNode>> trees;
  final List<FeatureImportance> featureImportances;
  final double testMaeLakhBdt;
  final double testR2;

  const CostGbmModel({
    required this.initPrediction,
    required this.learningRate,
    required this.locationCategories,
    required this.qualityCategories,
    required this.numericFeatures,
    required this.numericMean,
    required this.numericScale,
    required this.trees,
    required this.featureImportances,
    required this.testMaeLakhBdt,
    required this.testR2,
  });

  factory CostGbmModel.fromJson(Map<String, dynamic> json) {
    final treesJson = json['trees'] as List;
    final trees = treesJson.map((treeJson) {
      final nodesJson = treeJson as List;
      return nodesJson
          .map((n) => CostTreeNode.fromJson(n as Map<String, dynamic>))
          .toList();
    }).toList();

    final importancesJson = (json['feature_importances'] as List?) ?? [];

    return CostGbmModel(
      initPrediction: (json['init_prediction'] as num).toDouble(),
      learningRate: (json['learning_rate'] as num).toDouble(),
      locationCategories:
          (json['location_categories'] as List).map((e) => e as String).toList(),
      qualityCategories:
          (json['quality_categories'] as List).map((e) => e as String).toList(),
      numericFeatures:
          (json['numeric_features'] as List).map((e) => e as String).toList(),
      numericMean:
          (json['numeric_mean'] as List).map((e) => (e as num).toDouble()).toList(),
      numericScale:
          (json['numeric_scale'] as List).map((e) => (e as num).toDouble()).toList(),
      trees: trees,
      featureImportances: importancesJson
          .map((e) => FeatureImportance.fromJson(e as Map<String, dynamic>))
          .toList(),
      testMaeLakhBdt: (json['test_mae_lakh_bdt'] as num).toDouble(),
      testR2: (json['test_r2'] as num).toDouble(),
    );
  }
}
