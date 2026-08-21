import 'package:flutter/material.dart';
import '../models/cost_prediction_result.dart';
import '../models/cost_model_info.dart';
import '../widgets/section_title.dart';
import '../widgets/cost_model_metrics_grid.dart';
import '../widgets/feature_importance_tile.dart';

class CostAnalysisScreen extends StatelessWidget {
  final CostPredictionResult result;

  const CostAnalysisScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxImportance = result.featureImportances.isEmpty
        ? 0.0
        : result.featureImportances.map((e) => e.importance).reduce((a, b) => a > b ? a : b);

    return Scaffold(
      appBar: AppBar(title: const Text('Cost Estimate Analysis')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPriceHeader(theme),
            const SizedBox(height: 28),
            const SectionTitle(title: 'How This Estimate Works', icon: Icons.psychology_outlined),
            const SizedBox(height: 12),
            _buildExplanationCard(theme),
            const SizedBox(height: 28),
            const SectionTitle(title: 'Model Performance', icon: Icons.query_stats),
            const SizedBox(height: 12),
            const CostModelMetricsGrid(),
            const SizedBox(height: 28),
            const SectionTitle(
              title: 'Top Factors Driving This Estimate',
              icon: Icons.leaderboard_outlined,
            ),
            const SizedBox(height: 12),
            ...List.generate(
              result.featureImportances.length,
              (i) => FeatureImportanceTile(
                rank: i + 1,
                item: result.featureImportances[i],
                maxImportance: maxImportance,
              ),
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
          colors: [theme.colorScheme.secondary, theme.colorScheme.secondaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
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
            CostModelInfo.algorithmName,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This model builds ${CostModelInfo.numTrees} small decision trees '
            '(depth ${CostModelInfo.maxDepth}) one after another — each new '
            'tree learns to correct the errors left by the ones before it. '
            'Your project details are run through all ${CostModelInfo.numTrees} '
            'trees on-device, and their combined output becomes the final '
            'cost estimate. The list below shows which project features '
            'have the biggest overall influence on this model\'s predictions.',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
