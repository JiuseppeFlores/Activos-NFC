
import 'dart:convert';

import 'package:activos_nfc_app/common/enums/enums.dart';
import 'package:activos_nfc_app/common/utils/utils.dart';
import 'package:activos_nfc_app/core/clients/clients.dart';
import 'package:activos_nfc_app/core/models/models.dart';

class UserService {

  final UserClient _userClient;

  UserService(this._userClient);
  
  Future<ApiResponse> getAssignments(String identityCard) async {
    try {
      final path = '/get_asignaciones.php?ci=$identityCard';
      final response = await _userClient.get(
        path,
        ApiAuthType.bearer,
      );
      Map<String, dynamic> data = json.decode(response.data);
      if(data['status'] == 1){
        final assets = Product.fromList(data['data']);
        return ApiResponse(data: assets);
      }else{
        return ApiResponse(error: data['message']);
      }
    } catch (e) {
      return RequestCodeManager.getResponseError(e);
    }
  }

}