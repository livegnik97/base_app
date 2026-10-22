import 'package:auto_size_text/auto_size_text.dart';
import 'package:base_app/core/extensions/custom_context.dart';
import 'package:base_app/l10n/app_localizations.dart';
import 'package:base_app/presentation/widgets/buttons/custom_filled_button.dart';
import 'package:base_app/presentation/widgets/buttons/custom_text_button.dart';
import 'package:base_app/presentation/widgets/forms_widget/custom_phone_form_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:base_app/presentation/widgets/shared/custom_loading_widget.dart';
import 'package:phone_text_field/phone_text_field.dart';

class DialogConfirmWithPhoneField extends StatefulWidget {
  const DialogConfirmWithPhoneField({
    super.key,
    required this.title,
    required this.message,
    this.aceptBottonText,
    this.cancelBottonText,
    this.showCancelOption = true,
    required this.textFieldLabel,
    this.textFieldHint,
    this.initialValue,
    required this.onConfirm,
    this.showLoading = false,
    this.colorConfirmButton,
    this.colorCancelButton,
    this.canBeEmpty = false,
  });

  final String title;
  final String? message;
  final String? aceptBottonText;
  final String? cancelBottonText;
  final String? textFieldLabel;
  final String? textFieldHint;
  final bool showCancelOption;
  final String? initialValue;
  final Future<String?> Function(String value) onConfirm;
  final bool showLoading;
  final Color? colorConfirmButton;
  final Color? colorCancelButton;
  final bool canBeEmpty;

  @override
  State<DialogConfirmWithPhoneField> createState() =>
      _DialogConfirmWithPhoneFieldState();
}

class _DialogConfirmWithPhoneFieldState
    extends State<DialogConfirmWithPhoneField> {
  String? errorMessage;

  late PhoneNumber phone;

  bool loading = false;

  final focusNode = FocusNode();

  @override
  void initState() {
    phone = _parsePhone(widget.initialValue);
    Future.delayed(
      const Duration(milliseconds: 600),
      () => focusNode.requestFocus(),
    );
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  PhoneNumber _parsePhone(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return PhoneNumber.fromCompleteNumber(completeNumber: '+53');
    }
    try {
      return PhoneNumber.fromCompleteNumber(completeNumber: trimmed);
    } catch (_) {
      return PhoneNumber.fromCompleteNumber(completeNumber: '+53');
    }
  }

  bool get isFormValid {
    if (widget.canBeEmpty) return true;
    if (phone.number.trim().isEmpty) return false;
    try {
      return phone.isValidNumber();
    } catch (_) {
      return false;
    }
  }

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
          CustomPhoneFormField(
            enabled: !loading,
            focusNode: focusNode,
            initialValue: phone,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            isRequired: !widget.canBeEmpty,
            label: widget.textFieldLabel,
            hint: widget.textFieldHint,
            errorMessage: errorMessage,
            textInputAction: TextInputAction.go,
            onFieldSubmitted: (value) {
              if (isFormValid) {
                save();
              }
            },
            onChanged: (value) {
              phone = value;
              errorMessage = null;
              setState(() {});
            },
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
      widget.onConfirm.call(phone.completeNumber.trim());
      return;
    }
    try {
      focusNode.unfocus();
    } catch (_) {}
    loading = true;
    errorMessage = null;
    setState(() {});
    errorMessage = await widget.onConfirm.call(phone.completeNumber.trim());
    if (errorMessage == null && context.mounted) {
      // ignore: use_build_context_synchronously
      context.pop();
    } else {
      loading = false;
      setState(() {});
    }
  }
}
