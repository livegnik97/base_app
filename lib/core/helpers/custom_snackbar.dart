import 'package:base_app/core/extensions/custom_context.dart';
import 'package:base_app/presentation/widgets/cards/custom_card.dart';
import 'package:flutter/material.dart';

class CustomSnackbar {
  // static void showOriginal(
  //   BuildContext context, {
  //   required String text,
  //   SnackBarAction? action,
  //   Duration duration = const Duration(milliseconds: 4000),
  // }) {
  //   if (text.isEmpty) return;
  //   final snackbar = SnackBar(
  //     content: Text(text),
  //     action: action,
  //     duration: duration,
  //     backgroundColor: Theme.of(context).colorScheme.secondary,
  //   );
  //   ScaffoldMessenger.of(context)
  //     ..clearSnackBars()
  //     ..showSnackBar(snackbar);
  // }

  static void show(
    BuildContext context, {
    required String text,
    IconData? icon,
    Color? onColor,
    Color? backgroundColor,
    SnackBarAction? action,
    Duration duration = const Duration(milliseconds: 4000),
  }) {
    if (text.isEmpty) return;
    final snackbar = SnackBar(
      content: CustomCard(
        color: backgroundColor ?? context.secondary,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: onColor ?? context.onSecondary),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                text.trim(),
                style: context.textTheme.bodyMedium!.copyWith(
                  color: onColor ?? context.onSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
      action: action,
      duration: duration,

      padding: const EdgeInsets.all(0),
      elevation: 0,
      dismissDirection: DismissDirection.horizontal,
      backgroundColor: Colors.transparent,
      // backgroundColor: color.secondary,
    );
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(snackbar);
  }

  // static void showWithLottie(BuildContext context, {
  //   required LottiePath lottiePath,
  //   required String text,
  //   SnackBarAction? action,
  //   Duration duration = const Duration(milliseconds: 4000),
  // }){
  //   if(text.isEmpty) return;
  //   final color = Theme.of(context).colorScheme;
  //   final snackbar = SnackBar(
  //     content: FadeInUp(
  //       child: CustomCard(
  //         color: color.secondary,
  //         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: [
  //             Lottie.asset(lottiePath.path, height: 60, width: 60, fit: BoxFit.fill, repeat: false),
  //             const SizedBox(width: 10),
  //             Flexible(
  //               child: Text(text, style: Theme.of(context).textTheme.bodyMedium!.copyWith(
  //                 color: color.onSecondary
  //               )),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //     action: action,
  //     duration: duration,
  //     padding: const EdgeInsets.all(0),
  //     elevation: 0,
  //     dismissDirection: DismissDirection.horizontal,
  //     backgroundColor: Colors.transparent,
  //     // backgroundColor: color.secondary,
  //   );
  //   ScaffoldMessenger.of(context)
  //     ..clearSnackBars()
  //     ..showSnackBar(snackbar);
  // }
}
