import 'package:auto_size_text/auto_size_text.dart';
import 'package:base_app/core/constants/constants.dart';
import 'package:base_app/core/extensions/custom_context.dart';
import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton({
    super.key,
    this.icon,
    required this.label,
    this.imageAsset,
    this.radius = Constants.borderRadius,
    this.height,
    this.width,
    this.color,
    this.backgroundColor,
    this.centerContent = true,
    this.onPressed,
    this.onLongPress,
  });

  final IconData? icon;
  final String? imageAsset;
  final String label;
  final double radius;
  final double? height;
  final double? width;
  final Color? color;
  final Color? backgroundColor;
  final bool centerContent;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    ButtonStyle buttonStyle = OutlinedButton.styleFrom(
      foregroundColor: color,
      backgroundColor: backgroundColor,
      alignment: centerContent ? null : const Alignment(-1, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      side: BorderSide(width: 1, color: color ?? context.primary),
    );
    final button = (icon != null || imageAsset != null)
        ? OutlinedButton.icon(
            style: buttonStyle,
            label: AutoSizeText(label, maxLines: 1, minFontSize: 1),
            icon: imageAsset != null
                ? Image.asset(imageAsset!, width: 25, height: 25)
                : Icon(icon),
            onPressed: onPressed,
            onLongPress: onLongPress,
          )
        : OutlinedButton(
            style: buttonStyle,
            onPressed: onPressed,
            onLongPress: onLongPress,
            child: AutoSizeText(label, maxLines: 1, minFontSize: 1),
          );

    if (width != null || height != null) {
      return SizedBox(width: width, height: height, child: button);
    }

    return button;
  }
}
