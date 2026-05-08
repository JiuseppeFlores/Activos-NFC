import 'package:activos_nfc_app/core/clients/clients.dart';
import 'package:dio/dio.dart';

class AssetService {
  final AssetClient _assetClient;

  AssetService(this._assetClient);

  Future<Response> getAssetById(int id) async {
    return await _assetClient.get('/obtener.php', queryParameters: {'id': id});
  }

  Future<Response> getAssetByBarcode(String barcode) async {
    return await _assetClient.get('/buscar.php', queryParameters: {'codigoBarras': barcode});
  }

  Future<Response> getAssetByNfcUid(String uid) async {
    return await _assetClient.get('/buscar.php', queryParameters: {'uidTag': uid});
  }

  Future<Response> assignNfcTag(int id, String nfcTag) async {
    return await _assetClient.post(
      '/asignar_nfc.php', 
      body: {
        'idActivo': id,
        'uidTag': nfcTag,
      }
    );
  }
}
