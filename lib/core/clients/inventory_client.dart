import 'package:activos_nfc_app/core/dio/dio_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class InventoryClient extends DioClient {
  InventoryClient()
    : super(
        baseUrl: '${dotenv.env['URL_SERVER']}/inventario',
        isAuthenticatorRequired: false,
      );
}