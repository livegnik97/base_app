import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:base_app/core/helpers/keyboard_manager.dart';
import 'package:base_app/presentation/dialogs/dialog_confirm.dart';
import 'package:base_app/presentation/dialogs/dialog_confirm_with_phone_field.dart';
import 'package:base_app/presentation/dialogs/dialog_confirm_with_text_field.dart';
import 'package:base_app/presentation/dialogs/dialog_loading.dart';
import 'package:base_app/presentation/widgets/cards/custom_card.dart';
import 'package:base_app/presentation/widgets/shared/glass_morphism_widget.dart';

import '../extensions/custom_context.dart';

class DialogManager {
  static final List<DialogLoadingController> _loadingControllers = [];

  static Future<T?> showCustomDialog<T>(
    BuildContext context, {
    required Widget child,
    bool barrierDismissible = true,
    double? maxHeight,
    Color? barrierColor,
    bool useCard = true,
    Color? backgroundColor,
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
          Positioned.fill(
            child: FadeIn(
              duration: const Duration(milliseconds: 300),
              child: GlassMorphismWidget(),
            ),
          ),
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
                            color: backgroundColor,
                            elevation: 0,
                            padding: const EdgeInsets.all(22),
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
    List<OptionDialog>? options,
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
      options: options,
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
    bool canBeEmpty = false,
    int maxLines = 1,
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
      canBeEmpty: canBeEmpty,
      maxLines: maxLines,
    ),
  );

  static Future<T?> showConfirmWithPhoneDialog<T>(
    BuildContext context, {
    Color? barrierColor,
    bool barrierDismissible = true,
    PopInvokedWithResultCallback<T>? onPopInvokedWithResult,
    required String title,
    String? message,
    String? aceptBottonText,
    String? cancelBottonText,
    bool showCancelOption = true,
    required String textFieldLabel,
    String? textFieldHint,
    String? initialValue,
    required Future<String?> Function(String value) onConfirm,
    bool showLoading = true,
    Color? colorConfirmButton,
    Color? colorCancelButton,
    bool canBeEmpty = false,
  }) => showCustomDialog(
    context,
    barrierColor: barrierColor,
    barrierDismissible: barrierDismissible,
    onPopInvokedWithResult: onPopInvokedWithResult,
    child: DialogConfirmWithPhoneField(
      title: title,
      message: message,
      aceptBottonText: aceptBottonText,
      cancelBottonText: cancelBottonText,
      showCancelOption: showCancelOption,
      textFieldLabel: textFieldLabel,
      textFieldHint: textFieldHint,
      initialValue: initialValue,
      onConfirm: onConfirm,
      showLoading: showLoading,
      colorConfirmButton: colorConfirmButton,
      colorCancelButton: colorCancelButton,
      canBeEmpty: canBeEmpty,
    ),
  );

  static Future<T?> showLoadingDialog<T>(
    BuildContext context, {
    Color? barrierColor,
    bool barrierDismissible = false,
    PopInvokedWithResultCallback<T>? onPopInvokedWithResult,
    String? textInfo,
    Color? color,
    int? waitTimeInSeconds,
    DialogLoadingController? dialogProgressController,
  }) {
    final controller = dialogProgressController ?? DialogLoadingController();
    _loadingControllers.add(controller);
    return showCustomDialog<T>(
      context,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: DialogLoading(
        textInfo: textInfo,
        color: color,
        waitTimeInSeconds: waitTimeInSeconds,
        dialogProgressController: controller,
      ),
    ).then((result) {
      _loadingControllers.remove(controller);
      if (dialogProgressController == null) {
        controller.dispose();
      }
      return result;
    });
  }

  //* Cierra SOLO el último diálogo de carga abierto (no-op si ya no existe)
  static void closeLoadingDialog() {
    if (_loadingControllers.isEmpty) return;
    _loadingControllers.last.close();
  }
}
