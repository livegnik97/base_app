import 'dart:ui';

import 'package:flutter/material.dart';

class GlassMorphismWidget extends StatelessWidget {
  const GlassMorphismWidget({super.key, this.blur = 1, this.child});

  final double blur;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      child: child ?? const SizedBox.shrink(),
    );
  }
}
