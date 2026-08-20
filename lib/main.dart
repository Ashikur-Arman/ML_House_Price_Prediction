import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const HousePriceApp());
}

class HousePriceApp extends StatelessWidget {
  const HousePriceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'House Price Predictor',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}