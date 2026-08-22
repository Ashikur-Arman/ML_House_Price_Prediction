import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'cost_estimator_screen.dart';
import 'house_gbm_screen.dart';

/// Hosts all three on-device models side by side:
///  - Tab 1: House Price Predictor (existing KNN model — untouched)
///  - Tab 2: Construction Cost Estimator (existing GBM model — untouched)
///  - Tab 3: House Price Predictor · New Model (new Gradient Boosting
///    model, train_dhaka_price_gbm.ipynb) — same property-details input
///    as Tab 1, so the two house-price models can be compared directly.
///
/// Each tab keeps its own state (form inputs + last result) via
/// IndexedStack, so switching tabs never clears what the user entered.
class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 0;

  static const _screens = [
    HomeScreen(),
    CostEstimatorScreen(),
    HouseGbmScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.house_rounded),
            label: 'House Price',
          ),
          NavigationDestination(
            icon: Icon(Icons.engineering_rounded),
            label: 'Construction Cost',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_graph_rounded),
            label: 'New Price Model',
          ),
        ],
      ),
    );
  }
}
