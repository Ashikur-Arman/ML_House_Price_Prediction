import 'package:flutter/material.dart';
import '../models/house_features.dart';
import '../models/prediction_result.dart';
import '../services/knn_predictor_service.dart';
import '../widgets/feature_input_field.dart';
import '../widgets/prediction_result_card.dart';
import '../widgets/algorithm_info_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _predictor = KnnPredictorService();

  final _areaController = TextEditingController();
  final _bedroomsController = TextEditingController();
  final _bathroomsController = TextEditingController();
  final _ageController = TextEditingController();
  final _distanceController = TextEditingController();

  bool _isModelLoading = true;
  bool _isPredicting = false;
  PredictionResult? _result;
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
              const SizedBox(height: 24),
              _buildForm(theme),
              const SizedBox(height: 20),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                ),
              if (_result != null) ...[
                PredictionResultCard(result: _result!),
                const SizedBox(height: 16),
                const AlgorithmInfoCard(),
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
          colors: [theme.colorScheme.primary, theme.colorScheme.primaryContainer],
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
            child: const Icon(Icons.house_rounded, size: 44, color: Colors.white),
          ),
          const SizedBox(height: 12),
          const Text(
            'House Price Predictor',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
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
              Row(
                children: [
                  Icon(Icons.edit_note, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  const Text(
                    'Enter House Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 16),
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
                      : const Icon(Icons.auto_awesome),
                  label: Text(_isPredicting ? 'Calculating...' : 'Predict Price'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}