import 'dart:io';

import 'package:base_app/core/network/dns_fallback.dart';

/*
  Llamar en el main
  HttpOverrides.global = MyHttpOverrides();
 */

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true)
      ..connectionFactory = DnsFallback.connectionFactory;
  }
}
