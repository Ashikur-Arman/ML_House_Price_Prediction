import 'package:flutter/material.dart';
import '../models/house_gbm_prediction_result.dart';
import '../models/house_gbm_model_info.dart';
import '../widgets/section_title.dart';
import '../widgets/house_gbm_metrics_grid.dart';
import '../widgets/model_comparison_grid.dart';
import '../widgets/gbm_feature_usage_tile.dart';

class HouseGbmAnalysisScreen extends StatelessWidget {
  final HouseGbmPredictionResult result;

  const HouseGbmAnalysisScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topFeatures = result.featureUsage.take(8).toList();
    final maxShare = topFeatures.isEmpty
        ? 0.0
        : topFeatures.map((e) => e.sharePercent).reduce((a, b) => a > b ? a : b);

    return Scaffold(
      appBar: AppBar(title: const Text('Prediction Analysis · New Model')),
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
            const HouseGbmMetricsGrid(),
            const SizedBox(height: 28),
            const SectionTitle(
              title: 'New Model vs Old Model',
              icon: Icons.compare_arrows_rounded,
            ),
            const SizedBox(height: 12),
            const ModelComparisonGrid(),
            const SizedBox(height: 28),
            const SectionTitle(
              title: 'Top Factors Driving This Model',
              icon: Icons.leaderboard_outlined,
            ),
            const SizedBox(height: 12),
            ...List.generate(
              topFeatures.length,
              (i) => GbmFeatureUsageTile(
                rank: i + 1,
                item: topFeatures[i],
                maxShare: maxShare,
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
          colors: [theme.colorScheme.tertiary, theme.colorScheme.tertiaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            'Estimated Price · New Model',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onTertiary.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '৳ ${result.predictedPrice.toStringAsFixed(2)} lakh',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onTertiary,
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
            HouseGbmModelInfo.algorithmName,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.tertiary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This model builds ${HouseGbmModelInfo.numTrees} small decision trees '
            '(depth ${HouseGbmModelInfo.maxDepth}) one after another — each new tree '
            'learns to correct the errors left by the ones before it, scaled down by a '
            'learning rate of ${HouseGbmModelInfo.learningRate}. Your property details are '
            'run through all ${HouseGbmModelInfo.numTrees} trees on-device, and their '
            'combined output becomes the final price estimate. Unlike the old model, this '
            'one does not need to store or search through any past house records — the '
            'learned patterns live inside the trees themselves.',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
