import 'package:flutter/material.dart';
import '../models/house_gbm_model_info.dart';

class HouseGbmMetricsGrid extends StatelessWidget {
  const HouseGbmMetricsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.6,
      children: [
        _StatTile(
          icon: Icons.track_changes,
          label: 'Accuracy (R²)',
          value: '${(HouseGbmModelInfo.r2Score * 100).toStringAsFixed(2)}%',
          color: Colors.green,
        ),
        _StatTile(
          icon: Icons.rule,
          label: 'Avg. Error',
          value: '±${HouseGbmModelInfo.maeValue.toStringAsFixed(1)} lakh',
          color: Colors.orange,
        ),
        _StatTile(
          icon: Icons.park_outlined,
          label: 'Trees',
          value: '${HouseGbmModelInfo.numTrees} (depth ${HouseGbmModelInfo.maxDepth})',
          color: Colors.blue,
        ),
        _StatTile(
          icon: Icons.dataset_outlined,
          label: 'Trained on',
          value: '${HouseGbmModelInfo.trainingSize} houses',
          color: Colors.purple,
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 15),
                ),
                Text(
                  label,
                  style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
