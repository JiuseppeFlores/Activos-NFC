import 'package:activos_nfc_app/common/utils/utils.dart';
import 'package:activos_nfc_app/core/clients/clients.dart';
import 'package:activos_nfc_app/core/models/models.dart';

class AuthService {
  final AuthClient _authClient;

  AuthService(this._authClient);

  Future<ApiResponse> login(String username, String password) async {
    try {
      const path = '/iniciar.php';
      final response = await _authClient.postWithoutJwt(
        path,
        body: {'usuario': username, 'password': password},
      );
      
      final data = response.data;
      // La API v1 devuelve un objeto con 'token' y 'usuario' en caso de éxito
      if (data != null && data['token'] != null) {
        return ApiResponse(data: AuthResponse.fromJson(data));
      } else {
        // En caso de error, el middleware o Respuesta::json devuelve el mensaje en 'message'
        return ApiResponse(error: data?['message'] ?? 'Error en la autenticación');
      }
    } catch (e) {
      return RequestCodeManager.getResponseError(e);
    }
  }
}
