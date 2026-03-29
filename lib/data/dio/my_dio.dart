// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:base_app/core/constants/constants.dart';
import 'package:base_app/core/helpers/custom_log_print.dart';
import 'package:base_app/data/dio/custom_dio_error.dart';
import 'package:base_app/presentation/widgets/shared/error_dio_description.dart';
import 'package:base_app/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

part "interceptors.dart";

enum RequestType { GET, POST, PUT, DELETE, PATCH }

class MyDio {
  late Dio _dio;

  late CustomInterceptors currentInterceptor;

  MyDio(String baseUrl) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          // "Access-Control-Allow-Origin": "*",
          // "Access-Control-Allow-Credentials": "true",
          // "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
          // "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
          // "Access-Control-Allow-Methods": "GET, POST, OPTIONS, PUT, PATCH, DELETE",
          "Access-Control-Allow-Methods": "*",
          // "Referrer-Policy": "no-referrer-when-downgrade",
          "Content-Type": "application/json; charset=utf-8",
        },
      ),
    );
    currentInterceptor = CustomInterceptors();
    _dio.interceptors.add(currentInterceptor);
  }

  void updateToken(String? token) {
    currentInterceptor.token = token;
  }

  Future<(Response<dynamic>, dynamic)> get({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
  }) => request(
    requestType: RequestType.GET,
    path: path,
    queryParameters: queryParameters,
    data: data,
  );

  Future<(Response<dynamic>, dynamic)> post({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
  }) => request(
    requestType: RequestType.POST,
    path: path,
    queryParameters: queryParameters,
    data: data,
  );

  Future<(Response<dynamic>, dynamic)> patch({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
  }) => request(
    requestType: RequestType.PATCH,
    path: path,
    queryParameters: queryParameters,
    data: data,
  );

  Future<(Response<dynamic>, dynamic)> delete({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
  }) => request(
    requestType: RequestType.DELETE,
    path: path,
    queryParameters: queryParameters,
    data: data,
  );

  Future<(Response<dynamic>, dynamic)> put({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
  }) => request(
    requestType: RequestType.PUT,
    path: path,
    queryParameters: queryParameters,
    data: data,
  );

  Future<(Response<dynamic>, dynamic)> request({
    required RequestType requestType,
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
  }) async {
    try {
      Response<dynamic> response;
      switch (requestType) {
        case RequestType.GET:
          response = await _dio.get(path, queryParameters: queryParameters);
          break;
        case RequestType.POST:
          response = await _dio.post(
            path,
            queryParameters: queryParameters,
            data: data,
          );
          break;
        case RequestType.PATCH:
          response = await _dio.patch(
            path,
            queryParameters: queryParameters,
            data: data,
          );
          break;
        case RequestType.DELETE:
          response = await _dio.delete(path, queryParameters: queryParameters);
          break;
        case RequestType.PUT:
          response = await _dio.put(
            path,
            queryParameters: queryParameters,
            data: data,
          );
          break;
      }
      try {
        return (response, jsonDecode(response.data));
      } catch (_) {
        return (response, response.data);
      }
    } on DioException catch (e) {
      CustomPrint.call("DioException: ${e.message}");
      throw CustomDioError(
        code: e.response?.statusCode ?? 400,
        message: e.response?.data['message'] ?? e.message,
        type: e.response?.data['type'],
        data: e.response?.data['data'],
      );
    } catch (e) {
      CustomPrint.call("Exception: ${e.toString()}");
      throw CustomDioError(code: 400, message: e.toString(), data: null);
    }
  }

  Future<(Response<dynamic>, dynamic)> postMultipart({
    required String path,
    Map<String, dynamic>? queryParameters,
    required FormData data,
    Options? options,
  }) => requestMultipart(
    requestType: RequestType.POST,
    path: path,
    queryParameters: queryParameters,
    data: data,
    options: options,
  );

  Future<(Response<dynamic>, dynamic)> patchMultipart({
    required String path,
    Map<String, dynamic>? queryParameters,
    required FormData data,
    Options? options,
  }) => requestMultipart(
    requestType: RequestType.PATCH,
    path: path,
    queryParameters: queryParameters,
    data: data,
    options: options,
  );

  Future<(Response<dynamic>, dynamic)> putMultipart({
    required String path,
    Map<String, dynamic>? queryParameters,
    required FormData data,
    Options? options,
  }) => requestMultipart(
    requestType: RequestType.PUT,
    path: path,
    queryParameters: queryParameters,
    data: data,
    options: options,
  );

  Future<(Response<dynamic>, dynamic)> requestMultipart({
    required RequestType requestType,
    required String path,
    Map<String, dynamic>? queryParameters,
    FormData? data,
    Options? options,
  }) async {
    try {
      // final options = Options(headers: {
      //   "Access-Control-Allow-Methods": "*",
      //   "Content-Type": "multipart/form-data"
      // });
      Response<dynamic> response;
      switch (requestType) {
        case RequestType.POST:
          response = await _dio.post(
            path,
            queryParameters: queryParameters,
            data: data,
          );
          // response = await _dio.post(path, data: data, options: options);
          break;
        case RequestType.PATCH:
          response = await _dio.patch(
            path,
            queryParameters: queryParameters,
            data: data,
          );
          // response = await _dio.patch(path, data: data, options: options);
          break;
        case RequestType.PUT:
          response = await _dio.put(
            path,
            queryParameters: queryParameters,
            data: data,
          );
          // response = await _dio.put(path, data: data, options: options);
          break;
        default:
          throw "Request type not found";
      }
      try {
        return (response, jsonDecode(response.data));
      } catch (_) {
        return (response, response.data);
      }
    } on DioException catch (e) {
      CustomPrint.call("DioException: ${e.message}");
      throw CustomDioError(
        code: e.response?.statusCode ?? 400,
        message: e.response?.data['message'] ?? e.message,
        type: e.response?.data['type'],
        data: e.response?.data['data'],
      );
    } catch (e) {
      CustomPrint.call("Exception: ${e.toString()}");
      throw CustomDioError(code: 400, message: e.toString(), data: null);
    }
  }
}
