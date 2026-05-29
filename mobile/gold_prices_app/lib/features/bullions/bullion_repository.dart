import '../../core/api_client.dart';
import 'bullion_model.dart';

class BullionRepository {
  final ApiClient _apiClient;

  BullionRepository(this._apiClient);

  Future<List<BullionModel>> getBullions(int countryId) async {
    final data = await _apiClient.get('bullions?country_id=$countryId');
    return (data as List).map((e) => BullionModel.fromJson(e)).toList();
  }
}
