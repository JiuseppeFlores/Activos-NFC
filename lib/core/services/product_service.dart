
import 'dart:convert';

import 'package:activos_nfc_app/common/enums/enums.dart';
import 'package:activos_nfc_app/common/utils/utils.dart';
import 'package:activos_nfc_app/core/clients/clients.dart';
import 'package:activos_nfc_app/core/models/models.dart';

class ProductService {

  final ProductClient _productClient;

  ProductService(this._productClient);
  
  Future<ApiResponse> getProductByBarcode(String barcode) async {
    try {
      final path = '/get_bien.php?codigoBarras=$barcode';
      final response = await _productClient.get(
        path,
        ApiAuthType.bearer,
      );
      Map<String, dynamic> data = json.decode(response.data);
      if(data['status'] == 1){
        final user = User.fromJson(data['data']);
        final product = Product.fromJson(data['data']);
        return ApiResponse(data: {
          'user': user,
          'product': product,
        });
      }else{
        return ApiResponse(error: data['message']);
      }
    } catch (e) {
      return RequestCodeManager.getResponseError(e);
    }
  }

  Future<ApiResponse> getProductByUIDTag(String uidTag) async {
    try {
      final path = '/get_bien.php?uidTag=$uidTag';
      final response = await _productClient.get(
        path,
        ApiAuthType.bearer,
      );
      Map<String, dynamic> data = json.decode(response.data);
      if(data['status'] == 1){
        final user = User.fromJson(data['data']);
        final product = Product.fromJson(data['data']);
        return ApiResponse(data: {
          'user': user,
          'product': product,
        });
      }else{
        return ApiResponse(error: data['message']);
      }
    } catch (e) {
      return RequestCodeManager.getResponseError(e);
    }
  }

}