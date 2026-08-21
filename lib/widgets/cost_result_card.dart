import 'package:flutter/material.dart';
import '../models/cost_prediction_result.dart';

class CostResultCard extends StatelessWidget {
  final CostPredictionResult result;
  final VoidCallback onViewAnalysis;

  const CostResultCard({
    super.key,
    required this.result,
    required this.onViewAnalysis,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.secondary, theme.colorScheme.secondaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.secondary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.construction_rounded, size: 40, color: theme.colorScheme.onSecondary),
          const SizedBox(height: 8),
          Text(
            'Estimated Construction Cost',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSecondary.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '৳ ${result.predictedPrice.toStringAsFixed(2)} lakh',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: theme.colorScheme.onSecondary.withOpacity(0.3)),
          const SizedBox(height: 12),
          Text(
            'Predicted by a 200-tree Gradient Boosting model',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSecondary.withOpacity(0.85),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onViewAnalysis,
              icon: Icon(Icons.insights, color: theme.colorScheme.onSecondary),
              label: Text(
                'View Detailed Analysis',
                style: TextStyle(color: theme.colorScheme.onSecondary),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.colorScheme.onSecondary.withOpacity(0.6)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
