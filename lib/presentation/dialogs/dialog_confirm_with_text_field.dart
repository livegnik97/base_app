import 'package:animate_do/animate_do.dart';
import 'package:base_app/core/extensions/custom_context.dart';
import 'package:base_app/l10n/app_localizations.dart';
import 'package:base_app/presentation/widgets/buttons/custom_filled_button.dart';
import 'package:base_app/presentation/widgets/buttons/custom_outlined_button.dart';
import 'package:base_app/presentation/widgets/forms_widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: double.infinity),
          Text(
            widget.title,
            style: context.titleLarge,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
          if (widget.message != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.message!,
              style: context.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 24),
          CustomTextFormField(
            enabled: !loading,
            keyboardType: widget.keyboardType,
            textCapitalization: widget.textCapitalization,
            focusNode: focusNode,
            textInputAction: TextInputAction.go,
            onFieldSubmitted: (value) {
              if (controller.text.trim().isNotEmpty) {
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
              child: CircularProgressIndicator(color: Colors.black),
            ),
            secondChild: ConstrainedBox(
              constraints: BoxConstraints(minWidth: context.width * 0.6),
              child: CustomFilledButton(
                label:
                    widget.aceptBottonText ??
                    AppLocalizations.of(context)!.accept,
                height: 50,
                color: widget.colorConfirmButton,
                onPressed: controller.text.trim().isNotEmpty
                    ? () async {
                        save();
                      }
                    : null,
              ),
            ),
            crossFadeState: !loading
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
          if (widget.showCancelOption) ...[
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: context.width * 0.6),
              child: CustomOutlinedButton(
                label:
                    widget.cancelBottonText ??
                    AppLocalizations.of(context)!.cancel,
                height: 50,
                color: widget.colorCancelButton,
                onPressed: loading
                    ? null
                    : () async {
                        context.pop();
                      },
              ),
            ),
          ],
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
    if (errorMessage == null) {
      context.pop();
    } else {
      loading = false;
      setState(() {});
    }
  }

  void check() {
    setState(() {
      if (controller.text.trim().isEmpty) {
        errorMessage = "Este campo no puede estar vacío";
      } else {
        errorMessage = null;
      }
    });
  }
}
