import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api_client.dart';
import 'alert_model.dart';
import 'alert_repository.dart';

// Provider for AlertRepository
final alertRepositoryProvider = Provider<AlertRepository>((ref) {
  return AlertRepository(ref.read(apiClientProvider));
});

// StateNotifier for managing alerts list state
class AlertNotifier extends StateNotifier<AsyncValue<List<AlertModel>>> {
  final AlertRepository _repository;

  AlertNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> fetchAlerts() async {
    state = const AsyncValue.loading();
    try {
      final alerts = await _repository.getAlerts();
      state = AsyncValue.data(alerts);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addAlert(int countryId, int karat, double targetPrice) async {
    try {
      await _repository.createAlert(countryId, karat, targetPrice);
      await fetchAlerts(); // إعادة جلب التنبيهات بعد الإضافة
    } catch (e) {
      // التعامل مع الخطأ
    }
  }

  Future<void> removeAlert(int id) async {
    try {
      await _repository.deleteAlert(id);
      await fetchAlerts(); // إعادة جلب التنبيهات بعد الحذف
    } catch (e) {
      // التعامل مع الخطأ
    }
  }
}

// Provider for AlertNotifier
final alertProvider = StateNotifierProvider<AlertNotifier, AsyncValue<List<AlertModel>>>((ref) {
  final repository = ref.read(alertRepositoryProvider);
  return AlertNotifier(repository)..fetchAlerts();
});
