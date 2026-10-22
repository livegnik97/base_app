import 'package:base_app/core/helpers/error_manager.dart';
import 'package:base_app/data/dio/custom_dio_error.dart';

class CustomResponse<T> {
  final int statusCode;
  final T? data;
  final String? message;
  final String? type;
  final dynamic error;

  CustomResponse._({
    this.data,
    required this.statusCode,
    this.message,
    this.type,
    this.error,
  });

  bool get isOk => statusCode >= 200 && statusCode < 400;

  bool get hasError => statusCode >= 400;

  bool get isOkAndDataNotNull {
    return isOk && data != null;
  }

  factory CustomResponse.ok({
    int statusCode = 200,
    T? data,
    String? type,
    String? message,
  }) {
    return CustomResponse._(
      statusCode: statusCode,
      data: data,
      message: message,
      type: type,
    );
  }

  factory CustomResponse.error({
    int statusCode = 400,
    String? message,
    String? type,
    dynamic error,
  }) {
    return CustomResponse._(
      statusCode: statusCode,
      message: message,
      type: type,
      error: error,
    );
  }

  factory CustomResponse.fromCustomDioError(CustomDioError error) {
    try {
      if (error.type == null) {
        return CustomResponse._(
          statusCode: error.code,
          message: error.message,
          type: error.data['message'] is List<String>
              ? ErrorType.formError
              : ErrorType.unknownError,
          error: error.data,
        );
      }
      return CustomResponse._(
        statusCode: error.code,
        message: error.message,
        type: error.type,
        error: error.data,
      );
    } catch (e) {
      return CustomResponse._(
        statusCode: error.code,
        message: error.message,
        type: error.type,
        error: error.data,
      );
    }
  }
}
