import 'package:activos_empresa_app/core/dio/dio_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserClient extends DioClient {
  UserClient()
    : super(
        baseUrl: '${dotenv.env['URL_SERVER']}/usuario',
        isAuthenticatorRequired: false,
      );
}