import 'package:activos_nfc_app/blocs/assigned_assets/assigned_assets_state.dart';
import 'package:activos_nfc_app/core/repositories/assignment_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssignedAssetsCubit extends Cubit<AssignedAssetsState> {
  final AssignmentRepository _assignmentRepository;

  AssignedAssetsCubit({required AssignmentRepository assignmentRepository})
      : _assignmentRepository = assignmentRepository,
        super(const AssignedAssetsState());

  Future<void> loadAssignedAssets(String ci) async {
    emit(state.copyWith(status: AssignedAssetsStatus.loading));

    final response = await _assignmentRepository.getAssignedAssets(ci);

    if (response.isSuccessful) {
      emit(state.copyWith(
        status: AssignedAssetsStatus.success,
        assets: response.data,
      ));
    } else {
      emit(state.copyWith(
        status: AssignedAssetsStatus.error,
        errorMessage: response.error,
      ));
    }
  }
}
