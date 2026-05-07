import 'package:activos_nfc_app/common/utils/utils.dart';
import 'package:activos_nfc_app/core/clients/clients.dart';
import 'package:activos_nfc_app/core/models/models.dart';

class AuthRepository {
  final AuthClient _authClient;

  AuthRepository(this._authClient);

  Future<ApiResponse> login(String username, String password) async {
    try {
      const path = '/iniciar.php';
      final response = await _authClient.postWithoutJwt(
        path,
        body: {'usuario': username, 'password': password},
      );
      
      final data = response.data;
      if (data != null && data['estado'] == true) {
        return ApiResponse(
          data: AuthResponse.fromJson(data['datos'] ?? {}),
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
}
