import 'package:activos_empresa_app/core/dio/dio_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductClient extends DioClient {
  ProductClient()
    : super(
        baseUrl: '${dotenv.env['URL_SERVER']}/producto',
        isAuthenticatorRequired: false,
      );
}