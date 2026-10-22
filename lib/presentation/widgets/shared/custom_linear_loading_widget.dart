import 'package:flutter/material.dart';

class CustomLinearLoadingWidget extends StatelessWidget {
  const CustomLinearLoadingWidget({
    super.key,
    required this.isLoading,
    this.height = 4,
    this.color,
  });

  final bool isLoading;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => ScaleTransition(
        scale: animation,
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: isLoading
          ? LinearProgressIndicator(minHeight: height, color: color)
          : SizedBox(height: height),
    );
  }
}
