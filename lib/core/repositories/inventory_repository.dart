import 'package:activos_nfc_app/common/utils/utils.dart';
import 'package:activos_nfc_app/core/models/models.dart';
import 'package:activos_nfc_app/core/services/inventory_service.dart';

class InventoryRepository {
  final InventoryService _inventoryService;

  InventoryRepository(this._inventoryService);

  Future<ApiResponse> registerInventory({
    required int idActivo,
    required int idUsuario,
    required String observacion,
  }) async {
    try {
      final response = await _inventoryService.registerInventory(
        idActivo: idActivo,
        idUsuario: idUsuario,
        observacion: observacion,
      );
      final data = response.data;
      if (data != null && data['estado'] == true) {
        return ApiResponse(data: data['datos']);
      } else {
        return ApiResponse(error: data?['error'] ?? 'Error al registrar inventario');
      }
    } catch (e) {
      return RequestCodeManager.getResponseError(e);
    }
  }
}
