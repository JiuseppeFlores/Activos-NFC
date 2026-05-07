import 'package:activos_nfc_app/common/utils/utils.dart';
import 'package:activos_nfc_app/core/clients/clients.dart';
import 'package:activos_nfc_app/core/models/models.dart';

class AssetRepository {
  final AssetClient _assetClient;

  AssetRepository(this._assetClient);

  Future<ApiResponse> getAssetById(int id) async {
    try {
      final response = await _assetClient.get('/obtener.php', queryParameters: {'id': id});
      final data = response.data;
      if (data != null && data['estado'] == true) {
        return ApiResponse(data: Asset.fromJson(data['datos']));
      } else {
        return ApiResponse(error: data?['error'] ?? 'Error al obtener activo');
      }
    } catch (e) {
      return RequestCodeManager.getResponseError(e);
    }
  }

  Future<ApiResponse> assignNfcTag(int id, String nfcTag) async {
    try {
      final response = await _assetClient.post(
        '/asignar_nfc.php', 
        body: {
          'idActivo': id,
          'uidTag': nfcTag,
        }
      );
      final data = response.data;
      if (data != null && data['estado'] == true) {
        return ApiResponse(data: data['datos']);
      } else {
        return ApiResponse(error: data?['error'] ?? 'Error al asignar NFC');
      }
    } catch (e) {
      return RequestCodeManager.getResponseError(e);
    }
  }
}
