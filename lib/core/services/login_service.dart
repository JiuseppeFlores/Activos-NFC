
import 'dart:convert';

import 'package:activos_empresa_app/common/utils/utils.dart';
import 'package:activos_empresa_app/core/clients/clients.dart';
import 'package:activos_empresa_app/core/models/models.dart';

class LoginService {

  final LoginClient _loginClient;

  LoginService(this._loginClient);

  Future<ApiResponse> login(String username, String password) async {
    try {
      const path = '/login.php';
      final response = await _loginClient.postWithoutJwt(
        path,
        body: {'name': username, 'pwd': password},
      );
      Map<String, dynamic> data = json.decode(response.data);
      if(data['status'] == 1){
        return ApiResponse(data: data['idUsuario']);
      }else{
        return ApiResponse(error: data['message']);
      }
    } catch (e) {
      return RequestCodeManager.getResponseError(e);
    }
  }
  
}