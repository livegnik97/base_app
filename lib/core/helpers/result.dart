class Result<T> {
  final bool _success;
  final T? value;
  final String? message;
  final dynamic additionalInfo;

  Result._({
    required bool success,
    this.value,
    this.message,
    this.additionalInfo,
  }) : _success = success;

  factory Result.ok({T? value, String? message, dynamic additionalInfo}) {
    return Result._(
      success: true,
      value: value,
      message: message,
      additionalInfo: additionalInfo,
    );
  }

  factory Result.error({String? message, dynamic additionalInfo}) {
    return Result._(
      success: false,
      message: message,
      additionalInfo: additionalInfo,
    );
  }

  bool get isSuccess => _success;
  bool get isFailure => !_success;
}
