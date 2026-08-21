import 'package:flutter/material.dart';
import '../models/construction_features.dart';
import '../models/cost_prediction_result.dart';
import '../services/cost_predictor_service.dart';
import '../widgets/feature_input_field.dart';
import '../widgets/cost_result_card.dart';
import '../widgets/section_title.dart';
import 'cost_analysis_screen.dart';

class CostEstimatorScreen extends StatefulWidget {
  const CostEstimatorScreen({super.key});

  @override
  State<CostEstimatorScreen> createState() => _CostEstimatorScreenState();
}

class _CostEstimatorScreenState extends State<CostEstimatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _predictor = CostPredictorService();

  final _landAreaController = TextEditingController();
  final _floorsController = TextEditingController();
  final _roomsController = TextEditingController();
  final _bathroomsController = TextEditingController();
  final _distanceController = TextEditingController();

  bool _hasLift = false;
  bool _hasParking = false;
  bool _hasGenerator = false;
  bool _hasRooftopGarden = false;
  String _selectedLocation = kCostLocations.first;
  String _selectedQuality = kConstructionQualities.first;

  bool _isModelLoading = true;
  bool _isPredicting = false;
  CostPredictionResult? _result;
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
      final input = ConstructionFeatures(
        landAreaKatha: double.parse(_landAreaController.text),
        numFloors: double.parse(_floorsController.text),
        roomsPerFloor: double.parse(_roomsController.text),
        bathroomsPerFloor: double.parse(_bathroomsController.text),
        distanceToMainRoadKm: double.parse(_distanceController.text),
        hasLift: _hasLift,
        hasParking: _hasParking,
        hasGenerator: _hasGenerator,
        hasRooftopGarden: _hasRooftopGarden,
        locationArea: _selectedLocation,
        constructionQuality: _selectedQuality,
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
    _landAreaController.dispose();
    _floorsController.dispose();
    _roomsController.dispose();
    _bathroomsController.dispose();
    _distanceController.dispose();
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
              const SectionTitle(title: 'Project Details', icon: Icons.edit_note),
              const SizedBox(height: 12),
              _buildForm(theme),
              const SizedBox(height: 24),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                ),
              if (_result != null) ...[
                const SectionTitle(title: 'Estimate Result', icon: Icons.auto_awesome),
                const SizedBox(height: 12),
                CostResultCard(
                  result: _result!,
                  onViewAnalysis: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CostAnalysisScreen(result: _result!),
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
          colors: [theme.colorScheme.secondary, theme.colorScheme.secondaryContainer],
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
            child: const Icon(Icons.engineering_rounded, size: 44, color: Colors.white),
          ),
          const SizedBox(height: 12),
          const Text(
            'Construction Cost Estimator',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'AI-powered estimate — works fully offline',
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
                controller: _landAreaController,
                label: 'Land Area',
                hint: 'e.g. 4.0',
                icon: Icons.square_foot,
                suffixText: 'katha',
                validator: (v) => _validate(v, min: 0.5, max: 50),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: FeatureInputField(
                      controller: _floorsController,
                      label: 'No. of Floors',
                      hint: '4',
                      icon: Icons.layers_outlined,
                      validator: (v) => _validate(v, min: 1, max: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FeatureInputField(
                      controller: _roomsController,
                      label: 'Rooms / Floor',
                      hint: '3',
                      icon: Icons.bed,
                      validator: (v) => _validate(v, min: 1, max: 15),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: FeatureInputField(
                      controller: _bathroomsController,
                      label: 'Bathrooms / Floor',
                      hint: '2',
                      icon: Icons.bathtub_outlined,
                      validator: (v) => _validate(v, min: 1, max: 10),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FeatureInputField(
                      controller: _distanceController,
                      label: 'Dist. to Main Road',
                      hint: '1.5',
                      icon: Icons.location_on_outlined,
                      suffixText: 'km',
                      validator: (v) => _validate(v, min: 0, max: 50),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: _selectedLocation,
                decoration: InputDecoration(
                  labelText: 'Location',
                  prefixIcon: Icon(Icons.map_outlined, color: theme.colorScheme.secondary),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: theme.colorScheme.secondary, width: 2),
                  ),
                ),
                items: kCostLocations
                    .map((loc) => DropdownMenuItem(value: loc, child: Text(loc)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _selectedLocation = v);
                },
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: _selectedQuality,
                decoration: InputDecoration(
                  labelText: 'Construction Quality',
                  prefixIcon: Icon(Icons.star_border_rounded, color: theme.colorScheme.secondary),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: theme.colorScheme.secondary, width: 2),
                  ),
                ),
                items: kConstructionQualities
                    .map((q) => DropdownMenuItem(value: q, child: Text(q)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _selectedQuality = v);
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
              Row(
                children: [
                  Expanded(
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Generator', style: TextStyle(fontSize: 14)),
                      value: _hasGenerator,
                      onChanged: (v) => setState(() => _hasGenerator = v),
                    ),
                  ),
                  Expanded(
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Rooftop Garden', style: TextStyle(fontSize: 13)),
                      value: _hasRooftopGarden,
                      onChanged: (v) => setState(() => _hasRooftopGarden = v),
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
                      : const Icon(Icons.calculate_outlined),
                  label: Text(_isPredicting ? 'Calculating...' : 'Estimate Cost'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                    foregroundColor: theme.colorScheme.onSecondary,
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
