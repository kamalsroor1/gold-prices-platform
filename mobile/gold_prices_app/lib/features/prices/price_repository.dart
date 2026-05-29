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
    
    // Check if the response is a Map (error message or single object)
    if (data is Map<String, dynamic>) {
      // If it contains a 'data' key, handle it based on its content
      if (data.containsKey('data')) {
        final dynamic nestedData = data['data'];
        
        // If 'data' is a List
        if (nestedData is List) {
          return (nestedData).map((e) => PriceModel.fromJson(e as Map<String, dynamic>)).toList();
        }
        
        // If 'data' is a single object (which seems to be the case based on logs)
        if (nestedData is Map<String, dynamic>) {
          return [PriceModel.fromJson(nestedData)];
        }
      }
      
      // If it's a direct price object
      if (data.containsKey('karat') && data.containsKey('price')) {
        return [PriceModel.fromJson(data)];
      }
      return [];
    }
    
    // Check if the response is a List
    if (data is List) {
      return data.map((e) => PriceModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    
    return [];
  }
}
