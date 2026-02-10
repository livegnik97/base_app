import 'package:flutter/foundation.dart';

class Constants {
  static bool get isDev => env == "dev" || kDebugMode;
  static const String env = "dev"; // dev, prod

  static const String baseUrlApi = env == 'dev'
      ? "https://dev.exapmle.com/api/"
      : "https://prod.exapmle.com/api/";

  static const String socketIoUrlBase = env == 'dev'
      ? "https://dev.exapmle.com"
      : "https://prod.exapmle.com";

  static const String socketIoPath = "/socket.io";

  static const double borderRadius = 16;
}
