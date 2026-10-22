import 'package:flutter/material.dart';

class CustomAnimatedSwitcher extends StatelessWidget {
  const CustomAnimatedSwitcher({
    super.key,
    required this.isVisible,
    required this.child,
    this.anotherChild,
    this.duration,
    this.transitionBuilder,
  });

  final bool isVisible;
  final Widget child;
  final Widget? anotherChild;
  final Duration? duration;
  final AnimatedSwitcherTransitionBuilder? transitionBuilder;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration ?? const Duration(milliseconds: 300),
      transitionBuilder:
          transitionBuilder ??
          (child, animation) => SizeTransition(
            sizeFactor: animation,
            child: FadeTransition(opacity: animation, child: child),
          ),
      child: isVisible ? child : anotherChild ?? SizedBox.shrink(),
    );
  }
}
