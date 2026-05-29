import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'local_storage_service.dart';

// مساعد جلب رمز العملة باللغة العربية بناءً على الدولة
String getCurrencySymbol(int countryId) {
  switch (countryId) {
    case 1: return 'ج.م';
    case 2: return 'ر.س';
    case 3: return 'د.إ';
    case 4: return 'د.ك';
    default: return '\$';
  }
}

class ApiClient {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://127.0.0.1:8000/api/v1/',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Accept': 'application/json'},
  ));

  String? _token;

  ApiClient() {
    // تحميل التوكين تلقائياً من الذاكرة المحلية المستمرة عند الإقلاع لمنع تسجيل الخروج عند التحديث
    _token = LocalStorageService.token;
  }

  void setToken(String token) {
    _token = token;
    LocalStorageService.saveToken(token); // حفظ التوكين محلياً
  }

  void clearToken() {
    _token = null;
    LocalStorageService.clearToken(); // مسح التوكين محلياً
  }

  Future<dynamic> get(String path, {bool authenticated = false}) async {
    try {
      final options = authenticated ? Options(headers: {'Authorization': 'Bearer $_token'}) : null;
      final response = await _dio.get(path, options: options);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> post(String path, dynamic data, {bool authenticated = false}) async {
    try {
      final options = authenticated ? Options(headers: {'Authorization': 'Bearer $_token'}) : null;
      final response = await _dio.post(path, data: data, options: options);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> delete(String path, {bool authenticated = false}) async {
    try {
      final options = authenticated ? Options(headers: {'Authorization': 'Bearer $_token'}) : null;
      final response = await _dio.delete(path, options: options);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return Exception('No internet connection');
    }
    return Exception('Something went wrong: ${e.message}');
  }
}

final apiClientProvider = Provider((ref) => ApiClient());
