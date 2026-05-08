import 'package:activos_nfc_app/blocs/inventory/inventory_state.dart';
import 'package:activos_nfc_app/core/repositories/inventory_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InventoryCubit extends Cubit<InventoryState> {
  final InventoryRepository _inventoryRepository;

  InventoryCubit({required InventoryRepository inventoryRepository})
      : _inventoryRepository = inventoryRepository,
        super(const InventoryState());

  Future<void> registerInventory({
    required int idActivo,
    required int idUsuario,
    required String observacion,
  }) async {
    emit(state.copyWith(status: InventoryStatus.loading));

    final response = await _inventoryRepository.registerInventory(
      idActivo: idActivo,
      idUsuario: idUsuario,
      observacion: observacion,
    );

    if (response.isSuccessful) {
      emit(state.copyWith(status: InventoryStatus.success));
    } else {
      emit(state.copyWith(
        status: InventoryStatus.error,
        errorMessage: response.error,
      ));
    }
  }
}
