import 'package:hive_flutter/hive_flutter.dart';
import '../features/prices/price_model.dart';

class LocalStorageService {
  static const String _pricesBox = 'prices';
  static const String _authBox = 'auth';

  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(PriceModelAdapter());
    }
    await Hive.openBox<PriceModel>(_pricesBox);
    await Hive.openBox(_authBox);
  }

  static Box<PriceModel> get pricesBox => Hive.box<PriceModel>(_pricesBox);
  
  static Box get authBox => Hive.box(_authBox);

  // جلب وحفظ توكين المصادقة برمجياً ومحلياً
  static String? get token => authBox.get('token') as String?;

  static Future<void> saveToken(String token) async {
    await authBox.put('token', token);
  }

  static Future<void> clearToken() async {
    await authBox.delete('token');
  }
}
