class CustomDioError extends Error {
  final int code;
  final String? message;
  final String? type;
  final dynamic data;

  CustomDioError({required this.code, this.message, this.type, this.data});

  @override
  String toString() {
    return 'CustomDioError(code: $code, message: $message, type: $type, data: $data)';
  }
}
