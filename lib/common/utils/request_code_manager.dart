import 'package:activos_nfc_app/common/data/data.dart';
import 'package:activos_nfc_app/core/models/models.dart';
import 'package:dio/dio.dart';

class RequestCodeManager {
  static ApiResponse getResponseError(dynamic e) {
    String message = 'Error desconocido';
    int? statusCode;
    String? code;

    if (e is DioException) {
      if (e.response != null) {
        statusCode = e.response!.statusCode;
        final dynamic responseData = e.response?.data;

        // 1. Intentar extraer el mensaje de error del cuerpo de la respuesta (formato estándar PHP del proyecto)
        if (responseData is Map && responseData['error'] != null && responseData['error'].toString().isNotEmpty) {
          message = responseData['error'].toString();
          code = responseData['codigo']?.toString();
          return ApiResponse(error: message, statusCode: statusCode, code: code);
        }

        // 2. Fallback a lógica basada en código de estado si no hay mensaje en el cuerpo
        if (statusCode == 400) {
          message = 'Datos no válidos';
        } else if (statusCode == 401) {
          message = 'Acceso no autorizado o token inválido';
        } else if (statusCode == 404) {
          message = 'Recurso no encontrado';
        } else if (statusCode == 409) {
          message = 'Conflicto en la solicitud';
        } else if (statusCode == 500) {
          message = 'Error interno del servidor';
        } else {
          message = 'Error inesperado (Código: $statusCode)';
        }
      } else {
        message = 'No se pudo conectar con el servidor. Verifique su conexión.';
      }
    }
    
    return ApiResponse(error: message, statusCode: statusCode, code: code);
  }

  static getCodeUnauthorizedException(String code) {
    String message = DefaultData.string;
    return message;
  }

  static getCodeNotFoundException(String code) {
    String message = DefaultData.string;
    return message;
  }

  static getCodeBadRequestException(String code) {
    String message = DefaultData.string;
    return message;
  }
}