import 'dart:math';

import 'package:base_app/core/extensions/double_utils.dart';

extension IntUtils on int {
  int toNegative() {
    return abs() * -1;
  }

  double toPercentOf(num total) {
    return (this / total) * 100.0;
  }

  double toSafePercentOf(num total) {
    return (toPercentOf(total) / 100.0).toSafePercent();
  }

  //formatear los bytes para obtener un tamaño
  static String formatBytes(int bytes, [int decimals = 3]) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }
}
