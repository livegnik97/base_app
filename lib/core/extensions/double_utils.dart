import 'package:intl/intl.dart';

extension DoubleUtils on double {
  String toCurrency([String? symbol]) {
    final formatter = NumberFormat.currency(
      customPattern: "#,##0.00#",
      symbol: symbol ?? '',
      decimalDigits: 2,
    );
    return formatter.format(this);
  }

  double secureWithinLimits({double? min, double? max}) {
    if (min == null && max == null) return this;
    double result = this;
    if (min != null && result < min) result = min;
    if (max != null && result > max) result = max;
    return result;
  }

  double toSafePercent() {
    return secureWithinLimits(min: 0, max: 1);
  }

  double toNegative() {
    return abs() * -1;
  }

  double toPercentOf(num total) {
    return (this / total) * 100.0;
  }

  double toSafePercentOf(num total) {
    return (toPercentOf(total) / 100.0).toSafePercent();
  }
}
