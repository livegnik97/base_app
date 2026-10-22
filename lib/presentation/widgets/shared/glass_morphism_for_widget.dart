import 'dart:ui';

import 'package:flutter/material.dart';

class GlassMorphismForWidget extends StatelessWidget {
  const GlassMorphismForWidget({super.key, this.blur = 1, required this.child});

  final double blur;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      child: child,
    );
  }
}
