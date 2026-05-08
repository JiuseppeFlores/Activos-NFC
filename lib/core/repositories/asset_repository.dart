import 'package:activos_nfc_app/common/utils/utils.dart';
import 'package:activos_nfc_app/core/models/models.dart';
import 'package:activos_nfc_app/core/services/asset_service.dart';

class AssetRepository {
  final AssetService _assetService;

  AssetRepository(this._assetService);

  Future<ApiResponse> getAssetById(int id) async {
    try {
      final response = await _assetService.getAssetById(id);
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

  Future<ApiResponse> getAssetByBarcode(String barcode) async {
    try {
      final response = await _assetService.getAssetByBarcode(barcode);
      final data = response.data;
      if (data != null && data['estado'] == true) {
        return ApiResponse(data: Asset.fromJson(data['datos']));
      } else {
        return ApiResponse(error: data?['error'] ?? 'Activo no encontrado');
      }
    } catch (e) {
      return RequestCodeManager.getResponseError(e);
    }
  }

  Future<ApiResponse> getAssetByNfcUid(String uid) async {
    try {
      final response = await _assetService.getAssetByNfcUid(uid);
      final data = response.data;
      if (data != null && data['estado'] == true) {
        return ApiResponse(data: Asset.fromJson(data['datos']));
      } else {
        return ApiResponse(error: data?['error'] ?? 'Activo no encontrado');
      }
    } catch (e) {
      return RequestCodeManager.getResponseError(e);
    }
  }

  Future<ApiResponse> assignNfcTag(int id, String nfcTag) async {
    try {
      final response = await _assetService.assignNfcTag(id, nfcTag);
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
