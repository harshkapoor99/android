import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/utils/extensions.dart';
import 'package:guftagu_mobile/utils/request_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../gen/services/api_client.gen.dart';

@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  return ApiClient();
}

class ApiClient {
  ApiClient() {
    addApiInterceptors(_dio);
  }
  final Dio _dio = Dio();

  Map<String, dynamic> defaultHeaders = {HttpHeaders.authorizationHeader: null};
  Map<String, dynamic> authHeader = {"APIKEY": "guftagu2025"};
  int? activeCode;

  Future<Response> get(String url, {Map<String, dynamic>? query}) async {
    return _dio.get(
      url,
      queryParameters: query,
      options: Options(headers: defaultHeaders),
    );
  }

  Future<Response> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? headers,
    Duration? timeout,
    ResponseType? responseType,
  }) async {
    return _dio.post(
      url,
      data: data,
      options: Options(
        responseType: responseType,
        headers: headers ?? defaultHeaders,
        followRedirects: true,
        validateStatus: ((status) {
          return status! < 500;
        }),
        receiveTimeout: timeout,
      ),
    );
  }

  Future<Response> patch(
    String url, {
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    return _dio.patch(
      url,
      data: data,
      options: Options(
        headers: headers ?? defaultHeaders,
        followRedirects: true,
        validateStatus: ((status) {
          return status! < 500;
        }),
      ),
    );
  }

  Future<Response> put(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
  }) async {
    return _dio.put(
      url,
      data: data,
      options: Options(
        headers: headers ?? defaultHeaders,
        followRedirects: false,
        validateStatus: ((status) {
          return status! <= 500;
        }),
      ),
    );
  }

  Future<Response> delete(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
  }) async {
    return _dio.delete(
      url,
      data: data,
      options: Options(
        headers: headers ?? defaultHeaders,
        followRedirects: false,
        validateStatus: ((status) {
          return status! <= 500;
        }),
      ),
    );
  }

  void updateToken(String? token) {
    if (token.hasValue) {
      defaultHeaders[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }
  }

  void updateTokenDefault() {
    defaultHeaders[HttpHeaders.authorizationHeader] = null;
  }
}
