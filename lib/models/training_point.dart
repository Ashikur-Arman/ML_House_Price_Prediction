/// One normalized training example loaded from assets/train_data_for_dart.json
class TrainingPoint {
  final List<double> features; // already normalized (mean/std applied)
  final double price;
  final int rowIndex; // 1-based row number in the original dataset CSV

  const TrainingPoint({
    required this.features,
    required this.price,
    required this.rowIndex,
  });

  factory TrainingPoint.fromJson(Map<String, dynamic> json) {
    return TrainingPoint(
      features: (json['features'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      price: (json['price'] as num).toDouble(),
      rowIndex: json['row_index'] as int,
    );
  }
}