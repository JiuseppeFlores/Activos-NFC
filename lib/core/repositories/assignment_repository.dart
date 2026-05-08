import 'package:activos_nfc_app/common/utils/utils.dart';
import 'package:activos_nfc_app/core/models/models.dart';
import 'package:activos_nfc_app/core/services/assignment_service.dart';

class AssignmentRepository {
  final AssignmentService _assignmentService;

  AssignmentRepository(this._assignmentService);

  Future<ApiResponse> getAssignedAssets(String ci) async {
    try {
      final response = await _assignmentService.getAssignedAssets(ci);
      final data = response.data;
      if (data != null && data['estado'] == true) {
        final List<dynamic> list = data['datos'] ?? [];
        return ApiResponse(data: list.map((e) => Asset.fromJson(e)).toList());
      } else {
        return ApiResponse(error: data?['error'] ?? 'No se encontraron asignaciones');
      }
    } catch (e) {
      return RequestCodeManager.getResponseError(e);
    }
  }
}
