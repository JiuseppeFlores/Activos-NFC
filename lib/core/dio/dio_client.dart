import 'dart:io';

import 'package:activos_nfc_app/common/data/data.dart';
import 'package:activos_nfc_app/common/enums/enums.dart';
import 'package:activos_nfc_app/common/utils/utils.dart';
import 'package:activos_nfc_app/core/models/models.dart';
import 'package:dio/dio.dart';

abstract class DioClient extends API {

  final Dio _dio;

  DioClient({
    required String baseUrl,
    bool isAuthenticatorRequired = false,
    Duration timeout = const Duration(seconds: 20),
    Duration receive = const Duration(seconds: 120),
  }) : _dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           receiveDataWhenStatusError: true,
           contentType: Headers.jsonContentType,
           followRedirects: true,
           sendTimeout: receive,
           connectTimeout: timeout,
           receiveTimeout: receive,
         ),
       );

  Future<String?> getJwtToken() async {
    String? authToken = await SharedPreferencesManager.getToken();
    return authToken;
  }

  String getApiKey() {
    return AppData.platformApiKey;
  }

  @override
  Future<Response<dynamic>> get(
    String path,
    ApiAuthType authType, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final String? token = await getJwtToken();
      final String apiKey = getApiKey();

      headers ??= {};
      if (token != null && authType == ApiAuthType.bearer) {
        headers['Authorization'] = 'Bearer $token';
      } else if (apiKey.isNotEmpty && authType == ApiAuthType.apiKey) {
        headers['api-key'] = apiKey;
        headers['organization-id'] = AppData.organizationId;
      }

      final Response<dynamic> response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
          responseType: ResponseType.json,
          followRedirects: true,
        ),
      );
      return response;
    } on DioException catch (e) {
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }

  @override
  Future<Response> post(
    String path,
    ApiAuthType authType, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body = const {},
  }) async {
    try {
      final String? token = await getJwtToken();
      final String apiKey = getApiKey();

      headers ??= {};
      if (token != null && authType == ApiAuthType.bearer) {
        headers['Authorization'] = 'Bearer $token';
      } else if (apiKey.isNotEmpty && authType == ApiAuthType.apiKey) {
        headers['api-key'] = apiKey;
        headers['organization-id'] = AppData.organizationId;
      }

      final Response<dynamic> response = await _dio.post(
        path,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
          responseType: ResponseType.json,
          followRedirects: true,
        ),
        data: body,
      );
      return response;
    } catch (e) {
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }

  Future<Response> postWithFiles(
    String path,
    ApiAuthType authType, {
    Map<String, dynamic>? headers,
    dynamic body = const {},
    List<File> files = const [],
  }) async {
    try {
      final String? token = await getJwtToken();
      final String apiKey = getApiKey();

      headers ??= {};
      if (token != null && authType == ApiAuthType.bearer) {
        headers['Authorization'] = 'Bearer $token';
      } else if (apiKey.isNotEmpty && authType == ApiAuthType.apiKey) {
        headers['api-key'] = apiKey;
        headers['organization-id'] = AppData.organizationId;
      }

      List<MultipartFile> multipartFiles = [];
      for(var file in files){
        multipartFiles.add(await MultipartFile.fromFile(
          file.path, filename: file.path.split('/').last
        ));
      }

      FormData formData = FormData.fromMap({
        ...body,
        'files': multipartFiles,
      });

      final Response<dynamic> response = await _dio.post(
        path,
        options: Options(
          headers: headers,
          responseType: ResponseType.json,
          followRedirects: true,
        ),
        data: formData,
      );
      return response;
    } catch (e) {
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }

  //@override
  Future<Response<dynamic>> postWithoutJwt(
    String path, {
    dynamic body = const {},
  }) async {
    try {
      final Response<dynamic> response = await _dio.post(
        path,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          responseType: ResponseType.json,
          followRedirects: true,
        ),
        data: body,
      );
      return response;
    } on DioException catch (e) {
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }

  @override
  Future<Response> patch(
    String path,
    ApiAuthType authType, {
    Map<String, dynamic>? headers,
    dynamic body = const {},
  }) async {
    try {
      final String? token = await getJwtToken();
      final String apiKey = getApiKey();

      headers ??= {};
      if (token != null && authType == ApiAuthType.bearer) {
        headers['Authorization'] = 'Bearer $token';
      } else if (apiKey.isNotEmpty && authType == ApiAuthType.apiKey) {
        headers['api-key'] = apiKey;
        headers['organization-id'] = AppData.organizationId;
      }

      final Response<dynamic> response = await _dio.patch(
        path,
        options: Options(
          headers: headers,
          responseType: ResponseType.json,
          followRedirects: true,
        ),
        data: body,
      );
      return response;
    } on DioException catch (e) {
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }

  Future<Response> patchWithFiles(
    String path,
    ApiAuthType authType, {
    Map<String, dynamic>? headers,
    dynamic body = const {},
    List<File> files = const [],
  }) async {
    try {
      final String? token = await getJwtToken();
      final String apiKey = getApiKey();

      headers ??= {};
      if (token != null && authType == ApiAuthType.bearer) {
        headers['Authorization'] = 'Bearer $token';
      } else if (apiKey.isNotEmpty && authType == ApiAuthType.apiKey) {
        headers['api-key'] = apiKey;
        headers['organization-id'] = AppData.organizationId;
      }

      List<MultipartFile> multipartFiles = [];
      for(var file in files){
        multipartFiles.add(await MultipartFile.fromFile(
          file.path, filename: file.path.split('/').last
        ));
      }

      FormData formData = FormData.fromMap({
        ...body,
        'files': multipartFiles,
      });

      final Response<dynamic> response = await _dio.patch(
        path,
        options: Options(
          headers: headers,
          responseType: ResponseType.json,
          followRedirects: true,
        ),
        data: formData,
      );
      return response;
    } catch (e) {
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }

  @override
  Future<Response> upload(
    String path,
    ApiAuthType authType, {
    Map<String, dynamic>? headers,
    List<File> files = const [],
  }) async {
    try {
      final String? token = await getJwtToken();
      final String apiKey = getApiKey();

      headers ??= {};
      if (token != null && authType == ApiAuthType.bearer) {
        headers['Authorization'] = 'Bearer $token';
      } else if (apiKey.isNotEmpty && authType == ApiAuthType.apiKey) {
        headers['api-key'] = apiKey;
        headers['organization-id'] = AppData.organizationId;
      }

      FormData formData = FormData();
      for(var file in files){
        formData.files.add(
          MapEntry(
            'files', 
            await MultipartFile.fromFile(
              file.path, 
              filename: file.path.split('/').last
            ))
        );
      }

      final Response<dynamic> response = await _dio.post(
        path,
        options: Options(
          headers: headers,
          responseType: ResponseType.json,
          followRedirects: true,
        ),
        data: formData,
      );
      return response;
    } catch (e) {
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }

  @override
  Future<Response> download(String path, String savePath) async {
    try {
      final response = await _dio.download(path, savePath);
      return response;
    } on DioException catch (e) {
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }

  @override
  Future<Response> put(
    String path,
    ApiAuthType authType, {
    Map<String, dynamic>? headers,
    dynamic body = const {},
  }) async {
    try {
      final String? token = await getJwtToken();
      final String apiKey = getApiKey();

      headers ??= {};
      if (token != null && authType == ApiAuthType.bearer) {
        headers['Authorization'] = 'Bearer $token';
      } else if (apiKey.isNotEmpty && authType == ApiAuthType.apiKey) {
        headers['api-key'] = apiKey;
        headers['organization-id'] = AppData.organizationId;
      }

      final Response<dynamic> response = await _dio.put(
        path,
        options: Options(
          headers: headers,
          responseType: ResponseType.json,
          followRedirects: true,
        ),
        data: body,
      );
      return response;
    } on DioException catch (e) {
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }

  @override
  Future<Response> delete(
    String path,
    ApiAuthType authType, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body = const {},
  }) async {
    try {
      final String? token = await getJwtToken();
      final String apiKey = getApiKey();

      headers ??= {};
      if (token != null && authType == ApiAuthType.bearer) {
        headers['Authorization'] = 'Bearer $token';
      } else if (apiKey.isNotEmpty && authType == ApiAuthType.apiKey) {
        headers['api-key'] = apiKey;
        headers['organization-id'] = AppData.organizationId;
      }

      final Response<dynamic> response = await _dio.delete(
        path,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
          responseType: ResponseType.json,
          followRedirects: true,
        ),
        data: body,
      );
      return response;
    } on DioException catch (e) {
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }
}