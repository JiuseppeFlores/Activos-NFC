import 'package:activos_nfc_app/common/utils/utils.dart';
import 'package:activos_nfc_app/core/models/models.dart';
import 'package:activos_nfc_app/core/repositories/session_repository.dart';
import 'package:activos_nfc_app/core/services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;
  final SessionRepository _sessionRepository;

  AuthRepository(this._authService, this._sessionRepository);

  Future<ApiResponse> login(String username, String password) async {
    try {
      final response = await _authService.login(username, password);
      final data = response.data;

      if (data != null && data['estado'] == true) {
        final authResponse = AuthResponse.fromJson(data['datos'] ?? {});
        
        // Persistir sesión
        final session = Session(
          id: authResponse.user.id,
          username: username,
          password: password,
          token: authResponse.token,
        );
        await _sessionRepository.saveSession(session);

        return ApiResponse(
          data: authResponse,
          statusCode: data['codigo'],
        );
      } else {
        return ApiResponse(
          error: data?['error'] ?? 'Error en la autenticación',
          statusCode: data?['codigo'],
        );
      }
    } catch (e) {
      return RequestCodeManager.getResponseError(e);
    }
  }

  Future<Session> getSavedSession() async {
    return await _sessionRepository.getSession();
  }

  Future<void> clearSession() async {
    await _sessionRepository.clearSession();
  }
}
