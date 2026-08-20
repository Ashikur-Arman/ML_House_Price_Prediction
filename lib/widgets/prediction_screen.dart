import 'package:flutter/material.dart';


import '../models/house_features.dart';
import '../models/knn_prediction_result.dart';
import '../services/knn_predictor_service.dart';
import '../theme/app_theme.dart';
import '../widgets/feature_input_card.dart';
import '../widgets/info_card.dart';
import '../widgets/knn_analysis_card.dart';
import '../widgets/model_performance_card.dart';
import '../widgets/prediction_result_card.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({
    super.key,
  });

  @override
  State<PredictionScreen> createState() =>
      _PredictionScreenState();
}

class _PredictionScreenState
    extends State<PredictionScreen> {
  final KnnPredictorService _predictor =
  KnnPredictorService();

  final HouseFeatures _defaultFeatures =
  const HouseFeatures(
    areaSqft: 1800,
    bedrooms: 3,
    bathrooms: 2,
    ageYears: 5,
    distanceToCityKm: 4.5,
  );

  HouseFeatures? _lastInput;

  KnnPredictionResult? _prediction;

  bool _isLoadingModel = true;
  bool _isPredicting = false;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      setState(() {
        _isLoadingModel = true;
        _errorMessage = null;
      });

      await _predictor.loadData();

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingModel = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingModel = false;
        _errorMessage =
        'Unable to load the ML model.\n\n$e';
      });
    }
  }

  Future<void> _predict(
      HouseFeatures input,
      ) async {
    if (!_predictor.isLoaded) {
      return;
    }

    setState(() {
      _isPredicting = true;
      _errorMessage = null;
    });

    try {
      // Small async gap keeps the UI responsive
      // before doing the calculation.
      await Future<void>.delayed(
        const Duration(milliseconds: 150),
      );

      final result =
      _predictor.predictDetailed(
        input,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _lastInput = input;
        _prediction = result;
        _isPredicting = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isPredicting = false;
        _errorMessage =
        'Prediction failed.\n\n$e';
      });
    }
  }

  void _resetPrediction() {
    setState(() {
      _lastInput = null;
      _prediction = null;
      _errorMessage = null;
    });
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding:
              const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius:
                BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.home_work_outlined,
                color: Colors.white,
                size: 27,
              ),
            ),

            const SizedBox(width: 13),

            const Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'Smart House Predictor',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight:
                      FontWeight.w800,
                      color:
                      AppTheme.darkText,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'AI-powered property price estimation',
                    style: TextStyle(
                      fontSize: 12,
                      color:
                      AppTheme.greyText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        Row(
          children: [
            _buildBadge(
              Icons.bolt_outlined,
              'On-Device AI',
            ),
            const SizedBox(width: 8),
            _buildBadge(
              Icons.wifi_off_outlined,
              'No Internet',
            ),
            const SizedBox(width: 8),
            _buildBadge(
              Icons.psychology_outlined,
              'KNN',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBadge(
      IconData icon,
      String text,
      ) {
    return Flexible(
      child: Container(
        padding:
        const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color:
              AppTheme.primary,
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                text,
                overflow:
                TextOverflow.ellipsis,
                style:
                const TextStyle(
                  fontSize: 10,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.symmetric(
          vertical: 80,
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Container(
              padding:
              const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primary
                    .withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child:
              const CircularProgressIndicator(
                color:
                AppTheme.primary,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Preparing AI Model',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.w700,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Loading training data and scaler parameters...',
              textAlign:
              TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color:
                AppTheme.greyText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.symmetric(
          vertical: 50,
          horizontal: 20,
        ),
        child: Column(
          children: [
            Container(
              padding:
              const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.red
                    .withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 40,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Model Loading Failed',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              _errorMessage ??
                  'Unknown error',
              textAlign:
              TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                height: 1.5,
                color:
                AppTheme.greyText,
              ),
            ),

            const SizedBox(height: 18),

            ElevatedButton.icon(
              onPressed: _loadModel,
              icon: const Icon(
                Icons.refresh,
              ),
              label:
              const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyPrediction() {
    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 28,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(22),
        border: Border.all(
          color: AppTheme.border,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding:
            const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.primary
                  .withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.home_outlined,
              color: AppTheme.primary,
              size: 38,
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'Ready to estimate',
            style: TextStyle(
              fontSize: 17,
              fontWeight:
              FontWeight.w700,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Enter your property details above to get an AI-powered house price prediction.',
            textAlign:
            TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color:
              AppTheme.greyText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner() {
    if (_errorMessage == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin:
      const EdgeInsets.only(
        bottom: 16,
      ),
      padding:
      const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:
        Colors.red.withOpacity(
          0.07,
        ),
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color:
          Colors.red.withOpacity(
            0.15,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_outlined,
            color: Colors.red,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _errorMessage!,
              style:
              const TextStyle(
                fontSize: 12,
                height: 1.4,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoadingModel
            ? _buildLoadingState()
            : _errorMessage != null &&
            !_predictor.isLoaded
            ? _buildErrorState()
            : CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding:
                const EdgeInsets.fromLTRB(
                  18,
                  20,
                  18,
                  0,
                ),
                child:
                _buildHeader(),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding:
                const EdgeInsets.fromLTRB(
                  18,
                  22,
                  18,
                  0,
                ),
                child: InfoCard(),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding:
                const EdgeInsets.fromLTRB(
                  18,
                  18,
                  18,
                  0,
                ),
                child:
                FeatureInputCard(
                  initialValues:
                  _defaultFeatures,
                  onPredict:
                  _predict,
                  onReset:
                  _resetPrediction,
                  isLoading:
                  _isPredicting,
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding:
                const EdgeInsets.fromLTRB(
                  18,
                  18,
                  18,
                  0,
                ),
                child:
                _prediction ==
                    null ||
                    _lastInput ==
                        null
                    ? _buildEmptyPrediction()
                    : PredictionResultCard(
                  input:
                  _lastInput!,
                  result:
                  _prediction!,
                ),
              ),
            ),

            if (_prediction != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                  const EdgeInsets.fromLTRB(
                    18,
                    18,
                    18,
                    0,
                  ),
                  child:
                  KnnAnalysisCard(
                    result:
                    _prediction!,
                  ),
                ),
              ),

            if (_prediction != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                  const EdgeInsets.fromLTRB(
                    18,
                    18,
                    18,
                    0,
                  ),
                  child:
                  ModelPerformanceCard(
                    result:
                    _prediction!,
                    trainingDataCount:
                    _predictor
                        .trainingDataCount,
                  ),
                ),
              ),

            SliverToBoxAdapter(
              child: Padding(
                padding:
                const EdgeInsets.fromLTRB(
                  18,
                  25,
                  18,
                  30,
                ),
                child: _buildFooter(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.security_outlined,
              size: 15,
              color:
              AppTheme.greyText,
            ),
            const SizedBox(width: 6),
            Text(
              'Prediction runs locally on your device',
              style:
              const TextStyle(
                fontSize: 11,
                color:
                AppTheme.greyText,
              ),
            ),
          ],
        ),
      ],
    );
  }
}