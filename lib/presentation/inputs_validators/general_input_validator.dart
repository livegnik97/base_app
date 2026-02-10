import 'package:base_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

import 'inputs.dart';

// Define input validation errors
enum GeneralErrorInput { empty, personalValidation }

// Extend FormzInput and provide the input type and error type.
class GeneralInputValidator extends FormzInput<String, GeneralErrorInput> {
  final bool isRequired;
  final PersonalValidation? personalValidation;

  // Call super.pure to represent an unmodified form input.
  const GeneralInputValidator.pure({
    this.isRequired = true,
    this.personalValidation,
  }) : super.pure('');

  // Call super.dirty to represent a modified form input.
  const GeneralInputValidator.dirty(
    super.value, {
    this.isRequired = true,
    this.personalValidation,
  }) : super.dirty();

  String? errorMessage(BuildContext context, [String? personalError]) {
    if (isValid || isPure) return null;
    if (displayError == GeneralErrorInput.empty) {
      return AppLocalizations.of(context)!.validForm_campoRequerido;
    }
    if (displayError == GeneralErrorInput.personalValidation) {
      return personalValidation!(value).message ?? "Error";
    }
    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  GeneralErrorInput? validator(String value) {
    value = value.trim();
    if (value.isEmpty) {
      if (isRequired) {
        return GeneralErrorInput.empty;
      } else {
        return null;
      }
    }
    if (personalValidation != null && !personalValidation!(value).isValid) {
      return GeneralErrorInput.personalValidation;
    }
    return null;
  }

  String get realValue => value.trim();
}
