import 'package:flutter/material.dart';
import '../models/prediction_result.dart';

class PredictionResultCard extends StatelessWidget {
  final PredictionResult result;

  const PredictionResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.home_work_rounded, size: 40, color: theme.colorScheme.onPrimary),
          const SizedBox(height: 8),
          Text(
            'Estimated Price',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onPrimary.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '৳ ${result.predictedPrice.toStringAsFixed(2)} lakh',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: theme.colorScheme.onPrimary.withOpacity(0.3)),
          const SizedBox(height: 8),
          Text(
            'Based on ${result.topNeighbors.length} most similar houses',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onPrimary.withOpacity(0.85),
            ),
          ),
          const SizedBox(height: 12),
          ...result.topNeighbors.take(3).map(
                (n) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '৳ ${n.price.toStringAsFixed(1)} lakh',
                    style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 13),
                  ),
                  Text(
                    '${n.weightPercent.toStringAsFixed(1)}% influence',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}