import 'package:flutter/material.dart';
import '../models/cost_gbm_model.dart';

class FeatureImportanceTile extends StatelessWidget {
  final int rank;
  final FeatureImportance item;
  final double maxImportance;

  const FeatureImportanceTile({
    super.key,
    required this.rank,
    required this.item,
    required this.maxImportance,
  });

  String _friendlyName(String raw) {
    var name = raw.replaceFirst('cat__', '').replaceFirst('num__', '');
    name = name.replaceAll('_', ' ');
    return name[0].toUpperCase() + name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ratio = maxImportance > 0 ? item.importance / maxImportance : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: theme.colorScheme.secondaryContainer,
                child: Text(
                  '#$rank',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _friendlyName(item.feature),
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
              Text(
                '${(item.importance * 100).toStringAsFixed(1)}%',
                style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.secondary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              minHeight: 6,
              value: ratio.clamp(0.0, 1.0),
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.secondary),
            ),
          ),
        ],
      ),
    );
  }
}
