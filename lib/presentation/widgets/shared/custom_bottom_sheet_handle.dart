import 'package:flutter/material.dart';
import 'package:base_app/core/extensions/color_extension.dart';
import 'package:base_app/core/extensions/custom_context.dart';

class CustomBottomSheetHandle extends StatelessWidget {
  const CustomBottomSheetHandle({
    super.key,
    this.backgroundColor,
    this.color,
  });

  final Color? backgroundColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.transparent,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Container(
          height: 4,
          width: 40,
          decoration: BoxDecoration(
            color: color ?? context.onSurfaceVariant.withOpacity2(.5),
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }
}
