import 'package:activos_nfc_app/core/dio/dio_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthClient extends DioClient {
  AuthClient()
    : super(
        baseUrl: '${dotenv.env['URL_SERVER']}/api/v1/sesion',
        isAuthenticatorRequired: false,
      );
}
