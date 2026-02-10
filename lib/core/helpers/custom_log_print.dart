import 'dart:async' show Zone;
import 'dart:developer' as log_dev;

import '../constants/constants.dart';

class CustomLog {
  static void call(
    String message, {
    DateTime? time,
    int? sequenceNumber,
    int level = 0,
    String name = '',
    Zone? zone,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (Constants.isDev) {
      log_dev.log(message);
    }
  }
}

class CustomPrint {
  static void call(String message) {
    if (Constants.isDev) {
      // ignore: avoid_print
      print(message);
    }
  }
}
