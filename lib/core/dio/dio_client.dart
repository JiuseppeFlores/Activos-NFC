import 'dart:io';

import 'package:activos_nfc_app/core/models/models.dart';
import 'package:activos_nfc_app/core/dio/interceptors/auth_interceptor.dart';
import 'package:dio/dio.dart';

abstract class DioClient extends API {

  final Dio _dio;

  DioClient({
    required String baseUrl,
    Duration timeout = const Duration(seconds: 20),
    Duration receive = const Duration(seconds: 120),
  }) : _dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           receiveDataWhenStatusError: true,
           contentType: Headers.jsonContentType,
           followRedirects: true,
           sendTimeout: timeout,
           connectTimeout: timeout,
           receiveTimeout: receive,
         ),
       ) {
    _dio.interceptors.add(AuthInterceptor());
  }

  @override
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.get(
      path,
      queryParameters: queryParameters,
      options: Options(
        headers: headers,
        responseType: ResponseType.json,
        followRedirects: true,
        extra: {'requiresToken': true},
      ),
    );
  }

  @override
  Future<Response> post(
    String path, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body = const {},
  }) async {
    return await _dio.post(
      path,
      queryParameters: queryParameters,
      options: Options(
        headers: headers,
        responseType: ResponseType.json,
        followRedirects: true,
        extra: {'requiresToken': true},
      ),
      data: body,
    );
  }

  Future<Response> postWithFiles(
    String path, {
    Map<String, dynamic>? headers,
    dynamic body = const {},
    List<File> files = const [],
  }) async {
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

    return await _dio.post(
      path,
      options: Options(
        headers: headers,
        responseType: ResponseType.json,
        followRedirects: true,
        extra: {'requiresToken': true},
      ),
      data: formData,
    );
  }

  Future<Response<dynamic>> postWithoutJwt(
    String path, {
    dynamic body = const {},
  }) async {
    return await _dio.post(
      path,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        responseType: ResponseType.json,
        followRedirects: true,
        extra: {'requiresToken': false},
      ),
      data: body,
    );
  }

  @override
  Future<Response> patch(
    String path, {
    Map<String, dynamic>? headers,
    dynamic body = const {},
  }) async {
    return await _dio.patch(
      path,
      options: Options(
        headers: headers,
        responseType: ResponseType.json,
        followRedirects: true,
        extra: {'requiresToken': true},
      ),
      data: body,
    );
  }

  Future<Response> patchWithFiles(
    String path, {
    Map<String, dynamic>? headers,
    dynamic body = const {},
    List<File> files = const [],
  }) async {
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

    return await _dio.patch(
      path,
      options: Options(
        headers: headers,
        responseType: ResponseType.json,
        followRedirects: true,
        extra: {'requiresToken': true},
      ),
      data: formData,
    );
  }

  @override
  Future<Response> upload(
    String path, {
    Map<String, dynamic>? headers,
    List<File> files = const [],
  }) async {
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

    return await _dio.post(
      path,
      options: Options(
        headers: headers,
        responseType: ResponseType.json,
        followRedirects: true,
        extra: {'requiresToken': true},
      ),
      data: formData,
    );
  }

  @override
  Future<Response> download(String path, String savePath) async {
    return await _dio.download(path, savePath);
  }

  @override
  Future<Response> put(
    String path, {
    Map<String, dynamic>? headers,
    dynamic body = const {},
  }) async {
    return await _dio.put(
      path,
      options: Options(
        headers: headers,
        responseType: ResponseType.json,
        followRedirects: true,
        extra: {'requiresToken': true},
      ),
      data: body,
    );
  }

  @override
  Future<Response> delete(
    String path, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body = const {},
  }) async {
    return await _dio.delete(
      path,
      queryParameters: queryParameters,
      options: Options(
        headers: headers,
        responseType: ResponseType.json,
        followRedirects: true,
        extra: {'requiresToken': true},
      ),
      data: body,
    );
  }
}