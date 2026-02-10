import 'package:base_app/core/constants/constants.dart';
import 'package:base_app/core/extensions/custom_context.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.onLongPress,
    this.elevation = 1,
    this.color,
    this.radius = Constants.borderRadius,
    this.width,
    this.height,
    this.shape,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double elevation;
  final Color? color;
  final double radius;
  final double? width;
  final double? height;
  final ShapeBorder? shape;

  @override
  Widget build(BuildContext context) {
    Widget realChild = child;
    if (padding != null) {
      realChild = Padding(padding: padding!, child: child);
    }
    if (width != null || height != null) {
      realChild = SizedBox(width: width, height: height, child: realChild);
    }
    return Card(
      color: color ?? context.surface,
      shape:
          shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
      elevation: elevation,
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: realChild,
        ),
      ),
    );
  }
}
