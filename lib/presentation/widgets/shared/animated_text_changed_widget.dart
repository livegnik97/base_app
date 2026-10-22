import 'package:flutter/material.dart';

class AnimatedTextChangedWidget<T extends num> extends StatelessWidget {
  const AnimatedTextChangedWidget({
    super.key,
    required this.beginValue,
    required this.endValue,
    this.onEnd,
    this.style,
    this.processValueResult,
    this.builder,
  });

  final T beginValue;
  final T endValue;
  final VoidCallback? onEnd;
  final TextStyle? style;
  final String Function(T value)? processValueResult;
  final Widget Function(BuildContext context, T value)? builder;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<T>(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      tween: _NumTween<T>(
        begin: beginValue,
        end: endValue,
      ),
      onEnd: onEnd,
      builder: (context, value, _) {
        return builder?.call(context, value) ??
            Text(
              '${processValueResult?.call(value) ?? value}',
              style: style,
            );
      },
    );
  }
}

class _NumTween<T extends num> extends Tween<T> {
  _NumTween({required T begin, required T end}) : super(begin: begin, end: end);

  @override
  T lerp(double t) {
    final value = begin! + (end! - begin!) * t;
    return T == int ? value.round() as T : value as T;
  }
}
