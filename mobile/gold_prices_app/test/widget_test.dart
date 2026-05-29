import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:gold_prices_app/main.dart';
import 'package:gold_prices_app/core/local_storage_service.dart';
import 'package:gold_prices_app/features/prices/price_provider.dart';
import 'package:gold_prices_app/features/prices/price_repository.dart';
import 'package:gold_prices_app/features/prices/price_model.dart';
import 'package:gold_prices_app/features/bullions/bullion_provider.dart';
import 'package:gold_prices_app/features/bullions/bullion_repository.dart';
import 'package:gold_prices_app/features/bullions/bullion_model.dart';

class FakePriceRepository extends Fake implements PriceRepository {
  @override
  Future<List<PriceModel>> getLatestPrices(int countryId) async {
    return [PriceModel(karat: '24', price: 3500.50)];
  }
}

class FakeBullionRepository extends Fake implements BullionRepository {
  @override
  Future<List<BullionModel>> getBullions(int countryId) async {
    return [];
  }
}

void main() {
  setUpAll(() async {
    // تهيئة Hive في مجلد مؤقت خاص بالاختبارات
    final tempDir = Directory.systemTemp.createTempSync();
    Hive.init(tempDir.path);
    
    // تسجيل المحولات وفتح الصناديق المطلوبة للاختبار
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(PriceModelAdapter());
    }
    await Hive.openBox<PriceModel>('prices');
    await Hive.openBox('auth');
  });

  testWidgets('GoldPricesApp smoke test', (WidgetTester tester) async {
    // Build our app wrapped in ProviderScope with fake overrides
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          priceRepositoryProvider.overrideWithValue(FakePriceRepository()),
          bullionRepositoryProvider.overrideWithValue(FakeBullionRepository()),
        ],
        child: const GoldPricesApp(),
      ),
    );

    // Expect to find the app built
    expect(find.byType(GoldPricesApp), findsOneWidget);

    // Pump for 3 seconds to let the splash screen timer finish and navigate
    await tester.pump(const Duration(seconds: 3));
    
    // Pump another frame to let transitions handle
    await tester.pump();
  });
}
