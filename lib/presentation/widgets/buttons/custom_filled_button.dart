import 'package:auto_size_text/auto_size_text.dart';
import 'package:base_app/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:base_app/presentation/widgets/shared/custom_loading_widget.dart';

class CustomFilledButton extends StatelessWidget {
  const CustomFilledButton({
    super.key,
    this.icon,
    this.imageAsset,
    required this.label,
    this.borderRadius = Constants.borderRadius,
    this.height = 50,
    this.width,
    this.color,
    this.labelColor,
    this.isLoading = false,
    this.centerContent = true,
    this.borderSide,
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
  final bool isLoading;
  final BorderSide? borderSide;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: labelColor,
      alignment: centerContent ? null : const Alignment(-1, 0),
      side: borderSide,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
    );

    final button = (icon != null || imageAsset != null)
        ? FilledButton.icon(
            style: buttonStyle,
            label: isLoading
                ? CustomLoadingWidget()
                : AutoSizeText(label, maxLines: 1, minFontSize: 1),
            icon: imageAsset != null
                ? Image.asset(imageAsset!, width: 25, height: 25)
                : Icon(icon),
            onPressed: isLoading ? null : onPressed,
            onLongPress: isLoading ? null : onLongPress,
          )
        : FilledButton(
            style: buttonStyle,
            onPressed: isLoading ? null : onPressed,
            onLongPress: isLoading ? null : onLongPress,
            child: isLoading
                ? CustomLoadingWidget()
                : AutoSizeText(label, maxLines: 1, minFontSize: 1),
          );

    if (height != null || width != null) {
      return SizedBox(width: width, height: height, child: button);
    }
    return button;
  }
}
