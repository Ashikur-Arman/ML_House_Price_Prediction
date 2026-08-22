/// One exported `GradientBoostingRegressor` estimator (a single regression
/// tree), stored as sklearn's own flat `tree_` arrays — NOT the same shape
/// as [CostTreeNode] (which is one-JSON-object-per-node). This is the
/// format produced by train_dhaka_price_gbm.ipynb, Cell 9:
///   t = est.tree_
///   { "feature": t.feature.tolist(), "threshold": t.threshold.tolist(),
///     "left": t.children_left.tolist(), "right": t.children_right.tolist(),
///     "value": t.value[:, 0, 0].tolist() }
/// `feature[node] == -2` marks a leaf (sklearn's internal leaf sentinel) —
/// there is no separate `leaf` boolean like the cost model's format.
class GbmTree {
  final List<int> feature;
  final List<double> threshold;
  final List<int> left;
  final List<int> right;
  final List<double> value;

  const GbmTree({
    required this.feature,
    required this.threshold,
    required this.left,
    required this.right,
    required this.value,
  });

  factory GbmTree.fromJson(Map<String, dynamic> json) {
    return GbmTree(
      feature: (json['feature'] as List).map((e) => e as int).toList(),
      threshold: (json['threshold'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      left: (json['left'] as List).map((e) => e as int).toList(),
      right: (json['right'] as List).map((e) => e as int).toList(),
      value: (json['value'] as List).map((e) => (e as num).toDouble()).toList(),
    );
  }

  /// Walks the tree for one (already-scaled) input row and returns the
  /// leaf value — mirrors sklearn's own `tree_.predict()` traversal
  /// exactly (verified against the notebook's own sample prediction).
  double predict(List<double> x) {
    int node = 0;
    while (feature[node] != -2) {
      final f = feature[node];
      node = x[f] <= threshold[node] ? left[node] : right[node];
    }
    return value[node];
  }
}

/// How often a feature was used to split, across every tree in the
/// ensemble — computed once at load time straight from the actual
/// exported trees (not a separate notebook export), so it always reflects
/// exactly the model that is running on-device right now.
class FeatureUsage {
  final String feature;
  final int splitCount;
  final double sharePercent;

  const FeatureUsage({
    required this.feature,
    required this.splitCount,
    required this.sharePercent,
  });
}

/// Fully on-device Gradient Boosting model for House Price — parsed from
/// assets/gbm_model_for_dart.json (the 500 trees) +
/// assets/house_gbm_scaler_params.json (feature order + StandardScaler
/// mean/std), both exported by train_dhaka_price_gbm.ipynb.
///
/// Encoding order for a raw input row MUST be:
/// [area_sqft, bedrooms, bathrooms, age_years, distance_to_city_km,
///  floor_no, has_lift, has_parking, loc_<one-hot, alphabetical>]
/// — this is exactly [HouseFeatures.toRawList], so the very same input
/// model already used by the old KNN screen is reused as-is here too.
class HouseGbmModel {
  final double initValue;
  final double learningRate;
  final int nEstimators;
  final List<GbmTree> trees;
  final List<String> features; // scaler feature order
  final List<double> mean;
  final List<double> std;
  final List<FeatureUsage> featureUsage; // sorted, most-used first

  const HouseGbmModel({
    required this.initValue,
    required this.learningRate,
    required this.nEstimators,
    required this.trees,
    required this.features,
    required this.mean,
    required this.std,
    required this.featureUsage,
  });

  factory HouseGbmModel.fromJson({
    required Map<String, dynamic> modelJson,
    required Map<String, dynamic> scalerJson,
  }) {
    final treesJson = modelJson['trees'] as List;
    final trees = treesJson
        .map((t) => GbmTree.fromJson(t as Map<String, dynamic>))
        .toList();

    final features =
        (scalerJson['features'] as List).map((e) => e as String).toList();

    // Split-frequency per feature, across all trees — our on-device stand-in
    // for sklearn's feature_importances_ (which needs impurity data we don't
    // export), computed directly from the exact trees used for prediction.
    final counts = List<int>.filled(features.length, 0);
    int totalSplits = 0;
    for (final tree in trees) {
      for (final f in tree.feature) {
        if (f != -2) {
          counts[f]++;
          totalSplits++;
        }
      }
    }
    final usage = List.generate(features.length, (i) {
      return FeatureUsage(
        feature: features[i],
        splitCount: counts[i],
        sharePercent: totalSplits == 0 ? 0.0 : counts[i] / totalSplits * 100,
      );
    })
      ..sort((a, b) => b.splitCount.compareTo(a.splitCount));

    return HouseGbmModel(
      initValue: (modelJson['init_value'] as num).toDouble(),
      learningRate: (modelJson['learning_rate'] as num).toDouble(),
      nEstimators: modelJson['n_estimators'] as int,
      trees: trees,
      features: features,
      mean: (scalerJson['mean'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      std: (scalerJson['std'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      featureUsage: usage,
    );
  }
}
