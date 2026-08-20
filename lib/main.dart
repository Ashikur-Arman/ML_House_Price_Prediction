import 'package:flutter/material.dart';
import 'package:house_price_app/widgets/prediction_screen.dart';

import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const HousePriceApp(),
  );
}

class HousePriceApp
    extends StatelessWidget {
  const HousePriceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart House Predictor',
      theme: AppTheme.lightTheme,
      home:
      const PredictionScreen(),
    );
  }
}