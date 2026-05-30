import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'local_storage_service.dart';

// استثناء مخصص لعدم المصادقة أو التوكينات غير الصالحة
class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
  @override
  String toString() => message;
}

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

// مساعد تنسيق الأرقام الكبيرة بوضع فاصلة الآلاف (مثل 12,451)
String formatPrice(double price) {
  String priceStr = price.toStringAsFixed(2);
  List<String> parts = priceStr.split('.');
  RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  String formattedInt = parts[0].replaceAllMapped(reg, (Match m) => '${m[1]},');
  
  if (parts[1] == '00') {
    return formattedInt;
  }
  return '$formattedInt.${parts[1]}';
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
    // التقاط خطأ عدم المصادقة 401 أو التوكين غير الصالح لفرض تسجيل خروج تلقائي آمن
    if (e.response?.statusCode == 401) {
      final dynamic data = e.response?.data;
      if (data is Map && (data.containsKey('message') || data.containsKey('error'))) {
        final msg = data['message'] ?? data['error'] ?? 'Unauthorized';
        return UnauthorizedException(msg.toString());
      }
      return UnauthorizedException('Invalid token');
    }
    
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return Exception('No internet connection');
    }
    return Exception('Something went wrong: ${e.message}');
  }
}

final apiClientProvider = Provider((ref) => ApiClient());
