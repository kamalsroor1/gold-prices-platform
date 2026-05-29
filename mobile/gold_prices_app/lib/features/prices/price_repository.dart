import '../../core/api_client.dart';
import 'price_model.dart';

class PriceRepository {
  final ApiClient _apiClient;

  PriceRepository(this._apiClient);

  Future<List<PriceModel>> getLatestPrices(int countryId) async {
    print('Fetching prices for countryId: $countryId'); // Debug log
    final dynamic data = await _apiClient.get('prices/latest?country_id=$countryId');
    print('API Response type: ${data.runtimeType}'); // Debug log
    print('API Response: $data'); // Debug log
    
    if (data is Map) {
      final safeData = Map<String, dynamic>.from(data);
      if (safeData.containsKey('data')) {
        final dynamic nestedData = safeData['data'];
        
        if (nestedData is List) {
          return nestedData.map((e) => PriceModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
        }
        
        if (nestedData is Map) {
          return [PriceModel.fromJson(Map<String, dynamic>.from(nestedData))];
        }
      }
      
      if (safeData.containsKey('karat') && safeData.containsKey('price')) {
        return [PriceModel.fromJson(safeData)];
      }
      return [];
    }
    
    if (data is List) {
      return data.map((e) => PriceModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    }
    
    return [];
  }
}
