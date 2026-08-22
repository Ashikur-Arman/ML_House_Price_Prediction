import 'package:flutter/material.dart';
import '../models/model_info.dart';
import '../models/house_gbm_model_info.dart';

/// Side-by-side comparison of the old (KNN) and new (Gradient Boosting)
/// house-price models, evaluated on the exact same held-out test rows —
/// see train_dhaka_price_gbm.ipynb Cell 2 (old model re-scored on this
/// split) and Cell 6-7 (new model), so the two sets of numbers are
/// directly, fairly comparable.
class ModelComparisonGrid extends StatelessWidget {
  const ModelComparisonGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final maeImprovementPercent =
        (ModelInfo.maeValue - HouseGbmModelInfo.maeValue) / ModelInfo.maeValue * 100;
    final r2ImprovementPoints = (HouseGbmModelInfo.r2Score - ModelInfo.r2Score) * 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ComparisonRow(
          theme: theme,
          label: 'Accuracy (R²)',
          oldValue: '${(ModelInfo.r2Score * 100).toStringAsFixed(1)}%',
          newValue: '${(HouseGbmModelInfo.r2Score * 100).toStringAsFixed(1)}%',
          icon: Icons.track_changes,
        ),
        const SizedBox(height: 10),
        _ComparisonRow(
          theme: theme,
          label: 'Avg. Error (MAE)',
          oldValue: '±${ModelInfo.maeValue.toStringAsFixed(1)} lakh',
          newValue: '±${HouseGbmModelInfo.maeValue.toStringAsFixed(1)} lakh',
          icon: Icons.rule,
        ),
        const SizedBox(height: 10),
        _ComparisonRow(
          theme: theme,
          label: 'Typical % Error (MAPE)',
          oldValue: '—',
          newValue: '${HouseGbmModelInfo.mapeValue.toStringAsFixed(1)}%',
          icon: Icons.percent,
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.green.withOpacity(0.25)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.trending_up, color: Colors.green),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'On the same 500 held-out test houses, the new model cuts average '
                  'error by ${maeImprovementPercent.toStringAsFixed(0)}% (৳${ModelInfo.maeValue.toStringAsFixed(0)} '
                  '→ ৳${HouseGbmModelInfo.maeValue.toStringAsFixed(0)} lakh) and explains '
                  '${r2ImprovementPoints.toStringAsFixed(1)} more percentage points of price '
                  'variance — because 500 boosted trees can capture location- and '
                  'feature-specific non-linear patterns that a distance-based KNN average '
                  'smooths over.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.green[800],
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  final ThemeData theme;
  final String label;
  final String oldValue;
  final String newValue;
  final IconData icon;

  const _ComparisonRow({
    required this.theme,
    required this.label,
    required this.oldValue,
    required this.newValue,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Icon(icon, size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _ValueChip(
                  label: 'Old · KNN',
                  value: oldValue,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, size: 16, color: theme.colorScheme.outline),
              const SizedBox(width: 8),
              Expanded(
                child: _ValueChip(
                  label: 'New · GBM',
                  value: newValue,
                  color: theme.colorScheme.tertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ValueChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ValueChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: color)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 14)),
        ],
      ),
    );
  }
}
