import 'package:activos_nfc_app/blocs/asset/asset_state.dart';
import 'package:activos_nfc_app/common/enums/enums.dart';
import 'package:activos_nfc_app/core/repositories/asset_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssetCubit extends Cubit<AssetState> {
  final AssetRepository _assetRepository;

  AssetCubit({required AssetRepository assetRepository})
      : _assetRepository = assetRepository,
        super(const AssetState());

  void resetStatus() {
    emit(state.copyWith(status: AssetStatus.initial));
  }

  Future<void> loadAssetById(int id) async {
    emit(state.copyWith(status: AssetStatus.loading));
    final response = await _assetRepository.getAssetById(id);

    if (response.isSuccessful) {
      emit(state.copyWith(
        status: AssetStatus.success,
        asset: response.data,
      ));
    } else {
      emit(state.copyWith(
        status: AssetStatus.error,
        errorMessage: response.error,
      ));
    }
  }

  Future<void> loadAsset(String code, ScanType type) async {
    emit(state.copyWith(status: AssetStatus.loading));

    final response = type == ScanType.barcode 
      ? await _assetRepository.getAssetByBarcode(code)
      : await _assetRepository.getAssetByNfcUid(code);

    if (response.isSuccessful) {
      emit(state.copyWith(
        status: AssetStatus.success,
        asset: response.data,
      ));
    } else {
      emit(state.copyWith(
        status: AssetStatus.error,
        errorMessage: response.error,
      ));
    }
  }

  Future<void> updateNfcTag(int id, String nfcTag) async {
    emit(state.copyWith(status: AssetStatus.updating));

    final response = await _assetRepository.assignNfcTag(id, nfcTag);

    if (response.isSuccessful) {
      final detailResponse = await _assetRepository.getAssetById(id);
      if (detailResponse.isSuccessful) {
        emit(state.copyWith(
          status: AssetStatus.updateSuccess,
          asset: detailResponse.data,
        ));
      } else {
        emit(state.copyWith(
          status: AssetStatus.updateSuccess,
        ));
      }
    } else {
      emit(state.copyWith(
        status: AssetStatus.updateError,
        errorMessage: response.error,
      ));
    }
  }
}
