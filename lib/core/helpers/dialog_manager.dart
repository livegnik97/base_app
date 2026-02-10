import 'package:animate_do/animate_do.dart';
import 'package:base_app/core/helpers/keyboard_manager.dart';
import 'package:base_app/presentation/dialogs/dialog_confirm.dart';
import 'package:base_app/presentation/dialogs/dialog_confirm_with_text_field.dart';
import 'package:base_app/presentation/dialogs/dialog_loading.dart';
import 'package:base_app/presentation/widgets/cards/custom_card.dart';
import 'package:base_app/presentation/widgets/shared/glass_morphism_widget.dart';
import 'package:flutter/material.dart';

import '../extensions/custom_context.dart';

class DialogManager {
  static Future<T?> showCustomDialog<T>(
    BuildContext context, {
    required Widget child,
    bool barrierDismissible = true,
    double? maxHeight,
    Color? barrierColor,
    bool useCard = true,
    PopInvokedWithResultCallback<T>? onPopInvokedWithResult,
  }) {
    KeyboardManager.close(context);
    return showDialog<T>(
      barrierColor:
          barrierColor ?? Colors.transparent.withAlpha((255 * 0.4).toInt()),
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (BuildContext context) => Stack(
        children: [
          Positioned.fill(child: Center(child: GlassMorphismWidget())),
          Center(
            child: PopScope(
              canPop: barrierDismissible,
              onPopInvokedWithResult: onPopInvokedWithResult,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: context.width * .5,
                  maxWidth: context.width * .9,
                  // minHeight: context.height * .3,
                  maxHeight: maxHeight ?? context.height * .8,
                ),
                child: Padding(
                  padding: context.viewInsets,
                  child: ZoomIn(
                    child: useCard
                        ? CustomCard(
                            color: context.surfaceContainerHighest,
                            elevation: 0,
                            padding: const EdgeInsets.all(8),
                            child: child,
                          )
                        : child,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<T?> showConfirmDialog<T>(
    BuildContext context, {
    Color? barrierColor,
    bool barrierDismissible = true,
    PopInvokedWithResultCallback<T>? onPopInvokedWithResult,
    String? title,
    String? message,
    Widget? header,
    Widget? footer,
    String? subMessage,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    VoidCallback? onOtherOption,
    Color? colorConfirmButton,
    Color? colorCancelButton,
    String? aceptBottonText,
    String? cancelBottonText,
    bool showCancelOption = true,
    bool confirmAndBack = true,
    int? messageMaxLines,
  }) => showCustomDialog(
    context,
    barrierColor: barrierColor,
    barrierDismissible: barrierDismissible,
    onPopInvokedWithResult: onPopInvokedWithResult,
    child: DialogConfirm(
      title: title,
      message: message,
      header: header,
      footer: footer,
      subMessage: subMessage,
      onConfirm: onConfirm,
      onCancel: onCancel,
      onOtherOption: onOtherOption,
      colorConfirmButton: colorConfirmButton,
      colorCancelButton: colorCancelButton,
      aceptBottonText: aceptBottonText,
      cancelBottonText: cancelBottonText,
      showCancelOption: showCancelOption,
      confirmAndBack: confirmAndBack,
      messageMaxLines: messageMaxLines,
    ),
  );

  static Future<T?> showConfirmWithTextDialog<T>(
    BuildContext context, {
    Color? barrierColor,
    bool barrierDismissible = true,
    PopInvokedWithResultCallback<T>? onPopInvokedWithResult,
    required String title,
    String? message,
    String? aceptBottonText,
    String? cancelBottonText,
    String? otherOptionBottonText,
    required String textFieldLabel,
    required String textFieldHint,
    bool showCancelOption = true,
    String? initialValue,
    required Future<String?> Function(String value) onConfirm,
    bool showLoading = true,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    Color? colorConfirmButton,
    Color? colorCancelButton,
  }) => showCustomDialog(
    context,
    barrierColor: barrierColor,
    barrierDismissible: barrierDismissible,
    onPopInvokedWithResult: onPopInvokedWithResult,
    child: DialogConfirmWithTextField(
      title: title,
      message: message,
      aceptBottonText: aceptBottonText,
      cancelBottonText: cancelBottonText,
      otherOptionBottonText: otherOptionBottonText,
      textFieldLabel: textFieldLabel,
      textFieldHint: textFieldHint,
      showCancelOption: showCancelOption,
      initialValue: initialValue,
      onConfirm: onConfirm,
      showLoading: showLoading,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      colorConfirmButton: colorConfirmButton,
      colorCancelButton: colorCancelButton,
    ),
  );

  static Future<T?> showLoadingDialog<T>(
    BuildContext context, {
    Color? barrierColor,
    bool barrierDismissible = true,
    PopInvokedWithResultCallback<T>? onPopInvokedWithResult,
    String? textInfo,
    Color? color,
    int? waitTimeInSeconds,
    DialogLoadingController? dialogProgressController,
  }) => showCustomDialog(
    context,
    barrierColor: barrierColor,
    barrierDismissible: barrierDismissible,
    onPopInvokedWithResult: onPopInvokedWithResult,
    child: DialogLoading(
      textInfo: textInfo,
      color: color,
      waitTimeInSeconds: waitTimeInSeconds,
      dialogProgressController: dialogProgressController,
    ),
  );
}
