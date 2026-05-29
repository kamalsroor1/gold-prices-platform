import '../../core/api_client.dart';
import 'bullion_model.dart';

class BullionRepository {
  final ApiClient _apiClient;

  BullionRepository(this._apiClient);

  Future<List<BullionModel>> getBullions(int countryId) async {
    final dynamic data = await _apiClient.get('bullions?country_id=$countryId');
    if (data is Map<String, dynamic> && data.containsKey('data')) {
        return (data['data'] as List).map((e) => BullionModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return (data as List).map((e) => BullionModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
