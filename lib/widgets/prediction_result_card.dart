import 'package:flutter/material.dart';

import '../models/house_features.dart';
import '../models/knn_prediction_result.dart';
import '../theme/app_theme.dart';

class PredictionResultCard extends StatelessWidget {
  final HouseFeatures input;
  final KnnPredictionResult result;

  const PredictionResultCard({
    super.key,
    required this.input,
    required this.result,
  });

  String _formatPrice(double value) {
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primary,
            Color(0xFF4D6FE8),
          ],
        ),
        borderRadius:
        BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color:
            AppTheme.primary.withOpacity(
              0.20,
            ),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding:
        const EdgeInsets.all(22),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding:
                  const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(0.15),
                    borderRadius:
                    BorderRadius.circular(
                      14,
                    ),
                  ),
                  child: const Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Estimated Property Value',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 26),

            const Text(
              'AI PREDICTED PRICE',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11,
                letterSpacing: 1.4,
                fontWeight:
                FontWeight.w700,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              '৳ ${_formatPrice(result.predictedPrice)} Lakh',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight:
                FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              result.exactMatch
                  ? 'Exact match found in training data'
                  : 'Estimated using ${result.k} similar properties',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 22),

            Container(
              padding:
              const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white
                    .withOpacity(0.10),
                borderRadius:
                BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _InfoItem(
                      icon: Icons.home_work_outlined,
                      label: 'Area',
                      value:
                      '${input.areaSqft.toStringAsFixed(0)} sqft',
                    ),
                  ),
                  Expanded(
                    child: _InfoItem(
                      icon: Icons.bed_outlined,
                      label: 'Bedrooms',
                      value:
                      input.bedrooms.toInt().toString(),
                    ),
                  ),
                  Expanded(
                    child: _InfoItem(
                      icon:
                      Icons.bathtub_outlined,
                      label: 'Bathrooms',
                      value:
                      input.bathrooms.toInt().toString(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding:
              const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white
                    .withOpacity(0.10),
                borderRadius:
                BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _InfoItem(
                      icon: Icons
                          .calendar_month_outlined,
                      label: 'Age',
                      value:
                      '${input.ageYears.toStringAsFixed(0)} years',
                    ),
                  ),
                  Expanded(
                    child: _InfoItem(
                      icon:
                      Icons.location_on_outlined,
                      label: 'City Distance',
                      value:
                      '${input.distanceToCityKm.toStringAsFixed(1)} km',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 11,
              ),
              decoration: BoxDecoration(
                color: Colors.white
                    .withOpacity(0.12),
                borderRadius:
                BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.white70,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This is an estimated value, not an official market valuation.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white70,
          size: 19,
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight:
            FontWeight.w700,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}