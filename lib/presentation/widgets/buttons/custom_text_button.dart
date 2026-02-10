import 'package:auto_size_text/auto_size_text.dart';
import 'package:base_app/core/constants/constants.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    this.icon,
    required this.label,
    this.imageAsset,
    this.borderRadius = Constants.borderRadius,
    this.height,
    this.width,
    this.color,
    this.backgroundColor,
    this.centerContent = true,
    this.textStyle,
    this.onPressed,
    this.onLongPress,
  });

  final IconData? icon;
  final String? imageAsset;
  final String label;
  final double borderRadius;
  final double? width;
  final double? height;
  final Color? color;
  final Color? backgroundColor;
  final bool centerContent;
  final TextStyle? textStyle;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    ButtonStyle buttonStyle = TextButton.styleFrom(
      foregroundColor: color,
      backgroundColor: backgroundColor,
      alignment: centerContent ? null : const Alignment(-1, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
    );
    final button = (icon != null || imageAsset != null)
        ? TextButton.icon(
            style: buttonStyle,
            label: AutoSizeText(
              label,
              maxLines: 1,
              minFontSize: 1,
              style: textStyle,
            ),
            icon: imageAsset != null
                ? Image.asset(imageAsset!, width: 25, height: 25)
                : Icon(icon),
            onPressed: onPressed,
            onLongPress: onLongPress,
          )
        : TextButton(
            style: buttonStyle,
            onPressed: onPressed,
            onLongPress: onLongPress,
            child: AutoSizeText(
              label,
              maxLines: 1,
              minFontSize: 1,
              style: textStyle,
            ),
          );

    if (width != null || height != null) {
      return SizedBox(width: width, height: height, child: button);
    }

    return button;
  }
}
