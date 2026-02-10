import 'dart:math';

import 'package:base_app/core/constants/constants.dart';
import 'package:base_app/core/extensions/custom_context.dart';
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    this.child,
    this.margin,
    this.padding,
    this.onTap,
    this.onLongPress,
    this.color,
    this.radius = Constants.borderRadius,
    this.width,
    this.height,
    this.withBorder = false,
    this.border,
  });

  final Widget? child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? color;
  final double radius;
  final double? width;
  final double? height;
  final bool withBorder;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    Widget? realChild = child;
    if (padding != null) {
      realChild = Padding(padding: padding!, child: child);
    }
    double borderWidth = 0;
    if (border != null) {
      borderWidth = max(border!.bottom.width, border!.top.width);
    } else if (withBorder) {
      borderWidth = 1;
    }
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? context.surface,
        borderRadius: BorderRadius.circular(radius + borderWidth),
        border:
            border ??
            (withBorder
                ? Border.all(color: context.surfaceContainerHighest, width: 1)
                : null),
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          // splashColor: Colors.blue.withAlpha(30),
          onTap: onTap,
          onLongPress: onLongPress,
          child: realChild,
        ),
      ),
    );
  }

  static CustomContainer lowest(
    BuildContext context, {
    Key? key,
    Widget? child,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    double radius = Constants.borderRadius,
    double? width,
    double? height,
    ShapeBorder? shape,
  }) => CustomContainer(
    key: key,
    margin: margin,
    padding: padding,
    onTap: onTap,
    onLongPress: onLongPress,
    color: context.surfaceContainerLowest,
    radius: radius,
    width: width,
    height: height,
    child: child,
  );

  static CustomContainer low(
    BuildContext context, {
    Key? key,
    Widget? child,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    double radius = Constants.borderRadius,
    double? width,
    double? height,
    ShapeBorder? shape,
  }) => CustomContainer(
    key: key,
    margin: margin,
    padding: padding,
    onTap: onTap,
    onLongPress: onLongPress,
    color: context.surfaceContainerLow,
    radius: radius,
    width: width,
    height: height,
    child: child,
  );

  static CustomContainer high(
    BuildContext context, {
    Key? key,
    Widget? child,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    double radius = Constants.borderRadius,
    double? width,
    double? height,
    ShapeBorder? shape,
  }) => CustomContainer(
    key: key,
    margin: margin,
    padding: padding,
    onTap: onTap,
    onLongPress: onLongPress,
    color: context.surfaceContainerHigh,
    radius: radius,
    width: width,
    height: height,
    child: child,
  );

  static CustomContainer highest(
    BuildContext context, {
    Key? key,
    Widget? child,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    double radius = Constants.borderRadius,
    double? width,
    double? height,
    ShapeBorder? shape,
  }) => CustomContainer(
    key: key,
    margin: margin,
    padding: padding,
    onTap: onTap,
    onLongPress: onLongPress,
    color: context.surfaceContainerHighest,
    radius: radius,
    width: width,
    height: height,
    child: child,
  );
}
