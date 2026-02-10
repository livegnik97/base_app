class CustomResponse<T> {
  final int statusCode;
  final T? data;
  final String? message;
  final String? type;

  //* pagination
  final int currentPage;
  final int pageSize;
  final int pageCount;

  CustomResponse({
    this.data,
    required this.statusCode,
    this.message,
    this.type,
    this.currentPage = 1,
    this.pageSize = 1,
    this.pageCount = 1,
  });

  bool get isOk => statusCode >= 200 && statusCode < 400;

  bool get hasError => statusCode >= 400;

  bool get isOkAndDataNotNull {
    return isOk && data != null;
  }

  @override
  String toString() {
    return 'CustomResponse(statusCode: $statusCode, data: $data, message: $message, type: $type, currentPage: $currentPage, pageSize: $pageSize, pageCount: $pageCount)';
  }
}
