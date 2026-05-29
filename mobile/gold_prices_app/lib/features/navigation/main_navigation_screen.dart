import 'package:flutter/material.dart';
import '../prices/price_screen.dart';
import '../bullions/bullion_screen.dart';
import '../calculator/calculator_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int countryId;
  const MainNavigationScreen({super.key, this.countryId = 1});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      PriceScreen(countryId: widget.countryId),
      BullionScreen(countryId: widget.countryId),
      const CalculatorScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'الأسعار',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'السبائك والعملات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'الحاسبة الذكية',
          ),
        ],
      ),
    );
  }
}
