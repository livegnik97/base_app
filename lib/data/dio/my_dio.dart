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

enum APIVersion { V1, V2 }

class MyDio {
  late Dio _dio;

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
    _dio.interceptors.add(CustomInterceptors(""));
  }

  void updateToken(String? token) {
    _dio.interceptors.clear();
    _dio.interceptors.add(CustomInterceptors(token));
  }

  Future<dynamic> get({
    required String path,
    bool requiredResponse = true,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
  }) => request(
    requestType: RequestType.GET,
    path: path,
    requiredResponse: requiredResponse,
    queryParameters: queryParameters,
    data: data,
  );

  Future<dynamic> post({
    required String path,
    bool requiredResponse = true,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
  }) => request(
    requestType: RequestType.POST,
    path: path,
    requiredResponse: requiredResponse,
    queryParameters: queryParameters,
    data: data,
  );

  Future<dynamic> patch({
    required String path,
    bool requiredResponse = true,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
  }) => request(
    requestType: RequestType.PATCH,
    path: path,
    requiredResponse: requiredResponse,
    queryParameters: queryParameters,
    data: data,
  );

  Future<dynamic> delete({
    required String path,
    bool requiredResponse = true,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
  }) => request(
    requestType: RequestType.DELETE,
    path: path,
    requiredResponse: requiredResponse,
    queryParameters: queryParameters,
    data: data,
  );

  Future<dynamic> put({
    required String path,
    bool requiredResponse = true,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
  }) => request(
    requestType: RequestType.PUT,
    path: path,
    requiredResponse: requiredResponse,
    queryParameters: queryParameters,
    data: data,
  );

  Future<dynamic> request({
    required RequestType requestType,
    required String path,
    bool requiredResponse = true,
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
      if (!requiredResponse) return null;
      return (response.data is String)
          ? jsonDecode(response.data)
          : response.data;
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

  Future<dynamic> requestMultipart({
    required RequestType requestType,
    required String path,
    bool requiredResponse = true,
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
      if (!requiredResponse) return null;
      return (response.data is String)
          ? jsonDecode(response.data)
          : response.data;
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
