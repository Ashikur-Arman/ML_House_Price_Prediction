import 'package:flutter/material.dart';

import '../models/house_features.dart';
import '../theme/app_theme.dart';
import 'section_title.dart';

class FeatureInputCard extends StatefulWidget {
  final HouseFeatures initialValues;
  final ValueChanged<HouseFeatures> onPredict;
  final VoidCallback onReset;
  final bool isLoading;

  const FeatureInputCard({
    super.key,
    required this.initialValues,
    required this.onPredict,
    required this.onReset,
    required this.isLoading,
  });

  @override
  State<FeatureInputCard> createState() =>
      _FeatureInputCardState();
}

class _FeatureInputCardState
    extends State<FeatureInputCard> {
  late final TextEditingController
  _areaController;

  late double _bedrooms;
  late double _bathrooms;
  late double _ageYears;
  late double _distance;

  String? _areaError;

  @override
  void initState() {
    super.initState();

    _areaController =
        TextEditingController(
          text: _formatNumber(
            widget.initialValues.areaSqft,
          ),
        );

    _bedrooms =
        widget.initialValues.bedrooms;

    _bathrooms =
        widget.initialValues.bathrooms;

    _ageYears =
        widget.initialValues.ageYears;

    _distance =
        widget.initialValues.distanceToCityKm;
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toString();
  }

  @override
  void dispose() {
    _areaController.dispose();
    super.dispose();
  }

  void _submit() {
    final areaText =
    _areaController.text.trim();

    final area =
    double.tryParse(areaText);

    if (area == null || area <= 0) {
      setState(() {
        _areaError =
        'Please enter a valid area greater than 0.';
      });
      return;
    }

    if (area < 300 || area > 20000) {
      setState(() {
        _areaError =
        'Please enter an area between 300 and 20,000 sqft.';
      });
      return;
    }

    setState(() {
      _areaError = null;
    });

    final features = HouseFeatures(
      areaSqft: area,
      bedrooms: _bedrooms,
      bathrooms: _bathrooms,
      ageYears: _ageYears,
      distanceToCityKm: _distance,
    );

    widget.onPredict(features);
  }

  void _reset() {
    _areaController.text =
        _formatNumber(
          widget.initialValues.areaSqft,
        );

    setState(() {
      _bedrooms =
          widget.initialValues.bedrooms;

      _bathrooms =
          widget.initialValues.bathrooms;

      _ageYears =
          widget.initialValues.ageYears;

      _distance =
          widget.initialValues.distanceToCityKm;

      _areaError = null;
    });

    widget.onReset();
  }

  Widget _buildAreaField() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const Text(
          'Property Area',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),

        TextFormField(
          controller: _areaController,
          keyboardType:
          const TextInputType.numberWithOptions(
            decimal: true,
          ),
          decoration:
          const InputDecoration(
            hintText: 'e.g. 1800',
            suffixText: 'sqft',
            prefixIcon: Icon(
              Icons.home_work_outlined,
            ),
          ),
        ),

        const SizedBox(height: 5),

        Text(
          'Total area of the property in square feet.',
          style: TextStyle(
            fontSize: 12,
            color:
            _areaError == null
                ? AppTheme.greyText
                : Colors.red,
          ),
        ),

        if (_areaError != null) ...[
          const SizedBox(height: 4),
          Text(
            _areaError!,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSlider({
    required String title,
    required String description,
    required IconData icon,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String unit,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: AppTheme.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: AppTheme.primary
                    .withOpacity(0.08),
                borderRadius:
                BorderRadius.circular(10),
              ),
              child: Text(
                '${_formatNumber(value)} $unit',
                style: const TextStyle(
                  color: AppTheme.primary,
                  fontWeight:
                  FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),

        Text(
          description,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.greyText,
          ),
        ),

        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: AppTheme.primary,
          onChanged: onChanged,
        ),
      ],
    );
  }

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
              icon: Icons.home_outlined,
              title: 'Property Details',
              subtitle:
              'Enter a few details about the property to get an AI-powered price estimate.',
            ),

            const SizedBox(height: 24),

            _buildAreaField(),

            const SizedBox(height: 22),

            _buildSlider(
              title: 'Bedrooms',
              description:
              'Number of bedrooms in the property.',
              icon: Icons.bed_outlined,
              value: _bedrooms,
              min: 1,
              max: 10,
              divisions: 9,
              unit: '',
              onChanged: (value) {
                setState(() {
                  _bedrooms = value;
                });
              },
            ),

            const Divider(height: 24),

            _buildSlider(
              title: 'Bathrooms',
              description:
              'Total number of bathrooms.',
              icon: Icons.bathtub_outlined,
              value: _bathrooms,
              min: 1,
              max: 8,
              divisions: 7,
              unit: '',
              onChanged: (value) {
                setState(() {
                  _bathrooms = value;
                });
              },
            ),

            const Divider(height: 24),

            _buildSlider(
              title: 'House Age',
              description:
              'Approximate age of the property.',
              icon:
              Icons.calendar_month_outlined,
              value: _ageYears,
              min: 0,
              max: 100,
              divisions: 100,
              unit: 'years',
              onChanged: (value) {
                setState(() {
                  _ageYears = value;
                });
              },
            ),

            const Divider(height: 24),

            _buildSlider(
              title: 'Distance from City',
              description:
              'Approximate distance from the city center.',
              icon:
              Icons.location_on_outlined,
              value: _distance,
              min: 0,
              max: 100,
              divisions: 200,
              unit: 'km',
              onChanged: (value) {
                setState(() {
                  _distance = value;
                });
              },
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed:
                    widget.isLoading
                        ? null
                        : _reset,
                    icon: const Icon(
                      Icons.refresh,
                    ),
                    label:
                    const Text('Reset'),
                    style:
                    OutlinedButton.styleFrom(
                      padding:
                      const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          16,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed:
                    widget.isLoading
                        ? null
                        : _submit,
                    icon: widget.isLoading
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Icon(
                      Icons.auto_awesome,
                    ),
                    label: Text(
                      widget.isLoading
                          ? 'Predicting...'
                          : 'Predict Price',
                    ),
                    style:
                    ElevatedButton.styleFrom(
                      backgroundColor:
                      AppTheme.primary,
                      foregroundColor:
                      Colors.white,
                      elevation: 0,
                      padding:
                      const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}