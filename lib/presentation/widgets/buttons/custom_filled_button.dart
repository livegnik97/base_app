import 'package:auto_size_text/auto_size_text.dart';
import 'package:base_app/core/constants/constants.dart';
import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  const CustomFilledButton({
    super.key,
    this.icon,
    this.imageAsset,
    required this.label,
    this.borderRadius = Constants.borderRadius,
    this.height,
    this.width,
    this.color,
    this.labelColor,
    this.centerContent = true,
    this.onPressed,
    this.onLongPress,
  });

  final IconData? icon;
  final String? imageAsset;
  final String label;
  final double borderRadius;
  final double? height;
  final double? width;
  final Color? color;
  final Color? labelColor;
  final bool centerContent;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: labelColor,
      alignment: centerContent ? null : const Alignment(-1, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );

    final button = (icon != null || imageAsset != null)
        ? FilledButton.icon(
            style: buttonStyle,
            label: AutoSizeText(label, maxLines: 1, minFontSize: 1),
            icon: imageAsset != null
                ? Image.asset(imageAsset!, width: 25, height: 25)
                : Icon(icon),
            onPressed: onPressed,
            onLongPress: onLongPress,
          )
        : FilledButton(
            style: buttonStyle,
            onPressed: onPressed,
            onLongPress: onLongPress,
            child: AutoSizeText(label, maxLines: 1, minFontSize: 1),
          );

    if (height != null || width != null) {
      return SizedBox(width: width, height: height, child: button);
    }
    return button;
  }
}
