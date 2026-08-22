import 'package:flutter/material.dart';
import '../models/house_gbm_model.dart';

/// Shows one feature's split-frequency share across the 500 trees — the
/// new model's stand-in for "how much this feature drives predictions".
class GbmFeatureUsageTile extends StatelessWidget {
  final int rank;
  final FeatureUsage item;
  final double maxShare;

  const GbmFeatureUsageTile({
    super.key,
    required this.rank,
    required this.item,
    required this.maxShare,
  });

  String _friendlyName(String raw) {
    if (raw.startsWith('loc_')) return raw.substring(4);
    final name = raw.replaceAll('_', ' ');
    return name[0].toUpperCase() + name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ratio = maxShare > 0 ? item.sharePercent / maxShare : 0.0;

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
                backgroundColor: theme.colorScheme.tertiaryContainer,
                child: Text(
                  '#$rank',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onTertiaryContainer,
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
                '${item.sharePercent.toStringAsFixed(1)}%',
                style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.tertiary),
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
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.tertiary),
            ),
          ),
        ],
      ),
    );
  }
}
