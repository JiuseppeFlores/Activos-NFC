import 'package:activos_nfc_app/core/clients/clients.dart';
import 'package:dio/dio.dart';

class AuthService {
  final AuthClient _authClient;

  AuthService(this._authClient);

  Future<Response> login(String username, String password) async {
    return await _authClient.postWithoutJwt(
      '/iniciar.php',
      body: {'usuario': username, 'password': password},
    );
  }
}
