import 'package:hive_flutter/hive_flutter.dart';
import '../features/prices/price_model.dart';

class LocalStorageService {
  static const String _pricesBox = 'prices';

  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(PriceModelAdapter());
    }
    await Hive.openBox<PriceModel>(_pricesBox);
  }

  static Box<PriceModel> get pricesBox => Hive.box<PriceModel>(_pricesBox);
}
