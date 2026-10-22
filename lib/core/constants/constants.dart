import 'package:flutter/foundation.dart';

class Constants {
  static bool get isDev => env == "dev" || kDebugMode;
  static const String env = "dev"; // dev, gamma, prod

  //* sirve para desactivar el keepAlive de los providers en desarrollo
  static const bool ignoreKeepAliveProvider = true;

  //* cambiar esto para false para que no se muestre el error en el dio
  static bool showDioError = false;

  //* cambiar esto para true si se quiere el botón de cambio de tema en el appbar
  static bool showThemeChangeInCustomAppBar = isDev && false;

  static const String baseUrl = env == 'dev'
      ? "https://dev.exapmle.com"
      : "https://prod.exapmle.com";

  static const String baseUrlApi = "$baseUrl/api/";

  //* documentos legales (ajustar según el proyecto)
  static const String terms = "${baseUrlApi}legal/terms-of-use";
  static const String privacyPolicy = "${baseUrlApi}legal/privacy-policy";

  static const String socketIoUrlBase = baseUrl;
  static const String socketIoPath = "/socket.io";

  //* URL a la que dirige el botón "Actualizar" del diálogo de nueva versión
  static const String apkUpdateUrl =
      "https://www.apklis.cu/application/com.example.base_app";

  static const double borderRadius = 20;
}
