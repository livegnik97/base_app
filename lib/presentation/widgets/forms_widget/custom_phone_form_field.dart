import 'package:base_app/core/constants/constants.dart';
import 'package:base_app/core/extensions/color_extension.dart';
import 'package:base_app/core/extensions/custom_context.dart';
import 'package:flutter/material.dart';
import 'package:phone_text_field/phone_text_field.dart';

class CustomPhoneFormField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? initialCountryCode;
  final PhoneNumber? initialValue;
  final String? label;
  final String? labelTop;
  final String? hint;
  final String? errorMessage;
  final IconData? prefixIcon;
  final Widget? prefix;
  final bool enabled;
  final bool isRequired;
  final Widget? suffix;
  final Widget? suffixIcon;
  final ValueChanged<PhoneNumber>? onChanged;
  final Color? backgroundColor;
  final AutovalidateMode autovalidateMode;
  final List<String>? countries;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;

  const CustomPhoneFormField({
    super.key,
    this.controller,
    this.focusNode,
    this.initialCountryCode,
    this.initialValue,
    this.isRequired = true,
    this.label,
    this.labelTop,
    this.hint,
    this.errorMessage,
    this.onChanged,
    this.prefix,
    this.prefixIcon,
    this.enabled = true,
    this.suffix,
    this.suffixIcon,
    this.backgroundColor,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.countries,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: BorderSide(color: context.primary.withOpacity2(0.5)),
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
          child: PhoneTextField(
            initialCountryCode: initialValue?.countryCode ?? initialCountryCode,
            initialValue: initialValue?.completeNumber,
            controller: controller,
            focusNode: focusNode,
            enabled: enabled,
            onChanged: onChanged,
            isRequired: isRequired,
            textInputAction: textInputAction,
            onSubmit: onFieldSubmitted,
            autovalidateMode: autovalidateMode,
            dialogTitle: 'Seleccionar País',
            invalidNumberMessage: 'Número de teléfono no válido',
            countries: countries,
            decoration: InputDecoration(
              prefix: prefix,
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: context.onSurfaceVariant)
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
              contentPadding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
