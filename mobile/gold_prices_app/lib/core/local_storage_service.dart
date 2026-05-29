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

  // جلب وحفظ توكين المصادقة
  static String? get token => authBox.get('token') as String?;

  static Future<void> saveToken(String token) async {
    await authBox.put('token', token);
  }

  static Future<void> clearToken() async {
    await authBox.delete('token');
  }

  // جلب وحفظ الدولة النشطة المحددة من المستخدم
  static int get countryId => authBox.get('countryId') as int? ?? 1;

  static Future<void> saveCountryId(int id) async {
    await authBox.put('countryId', id);
  }

  // حفظ وحفظ وضعية المفاتيح والتنبيهات
  static bool get priceAlertsEnabled => authBox.get('priceAlertsEnabled') as bool? ?? true;
  static Future<void> savePriceAlerts(bool value) async => await authBox.put('priceAlertsEnabled', value);

  static bool get periodicAlertsEnabled => authBox.get('periodicAlertsEnabled') as bool? ?? true;
  static Future<void> savePeriodicAlerts(bool value) async => await authBox.put('periodicAlertsEnabled', value);

  static bool get dailySummaryEnabled => authBox.get('dailySummaryEnabled') as bool? ?? true;
  static Future<void> saveDailySummary(bool value) async => await authBox.put('dailySummaryEnabled', value);

  static String get appLanguage => authBox.get('appLanguage') as String? ?? 'العربية';
  static Future<void> saveAppLanguage(String value) async => await authBox.put('appLanguage', value);
}
