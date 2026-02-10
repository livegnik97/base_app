import 'package:base_app/core/constants/constants.dart';
import 'package:base_app/core/extensions/custom_context.dart';
import 'package:flutter/material.dart';

class CustomInformativeContainer extends StatelessWidget {
  const CustomInformativeContainer({
    super.key,
    required this.text,
    this.icon,
    required this.color,
    this.isVisible = true,
  });

  final String text;
  final IconData? icon;
  final Color color;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) =>
          ScaleTransition(scale: animation, child: child),
      child: isVisible
          ? Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withAlpha((255 * 0.1).round()),
                borderRadius: BorderRadius.circular(Constants.borderRadius),
                border: Border.all(color: color, width: 1),
              ),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: color),
                    SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      text,
                      style: context.labelSmall.copyWith(color: color),
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
