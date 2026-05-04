import 'package:activos_nfc_app/core/dio/dio_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginClient extends DioClient {
  LoginClient()
    : super(
        baseUrl: '${dotenv.env['URL_SERVER']}/login',
        isAuthenticatorRequired: false,
      );
}