import 'dart:math';

import 'package:flutter/material.dart';

import '../models/knn_prediction_result.dart';
import '../theme/app_theme.dart';
import 'section_title.dart';

class KnnAnalysisCard extends StatelessWidget {
  final KnnPredictionResult result;

  const KnnAnalysisCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(24),
        side: const BorderSide(
          color: AppTheme.border,
        ),
      ),
      child: Padding(
        padding:
        const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const SectionTitle(
              icon: Icons.psychology_outlined,
              title:
              'How did KNN make this prediction?',
              subtitle:
              'The model compares your property with similar properties from the training dataset.',
            ),

            const SizedBox(height: 24),

            _buildStep(
              number: '1',
              icon:
              Icons.home_outlined,
              title: 'Your Property',
              description:
              'The five property features you entered are used as the input.',
            ),

            _buildConnector(),

            _buildStep(
              number: '2',
              icon:
              Icons.tune_outlined,
              title: 'Feature Normalization',
              description:
              'Each feature is standardized using the same mean and standard deviation used during training.',
            ),

            _buildConnector(),

            _buildStep(
              number: '3',
              icon:
              Icons.straighten_outlined,
              title: 'Distance Calculation',
              description:
              'Euclidean distance measures how similar each training property is to your property.',
            ),

            _buildConnector(),

            _buildStep(
              number: '4',
              icon:
              Icons.groups_outlined,
              title:
              '${result.k} Nearest Neighbors',
              description:
              'The ${result.k} most similar properties are selected.',
            ),

            _buildConnector(),

            _buildStep(
              number: '5',
              icon:
              Icons.balance_outlined,
              title:
              'Distance-Based Weighting',
              description:
              'Closer properties receive more influence using weight = 1 / distance.',
            ),

            _buildConnector(),

            _buildStep(
              number: '6',
              icon:
              Icons.auto_graph_outlined,
              title: 'Final Prediction',
              description:
              'The weighted average of the neighbor prices becomes the final estimated price.',
            ),

            const SizedBox(height: 24),

            _buildAlgorithmDetails(),

            const SizedBox(height: 24),

            _buildNeighbors(),
          ],
        ),
      ),
    );
  }

  Widget _buildStep({
    required String number,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppTheme.primary
                .withOpacity(0.10),
            borderRadius:
            BorderRadius.circular(13),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: AppTheme.primary,
                fontWeight:
                FontWeight.w800,
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    size: 18,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight:
                        FontWeight.w700,
                        fontSize: 14,
                        color:
                        AppTheme.darkText,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color:
                  AppTheme.greyText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConnector() {
    return Padding(
      padding:
      const EdgeInsets.only(
        left: 20,
        top: 5,
        bottom: 5,
      ),
      child: Container(
        width: 2,
        height: 18,
        color:
        AppTheme.primary.withOpacity(
          0.15,
        ),
      ),
    );
  }

  Widget _buildAlgorithmDetails() {
    return Container(
      padding:
      const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
        AppTheme.background,
        borderRadius:
        BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text(
            'KNN Configuration',
            style: TextStyle(
              fontWeight:
              FontWeight.w700,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 12),

          _detailRow(
            'Algorithm',
            result.algorithm,
          ),

          _detailRow(
            'Neighbors (K)',
            result.k.toString(),
          ),

          _detailRow(
            'Distance',
            result.distanceMetric,
          ),

          _detailRow(
            'Weighting',
            result.weightingMethod,
          ),

          _detailRow(
            'Normalization',
            result.normalizationMethod,
          ),

          _detailRow(
            'Execution',
            'On-device',
          ),

          _detailRow(
            'Internet Required',
            'No',
          ),
        ],
      ),
    );
  }

  Widget _detailRow(
      String label,
      String value,
      ) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color:
                AppTheme.greyText,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign:
              TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
                fontWeight:
                FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeighbors() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const Text(
          'Nearest Properties Used',
          style: TextStyle(
            fontSize: 16,
            fontWeight:
            FontWeight.w700,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'Closer properties have greater influence on the final prediction.',
          style: TextStyle(
            fontSize: 12,
            color:
            AppTheme.greyText,
          ),
        ),

        const SizedBox(height: 16),

        ...result.neighbors
            .asMap()
            .entries
            .map(
              (entry) => _buildNeighborRow(
            position:
            entry.key + 1,
            neighbor:
            entry.value,
          ),
        ),
      ],
    );
  }

  Widget _buildNeighborRow({
    required int position,
    required NeighborResult neighbor,
  }) {
    final maxWeight =
    result.neighbors
        .map((e) => e.weight)
        .reduce(max);

    final influence =
    maxWeight > 0
        ? neighbor.weight / maxWeight
        : 0.0;

    return Container(
      margin:
      const EdgeInsets.only(
        bottom: 9,
      ),
      padding:
      const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
        AppTheme.background,
        borderRadius:
        BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration:
                BoxDecoration(
                  color: AppTheme.primary
                      .withOpacity(
                    0.10,
                  ),
                  borderRadius:
                  BorderRadius.circular(
                    9,
                  ),
                ),
                child: Center(
                  child: Text(
                    '$position',
                    style:
                    const TextStyle(
                      fontSize: 11,
                      fontWeight:
                      FontWeight.w800,
                      color:
                      AppTheme.primary,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price: ৳${neighbor.price.toStringAsFixed(2)} Lakh',
                      style:
                      const TextStyle(
                        fontSize: 12,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Distance: ${neighbor.distance.toStringAsFixed(4)}',
                      style:
                      const TextStyle(
                        fontSize: 10,
                        color:
                        AppTheme.greyText,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment:
                CrossAxisAlignment.end,
                children: [
                  Text(
                    'Weight',
                    style:
                    const TextStyle(
                      fontSize: 9,
                      color:
                      AppTheme.greyText,
                    ),
                  ),
                  Text(
                    neighbor.weight
                        .toStringAsFixed(3),
                    style:
                    const TextStyle(
                      fontSize: 11,
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 9),

          ClipRRect(
            borderRadius:
            BorderRadius.circular(10),
            child: LinearProgressIndicator(
              minHeight: 6,
              value: influence
                  .clamp(0.0, 1.0),
              backgroundColor:
              Colors.white,
              valueColor:
              const AlwaysStoppedAnimation<
                  Color>(
                AppTheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}