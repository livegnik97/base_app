import 'dart:ui';

import 'package:base_app/core/extensions/double_utils.dart';

extension ColorExtension on Color {
  Color withOpacity2(double opacity) {
    return withAlpha(
      (255 * opacity.toSafePercent())
          .secureWithinLimits(min: 0, max: 255)
          .round(),
    );
  }
}
