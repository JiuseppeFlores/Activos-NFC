import 'package:activos_nfc_app/blocs/asset/asset_state.dart';
import 'package:activos_nfc_app/core/clients/clients.dart';
import 'package:activos_nfc_app/core/repositories/asset_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssetCubit extends Cubit<AssetState> {
  final AssetRepository _assetRepository;

  AssetCubit({
    AssetRepository? assetRepository,
  })  : _assetRepository = assetRepository ?? AssetRepository(AssetClient()),
        super(const AssetState());

  Future<void> loadAsset(int id) async {
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

  Future<void> assignNfcTag(String nfcTag) async {
    if (state.asset == null) return;
    
    emit(state.copyWith(status: AssetStatus.updating));
    
    final response = await _assetRepository.assignNfcTag(state.asset!.id, nfcTag);
    
    if (response.isSuccessful) {
      emit(state.copyWith(
        status: AssetStatus.updateSuccess,
        asset: state.asset!.copyWith(nfcTag: nfcTag),
      ));
    } else {
      emit(state.copyWith(
        status: AssetStatus.updateError,
        errorMessage: response.error,
      ));
    }
  }

  void resetStatus() {
    emit(state.copyWith(status: AssetStatus.success));
  }
}
