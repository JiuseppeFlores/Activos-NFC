import 'package:activos_nfc_app/common/data/data.dart';
import 'package:activos_nfc_app/core/models/models.dart';
import 'package:dio/dio.dart';

class RequestCodeManager {
  static ApiResponse getResponseError(dynamic e) {
    String message = DefaultData.string;
    int? statusCode;
    String? code;
    if (e is DioException) {
      if (e.response != null) {
        statusCode = e.response!.statusCode!;
        if (statusCode == 400) {
          code = e.response?.data['code'];
          if (code != null) {
            message = getCodeBadRequestException(code);
          } else {
            message = 'Datos no válidos';
          }
        } else if (statusCode == 401) {
          code = e.response?.data['code'];
          if (code != null) {
            message = getCodeUnauthorizedException(code);
          } else {
            message = 'Acceso no autorizado';
          }
        } else if (statusCode == 404) {
          code = e.response?.data['code'];
          if (code != null) {
            message = getCodeNotFoundException(code);
          } else {
            message = 'Acceso no autorizado';
          }
        } else if (statusCode == 500) {
          message = 'Error en el servidor';
        } else {
          message = 'Error no identificado';
        }
      } else {
        message = 'No se pudo conectar con el servidor';
      }
    } else {
      message = 'Error desconocido';
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