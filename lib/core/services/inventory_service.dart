
import 'dart:convert';

import 'package:activos_nfc_app/common/utils/utils.dart';
import 'package:activos_nfc_app/core/clients/clients.dart';
import 'package:activos_nfc_app/core/models/models.dart';

class InventoryService {

  final InventoryClient _inventoryClient;

  InventoryService(this._inventoryClient);

  Future<ApiResponse> registerInventory(int assignmentId, int userId, String observation) async {
    try {
      const path = '/create.php';
      final response = await _inventoryClient.postWithoutJwt(
        path,
        body: {
          'idAsignacion': assignmentId, 
          'idUsuarioCreador': userId,
          'observacion': observation,
        },
      );
      Map<String, dynamic> data = json.decode(response.data);
      if(data['status'] == 1){
        return ApiResponse(data: data['message']);
      }else{
        return ApiResponse(error: data['message']);
      }
    } catch (e) {
      return RequestCodeManager.getResponseError(e);
    }
  }
  
}