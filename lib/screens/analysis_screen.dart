import 'package:flutter/material.dart';
import '../models/prediction_result.dart';
import '../models/model_info.dart';
import '../widgets/section_title.dart';
import '../widgets/model_metrics_grid.dart';
import '../widgets/neighbor_tile.dart';

class AnalysisScreen extends StatelessWidget {
  final PredictionResult result;

  const AnalysisScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Prediction Analysis')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPriceHeader(theme),
            const SizedBox(height: 28),
            const SectionTitle(title: 'How This Prediction Works', icon: Icons.psychology_outlined),
            const SizedBox(height: 12),
            _buildExplanationCard(theme),
            const SizedBox(height: 28),
            const SectionTitle(title: 'Model Performance', icon: Icons.query_stats),
            const SizedBox(height: 12),
            const ModelMetricsGrid(),
            const SizedBox(height: 28),
            SectionTitle(
              title: 'Similar Houses Used (Top ${result.topNeighbors.length})',
              icon: Icons.holiday_village_outlined,
            ),
            const SizedBox(height: 12),
            ...List.generate(
              result.topNeighbors.length,
                  (i) => NeighborTile(rank: i + 1, neighbor: result.topNeighbors[i]),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceHeader(ThemeData theme) {
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
      ),
      child: Column(
        children: [
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
        ],
      ),
    );
  }

  Widget _buildExplanationCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ModelInfo.algorithmName,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This model looks at the ${ModelInfo.kNeighbors} most similar houses '
                'from historical data — matched by area, bedrooms, bathrooms, age, '
                'and location — and calculates a weighted average of their prices. '
                'Houses more similar to yours have more influence on the final price. '
                'The list below shows exactly which houses were used and how much '
                'each one contributed.',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}