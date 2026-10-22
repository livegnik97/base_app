import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:base_app/l10n/app_localizations.dart';

import 'inputs.dart';

// Define input validation errors
enum PhoneErrorInput { empty, format, personalValidation }

// Extend FormzInput and provide the input type and error type.
class PhoneInputValidator extends FormzInput<String, PhoneErrorInput> {
  RegExp get phoneRegExp {
    // Nuevo regex para números cubanos: +53 seguido de exactamente 8 dígitos
    //* Ejemplo:  RegExp(r'^\+53\d{8}$');
    String pattern = '^\\$prefix\\d{$maxLength}\$';
    // ignore: prefer_interpolation_to_compose_strings
    return RegExp(r'' + pattern + '');
  }

  final bool isRequired;
  final String prefix;
  final int maxLength;
  final PersonalValidation? personalValidation;

  // Call super.pure to represent an unmodified form input.
  const PhoneInputValidator.pure({
    String intialValue = '',
    this.isRequired = true,
    required this.prefix,
    required this.maxLength,
    this.personalValidation,
  }) : super.pure(intialValue);

  // Call super.dirty to represent a modified form input.
  const PhoneInputValidator.dirty(
    super.value, {
    this.isRequired = true,
    required this.prefix,
    required this.maxLength,
    this.personalValidation,
  }) : super.dirty();

  String? errorMessage(BuildContext context) {
    if (isValid || isPure) return null;
    if (displayError == PhoneErrorInput.empty) {
      return AppLocalizations.of(context)!.validForm_campoRequerido;
    }
    if (displayError == PhoneErrorInput.format) {
      return AppLocalizations.of(context)!.validForm_formatoIncorrecto;
    }
    if (displayError == PhoneErrorInput.personalValidation) {
      return personalValidation!(value).message ?? "Error";
    }
    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  PhoneErrorInput? validator(String value) {
    value = value.trim();
    if (value.isEmpty) {
      if (isRequired) {
        return PhoneErrorInput.empty;
      } else {
        return null;
      }
    }

    // Normalizar: eliminar espacios y guiones para validar solo dígitos y +
    final normalized = value.replaceAll(RegExp(r'[\s-]'), '');
    if (!phoneRegExp.hasMatch(normalized)) {
      return PhoneErrorInput.format;
    }

    if (personalValidation != null && !personalValidation!(value).isValid) {
      return PhoneErrorInput.personalValidation;
    }
    return null;
  }

  String get realValue => value.trim();
}
