import 'package:base_app/core/extensions/custom_context.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({
    super.key,
    this.color,
    this.size,
    this.isLoading = true,
    this.alternativeChild,
  });

  final Color? color;
  final double? size;
  final bool isLoading;
  final Widget? alternativeChild;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) =>
          ScaleTransition(scale: animation, child: child),
      child: isLoading
          ? LoadingAnimationWidget.threeArchedCircle(
              color: color ?? context.primary,
              size: size ?? 40,
            )
          : alternativeChild,
    );
  }
}
