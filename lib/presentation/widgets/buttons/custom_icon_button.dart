import 'package:base_app/core/constants/constants.dart';
import 'package:flutter/material.dart';

enum IconButtonType { normal, filled, filledTonal, outlined }

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.icon,
    this.iconButtonType = IconButtonType.normal,
    this.badgeInfo,
    this.badgeAlignment,
    this.radius = Constants.borderRadius,
    this.color,
    this.backgroundColor,
    this.badgeTextColor,
    this.badgeColor,
    this.size,
    this.tooltip,
    this.onPressed,
    this.onLongPress,
  });

  final IconData icon;
  final String? badgeInfo;
  final AlignmentGeometry? badgeAlignment;
  final IconButtonType iconButtonType;
  final double radius;
  final Color? color;
  final Color? backgroundColor;
  final Color? badgeTextColor;
  final Color? badgeColor;
  final double? size;
  final String? tooltip;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return badgeInfo == null || badgeInfo!.isEmpty
        ? getIconButton()
        : Badge(
            backgroundColor: badgeColor ?? colorScheme.tertiary,
            label: Text(
              badgeInfo!,
              style: TextStyle(color: badgeTextColor ?? colorScheme.onTertiary),
            ),
            alignment: badgeAlignment ?? const Alignment(.25, -.35),
            child: getIconButton(),
          );
  }

  Widget getIconButton() {
    ButtonStyle buttonStyle = IconButton.styleFrom(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
    );
    switch (iconButtonType) {
      case IconButtonType.normal:
        return IconButton(
          tooltip: tooltip,
          style: buttonStyle,
          onPressed: onPressed,
          onLongPress: onLongPress,
          icon: Icon(icon, color: color, size: size),
        );
      case IconButtonType.filled:
        return IconButton.filled(
          tooltip: tooltip,
          style: buttonStyle,
          onPressed: onPressed,
          onLongPress: onLongPress,
          icon: Icon(icon, color: color, size: size),
        );
      case IconButtonType.filledTonal:
        return IconButton.filledTonal(
          tooltip: tooltip,
          style: buttonStyle,
          onPressed: onPressed,
          onLongPress: onLongPress,
          icon: Icon(icon, color: color, size: size),
        );
      case IconButtonType.outlined:
        return IconButton.outlined(
          tooltip: tooltip,
          style: buttonStyle,
          onPressed: onPressed,
          onLongPress: onLongPress,
          icon: Icon(icon, color: color, size: size),
        );
    }
  }
}
