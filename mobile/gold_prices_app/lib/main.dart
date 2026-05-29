import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/local_storage_service.dart';
import 'core/theme.dart';
import 'features/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Hive المحلي لتخزين البيانات
  await LocalStorageService.init();

  runApp(const ProviderScope(child: GoldPricesApp()));
}

class GoldPricesApp extends StatelessWidget {
  const GoldPricesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gold Prices',
      theme: AppTheme.amoledDarkTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
