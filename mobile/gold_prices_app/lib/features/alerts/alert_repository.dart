import '../../core/api_client.dart';
import 'alert_model.dart';

class AlertRepository {
  final ApiClient _apiClient;

  AlertRepository(this._apiClient);

  Future<List<AlertModel>> getAlerts() async {
    final List<dynamic> data = await _apiClient.get('alerts', authenticated: true);
    return data.map((e) => AlertModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> createAlert(int countryId, int karat, double targetPrice) async {
    await _apiClient.post('alerts', {
      'country_id': countryId,
      'karat': karat,
      'target_price': targetPrice,
    }, authenticated: true);
  }

  Future<void> deleteAlert(int id) async {
    await _apiClient.delete('alerts/$id', authenticated: true);
  }
}
