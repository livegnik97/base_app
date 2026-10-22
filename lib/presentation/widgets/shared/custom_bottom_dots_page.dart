import 'package:flutter/material.dart';
import 'package:base_app/core/extensions/color_extension.dart';
import 'package:base_app/core/extensions/custom_context.dart';
import 'package:base_app/presentation/widgets/containers/custom_container.dart';

class CustomBottomDotsPage extends StatelessWidget {
  const CustomBottomDotsPage({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.backgroundColor,
    this.currentColor,
    this.otherColor,
    this.withShadow = true,
    this.maxHeight = 16,
  });

  final int currentPage;
  final int totalPages;
  final Color? backgroundColor;
  final Color? currentColor;
  final Color? otherColor;
  final bool withShadow;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomContainer(
          height: maxHeight,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
          // color: backgroundColor ?? Colors.transparent,
          color: backgroundColor ?? context.surface,
          borderRadius: BorderRadius.circular(50),
          withShadow: withShadow,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (int index = 0; index < totalPages; index++)
                Builder(
                  builder: (context) {
                    final height = maxHeight - 8;
                    final size =
                        (index == currentPage
                                ? height
                                : (currentPage - index).abs() < 5
                                ? ((height - 1) / (currentPage - index).abs())
                                : 0)
                            .toDouble();
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: size == 0
                          ? EdgeInsets.zero
                          : const EdgeInsets.symmetric(horizontal: 3),
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == currentPage
                            ? (currentColor ?? context.primary)
                            : (otherColor ??
                                  context.secondary.withOpacity2(.6)),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: List.generate(
    //     totalPages,
    //     (index) => AnimatedContainer(
    //       duration: const Duration(milliseconds: 300),
    //       width: 8,
    //       height: 8,
    //       margin: const EdgeInsets.symmetric(horizontal: 4),
    //       decoration: BoxDecoration(
    //         shape: BoxShape.circle,
    //         color: index == currentPage
    //             ? context.primary
    //             : Theme.of(context).dividerColor,
    //       ),
    //     ),
    //   ),
    // );
  }
}
