import 'package:base_app/core/constants/constants.dart';
import 'package:base_app/core/extensions/custom_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? initialValue;
  final String? label;
  final String? labelTop;
  final String? hint;
  final String? errorMessage;
  final IconData? prefixIcon;
  final Widget? prefix;
  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final int? minLines;
  final int maxLines;
  final int? maxLength;
  final Widget? suffix;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final TextCapitalization textCapitalization;
  final VoidCallback? onEditingComplete;
  final List<TextInputFormatter>? inputFormatters;
  final Color? backgroundColor;

  const CustomTextFormField({
    super.key,
    this.controller,
    this.focusNode,
    this.initialValue,
    this.label,
    this.labelTop,
    this.hint,
    this.errorMessage,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.textInputAction,
    this.onFieldSubmitted,
    this.validator,
    this.prefix,
    this.prefixIcon,
    this.minLines,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.suffix,
    this.suffixIcon,
    this.textCapitalization = TextCapitalization.none,
    this.onEditingComplete,
    this.inputFormatters,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: BorderSide(color: context.surfaceContainerHighest),
      borderRadius: BorderRadius.circular(Constants.borderRadius),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelTop != null)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              labelTop!,
              style: context.labelLarge.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        Material(
          borderRadius: BorderRadius.circular(Constants.borderRadius),
          color: backgroundColor ?? context.surface,
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            initialValue: initialValue,
            enabled: enabled,
            readOnly: readOnly,
            minLines: minLines,
            maxLines: maxLines,
            maxLength: maxLength,
            onChanged: onChanged,
            validator: validator,
            textInputAction: textInputAction,
            onFieldSubmitted: onFieldSubmitted,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textCapitalization: textCapitalization,
            inputFormatters: inputFormatters,
            onEditingComplete: onEditingComplete,
            decoration: InputDecoration(
              prefix: prefix,
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: context.primary)
                  : null,
              enabledBorder: border,
              disabledBorder: border,
              focusedBorder: border,
              errorBorder: border.copyWith(
                borderSide: BorderSide(color: context.error),
              ),
              focusedErrorBorder: border.copyWith(
                borderSide: BorderSide(color: context.error),
              ),
              label: label != null ? Text(label!) : null,
              hintText: hint,
              errorText: errorMessage,
              focusColor: context.primary,
              suffix: suffix,
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}
