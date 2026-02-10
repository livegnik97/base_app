import 'package:base_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

import 'inputs.dart';

// Define input validation errors
enum DecimalErrorInput { empty, format, outRange, personalValidation }

// Extend FormzInput and provide the input type and error type.
class DecimalInputValidator extends FormzInput<String, DecimalErrorInput> {
  final bool isRequired;
  final PersonalValidation? personalValidation;
  final double? minValue;
  final double? maxValue;

  // Call super.pure to represent an unmodified form input.
  const DecimalInputValidator.pure({
    this.isRequired = true,
    this.personalValidation,
    this.minValue,
    this.maxValue,
  }) : super.pure("");

  // Call super.dirty to represent a modified form input.
  const DecimalInputValidator.dirty(
    super.value, {
    this.isRequired = true,
    this.personalValidation,
    this.minValue,
    this.maxValue,
  }) : super.dirty();

  String? errorMessage(BuildContext context, [String? personalError]) {
    if (isValid || isPure) return null;
    if (displayError == DecimalErrorInput.empty) {
      return AppLocalizations.of(context)!.validForm_campoRequerido;
    }
    if (displayError == DecimalErrorInput.format) {
      return AppLocalizations.of(context)!.validForm_formatoIncorrecto;
    }
    if (displayError == DecimalErrorInput.outRange) {
      return AppLocalizations.of(context)!.validForm_outRangeValue;
    }
    if (displayError == DecimalErrorInput.personalValidation) {
      return personalValidation!(value).message ?? "Error";
    }
    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  DecimalErrorInput? validator(String value) {
    value = value.trim();
    if (value.isEmpty) {
      if (isRequired) {
        return DecimalErrorInput.empty;
      } else {
        return null;
      }
    }
    final isDouble = double.tryParse(value);
    if (isDouble == null) return DecimalErrorInput.format;
    if (minValue != null && isDouble < minValue!) {
      return DecimalErrorInput.outRange;
    }
    if (maxValue != null && isDouble > maxValue!) {
      return DecimalErrorInput.outRange;
    }
    if (personalValidation != null && !personalValidation!(value).isValid) {
      return DecimalErrorInput.personalValidation;
    }
    return null;
  }

  double get realValue => double.parse(value.trim());
}
