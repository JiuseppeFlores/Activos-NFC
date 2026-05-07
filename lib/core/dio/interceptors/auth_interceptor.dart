import 'package:activos_nfc_app/core/repositories/session_repository.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final SessionRepository _sessionRepository;

  AuthInterceptor({SessionRepository? sessionRepository})
      : _sessionRepository = sessionRepository ?? SessionRepository();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Si la petición requiere autenticación Bearer (por defecto o configurado en extra)
    final bool requiresToken = options.extra['requiresToken'] ?? true;

    if (requiresToken) {
      final token = await _sessionRepository.getToken();
      
      if (token != null && token.isNotEmpty && token != 'none') {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    
    return handler.next(options);
  }
}
