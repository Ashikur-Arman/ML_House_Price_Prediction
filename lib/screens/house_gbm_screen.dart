import 'package:flutter/material.dart';
import '../models/house_features.dart';
import '../models/house_gbm_prediction_result.dart';
import '../services/house_gbm_predictor_service.dart';
import '../widgets/feature_input_field.dart';
import '../widgets/house_gbm_result_card.dart';
import '../widgets/section_title.dart';
import 'house_gbm_analysis_screen.dart';

/// New tab: House Price Predictor powered by the tuned Gradient Boosting
/// model (train_dhaka_price_gbm.ipynb). Same property-detail form and
/// input shape as the old KNN tab ([HomeScreen]) — only the model
/// underneath is different — so both models can be compared fairly on
/// identical inputs.
class HouseGbmScreen extends StatefulWidget {
  const HouseGbmScreen({super.key});

  @override
  State<HouseGbmScreen> createState() => _HouseGbmScreenState();
}

class _HouseGbmScreenState extends State<HouseGbmScreen> {
  final _formKey = GlobalKey<FormState>();
  final _predictor = HouseGbmPredictorService();

  final _areaController = TextEditingController();
  final _bedroomsController = TextEditingController();
  final _bathroomsController = TextEditingController();
  final _ageController = TextEditingController();
  final _distanceController = TextEditingController();
  final _floorController = TextEditingController();

  bool _hasLift = false;
  bool _hasParking = false;
  String _selectedLocation = kLocations.first;

  bool _isModelLoading = true;
  bool _isPredicting = false;
  HouseGbmPredictionResult? _result;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      await _predictor.loadData();
      setState(() => _isModelLoading = false);
    } catch (e) {
      setState(() {
        _isModelLoading = false;
        _errorMessage = 'Failed to load model: $e';
      });
    }
  }

  String? _validate(String? value, {required double min, required double max}) {
    if (value == null || value.trim().isEmpty) return 'Required';
    final n = double.tryParse(value);
    if (n == null) return 'Enter a valid number';
    if (n < min || n > max) return 'Must be between $min and $max';
    return null;
  }

  void _onPredictPressed() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() {
      _isPredicting = true;
      _errorMessage = null;
    });

    try {
      final input = HouseFeatures(
        areaSqft: double.parse(_areaController.text),
        bedrooms: double.parse(_bedroomsController.text),
        bathrooms: double.parse(_bathroomsController.text),
        ageYears: double.parse(_ageController.text),
        distanceToCityKm: double.parse(_distanceController.text),
        floorNo: double.parse(_floorController.text),
        hasLift: _hasLift,
        hasParking: _hasParking,
        locationArea: _selectedLocation,
      );

      final result = _predictor.predict(input);

      setState(() {
        _result = result;
        _isPredicting = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Prediction failed: $e';
        _isPredicting = false;
      });
    }
  }

  @override
  void dispose() {
    _areaController.dispose();
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    _ageController.dispose();
    _distanceController.dispose();
    _floorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isModelLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(theme),
              const SizedBox(height: 28),
              const SectionTitle(title: 'Property Details', icon: Icons.edit_note),
              const SizedBox(height: 12),
              _buildForm(theme),
              const SizedBox(height: 24),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                ),
              if (_result != null) ...[
                const SectionTitle(title: 'Prediction Result', icon: Icons.auto_awesome),
                const SizedBox(height: 12),
                HouseGbmResultCard(
                  result: _result!,
                  onViewAnalysis: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HouseGbmAnalysisScreen(result: _result!),
                      ),
                    );
                  },
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.tertiary, theme.colorScheme.tertiaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_graph_rounded, size: 44, color: Colors.white),
          ),
          const SizedBox(height: 12),
          const Text(
            'House Price Predictor',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'New model · Gradient Boosting — works fully offline',
            style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(ThemeData theme) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              FeatureInputField(
                controller: _areaController,
                label: 'Area',
                hint: 'e.g. 1800',
                icon: Icons.square_foot,
                suffixText: 'sqft',
                validator: (v) => _validate(v, min: 100, max: 20000),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: FeatureInputField(
                      controller: _bedroomsController,
                      label: 'Bedrooms',
                      hint: '3',
                      icon: Icons.bed,
                      validator: (v) => _validate(v, min: 1, max: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FeatureInputField(
                      controller: _bathroomsController,
                      label: 'Bathrooms',
                      hint: '2',
                      icon: Icons.bathtub_outlined,
                      validator: (v) => _validate(v, min: 1, max: 10),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              FeatureInputField(
                controller: _ageController,
                label: 'Building Age',
                hint: 'e.g. 5',
                icon: Icons.calendar_month_outlined,
                suffixText: 'years',
                validator: (v) => _validate(v, min: 0, max: 150),
              ),
              const SizedBox(height: 14),
              FeatureInputField(
                controller: _distanceController,
                label: 'Distance to City Center',
                hint: 'e.g. 4.5',
                icon: Icons.location_on_outlined,
                suffixText: 'km',
                validator: (v) => _validate(v, min: 0, max: 200),
              ),
              const SizedBox(height: 14),
              FeatureInputField(
                controller: _floorController,
                label: 'Floor No.',
                hint: 'e.g. 3',
                icon: Icons.stairs_outlined,
                validator: (v) => _validate(v, min: 0, max: 100),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: _selectedLocation,
                decoration: InputDecoration(
                  labelText: 'Location',
                  prefixIcon: Icon(Icons.map_outlined, color: theme.colorScheme.tertiary),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: theme.colorScheme.tertiary, width: 2),
                  ),
                ),
                items: kLocations
                    .map((loc) => DropdownMenuItem(value: loc, child: Text(loc)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _selectedLocation = v);
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Lift', style: TextStyle(fontSize: 14)),
                      value: _hasLift,
                      onChanged: (v) => setState(() => _hasLift = v),
                    ),
                  ),
                  Expanded(
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Parking', style: TextStyle(fontSize: 14)),
                      value: _hasParking,
                      onChanged: (v) => setState(() => _hasParking = v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isPredicting ? null : _onPredictPressed,
                  icon: _isPredicting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.remember_me_outlined),
                  label: Text(_isPredicting ? 'Calculating...' : 'Predict Price'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.tertiary,
                    foregroundColor: theme.colorScheme.onTertiary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
