import 'package:base_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

import 'inputs.dart';

// Define input validation errors
enum NumberErrorInput { empty, format, outRange, personalValidation }

// Extend FormzInput and provide the input type and error type.
class NumberInputValidator extends FormzInput<String, NumberErrorInput> {
  final bool isRequired;
  final PersonalValidation? personalValidation;
  final int? minValue;
  final int? maxValue;

  // Call super.pure to represent an unmodified form input.
  const NumberInputValidator.pure({
    this.isRequired = true,
    this.personalValidation,
    this.minValue,
    this.maxValue,
  }) : super.pure("");

  // Call super.dirty to represent a modified form input.
  const NumberInputValidator.dirty(
    super.value, {
    this.isRequired = true,
    this.personalValidation,
    this.minValue,
    this.maxValue,
  }) : super.dirty();

  String? errorMessage(BuildContext context, [String? personalError]) {
    if (isValid || isPure) return null;
    if (displayError == NumberErrorInput.empty) {
      return AppLocalizations.of(context)!.validForm_campoRequerido;
    }
    if (displayError == NumberErrorInput.format) {
      return AppLocalizations.of(context)!.validForm_formatoIncorrecto;
    }
    if (displayError == NumberErrorInput.outRange) {
      return AppLocalizations.of(context)!.validForm_outRangeValue;
    }
    if (displayError == NumberErrorInput.personalValidation) {
      return personalValidation!(value).message ?? "Error";
    }
    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  NumberErrorInput? validator(String value) {
    value = value.trim();
    if (value.isEmpty) {
      if (isRequired) {
        return NumberErrorInput.empty;
      } else {
        return null;
      }
    }
    final isInteger = int.tryParse(value);
    if (isInteger == null) return NumberErrorInput.format;
    if (minValue != null && isInteger < minValue!) {
      return NumberErrorInput.outRange;
    }
    if (maxValue != null && isInteger > maxValue!) {
      return NumberErrorInput.outRange;
    }
    if (personalValidation != null && !personalValidation!(value).isValid) {
      return NumberErrorInput.personalValidation;
    }
    return null;
  }

  int get realValue => int.parse(value.trim());
}
