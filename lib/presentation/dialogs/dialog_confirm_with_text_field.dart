import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:base_app/core/extensions/custom_context.dart';
import 'package:base_app/l10n/app_localizations.dart';
import 'package:base_app/presentation/widgets/buttons/custom_filled_button.dart';
import 'package:base_app/presentation/widgets/buttons/custom_text_button.dart';
import 'package:base_app/presentation/widgets/forms_widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:base_app/presentation/widgets/shared/custom_loading_widget.dart';

class DialogConfirmWithTextField extends StatefulWidget {
  const DialogConfirmWithTextField({
    super.key,
    required this.title,
    required this.message,
    this.aceptBottonText,
    this.cancelBottonText,
    this.otherOptionBottonText,
    this.showCancelOption = true,
    required this.textFieldLabel,
    required this.textFieldHint,
    this.initialValue,
    required this.onConfirm,
    this.showLoading = false,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.colorConfirmButton,
    this.colorCancelButton,
    this.canBeEmpty = false,
    this.maxLines = 1,
  });

  final String title;
  final String? message;
  final String? aceptBottonText;
  final String? cancelBottonText;
  final String? otherOptionBottonText;
  final String textFieldLabel;
  final String textFieldHint;
  final bool showCancelOption;
  final String? initialValue;
  final Future<String?> Function(String value) onConfirm;
  final bool showLoading;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final Color? colorConfirmButton;
  final Color? colorCancelButton;
  final bool canBeEmpty;
  final int maxLines;

  @override
  State<DialogConfirmWithTextField> createState() =>
      _DialogConfirmWithTextFieldState();
}

class _DialogConfirmWithTextFieldState
    extends State<DialogConfirmWithTextField> {
  String? errorMessage;

  late TextEditingController controller;

  bool loading = false;

  final focusNode = FocusNode();

  @override
  void initState() {
    controller = TextEditingController(text: widget.initialValue ?? '');
    Future.delayed(
      const Duration(milliseconds: 600),
      () => focusNode.requestFocus(),
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool get isFormValid =>
      widget.canBeEmpty || controller.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: double.infinity),
          AutoSizeText(
            widget.title,
            style: context.titleLarge.copyWith(fontWeight: FontWeight.bold),
            maxLines: 2,
            minFontSize: 1,
          ),
          if (widget.message != null) ...[
            const SizedBox(height: 16),
            AutoSizeText(
              widget.message!,
              style: context.bodySmall.copyWith(fontSize: 14),
              textAlign: TextAlign.start,
              minFontSize: 12,
            ),
          ],
          const SizedBox(height: 24),
          CustomTextFormField(
            enabled: !loading,
            keyboardType: widget.keyboardType,
            textCapitalization: widget.textCapitalization,
            focusNode: focusNode,
            textInputAction: TextInputAction.go,
            maxLines: widget.maxLines,
            onFieldSubmitted: (value) {
              if (isFormValid) {
                save();
              }
            },
            label: widget.textFieldLabel,
            controller: controller,
            hint: widget.textFieldHint,
            onChanged: (_) => check(),
            errorMessage: errorMessage,
            suffixIcon: controller.text.isNotEmpty
                ? ZoomIn(
                    child: IconButton(
                      onPressed: () {
                        controller.clear();
                        check();
                      },
                      icon: const Icon(Icons.clear_rounded, color: Colors.grey),
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 32),
          AnimatedCrossFade(
            firstChild: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomLoadingWidget(),
                ],
              ),
            ),
            secondChild: Row(
              mainAxisSize: MainAxisSize.max,
              // crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 20,
                ),
                if (widget.showCancelOption)
                  CustomTextButton(
                    label:
                        widget.cancelBottonText ??
                        AppLocalizations.of(context)!.cancel,
                    onPressed: () async {
                      context.pop();
                    },
                  ),
                CustomFilledButton(
                  onPressed: isFormValid
                      ? () async {
                          save();
                        }
                      : null,
                  color: widget.colorConfirmButton,
                  label:
                      widget.aceptBottonText ??
                      AppLocalizations.of(context)!.accept,
                ),
              ],
            ),
            crossFadeState: !loading
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  void save() async {
    if (!widget.showLoading) {
      context.pop();
      widget.onConfirm.call(controller.text.trim());
      return;
    }
    try {
      focusNode.unfocus();
    } catch (_) {}
    loading = true;
    errorMessage = null;
    setState(() {});
    errorMessage = await widget.onConfirm.call(controller.text.trim());
    if (errorMessage == null && context.mounted) {
      // ignore: use_build_context_synchronously
      context.pop();
    } else {
      loading = false;
      setState(() {});
    }
  }

  void check() {
    setState(() {
      if (!isFormValid) {
        errorMessage = "Este campo no puede estar vacío";
      } else {
        errorMessage = null;
      }
    });
  }
}
