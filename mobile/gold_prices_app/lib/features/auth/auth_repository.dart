import '../../core/api_client.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<void> logout() async {
    await _apiClient.post('logout', {}, authenticated: true);
  }
}
