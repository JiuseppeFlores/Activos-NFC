import 'package:activos_nfc_app/core/clients/clients.dart';
import 'package:dio/dio.dart';

class InventoryService {
  final InventoryClient _inventoryClient;

  InventoryService(this._inventoryClient);

  Future<Response> registerInventory({
    required int idActivo,
    required int idUsuario,
    required String observacion,
  }) async {
    return await _inventoryClient.post(
      '/registrar.php', 
      body: {
        'idActivo': idActivo,
        'idUsuario': idUsuario,
        'observacion': observacion,
      }
    );
  }
}
