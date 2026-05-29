import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../dashboard/dashboard_screen.dart';
import '../prices/price_screen.dart';
import '../bullions/bullion_screen.dart';
import '../calculator/calculator_screen.dart';
import '../profile/profile_screen.dart';
import '../prices/price_provider.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  final int countryId;
  const MainNavigationScreen({super.key, this.countryId = 1});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // مراقبة الدولة النشطة وتحديث جميع الشاشات لحظياً عند تغييرها من الملف الشخصي!
    final activeCountryId = ref.watch(selectedCountryIdProvider);

    final List<Widget> screens = [
      DashboardScreen(countryId: activeCountryId),
      PriceScreen(countryId: activeCountryId),
      BullionScreen(countryId: activeCountryId),
      const CalculatorScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart_outlined),
            activeIcon: Icon(Icons.show_chart),
            label: 'السوق',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'استكشف',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate_outlined),
            activeIcon: Icon(Icons.calculate),
            label: 'الأدوات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }
}
