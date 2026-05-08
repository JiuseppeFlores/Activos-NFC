import 'package:activos_nfc_app/core/clients/clients.dart';
import 'package:dio/dio.dart';

class AssignmentService {
  final AssignmentClient _assignmentClient;

  AssignmentService(this._assignmentClient);

  Future<Response> getAssignedAssets(String ci) async {
    return await _assignmentClient.get('/buscar_por_usuario.php', queryParameters: {'ci': ci});
  }
}
