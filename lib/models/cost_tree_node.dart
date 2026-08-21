/// One node of an exported sklearn DecisionTreeRegressor, as produced by
/// the notebook's `export_tree()` function.
class CostTreeNode {
  final bool leaf;
  final double? value; // only set when leaf == true
  final int? feature; // index into the encoded feature vector
  final double? threshold;
  final int? left; // index of left child node (x[feature] <= threshold)
  final int? right; // index of right child node (x[feature] > threshold)

  const CostTreeNode({
    required this.leaf,
    this.value,
    this.feature,
    this.threshold,
    this.left,
    this.right,
  });

  factory CostTreeNode.fromJson(Map<String, dynamic> json) {
    final isLeaf = json['leaf'] as bool;
    if (isLeaf) {
      return CostTreeNode(leaf: true, value: (json['value'] as num).toDouble());
    }
    return CostTreeNode(
      leaf: false,
      feature: json['feature'] as int,
      threshold: (json['threshold'] as num).toDouble(),
      left: json['left'] as int,
      right: json['right'] as int,
    );
  }
}
