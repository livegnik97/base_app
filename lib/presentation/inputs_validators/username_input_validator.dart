import 'package:base_app/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';

import 'inputs.dart';

// Define input validation errors
enum UsernameErrorInput { empty, format, personalValidation }

// Extend FormzInput and provide the input type and error type.
class UsernameInputValidator extends FormzInput<String, UsernameErrorInput> {
  static bool isValidUsername(String value) {
    if (!RegExp(r'^[a-z]+$').hasMatch(value[0]) || value.length < 3) {
      return false;
    }
    for (var c in value.characters) {
      if (c == "_") continue;
      if (RegExp(r'^[a-z]+$').hasMatch(c)) continue;
      if (RegExp(r'^[0-9]+$').hasMatch(c)) continue;

      return false;
    }
    return true;
  }

  final bool isRequired;
  final PersonalValidation? personalValidation;

  // Call super.pure to represent an unmodified form input.
  const UsernameInputValidator.pure({
    this.isRequired = true,
    this.personalValidation,
  }) : super.pure('');

  // Call super.dirty to represent a modified form input.
  const UsernameInputValidator.dirty(
    super.value, {
    this.isRequired = true,
    this.personalValidation,
  }) : super.dirty();

  String? errorMessage(BuildContext context) {
    if (isValid || isPure) return null;
    if (displayError == UsernameErrorInput.empty) {
      return AppLocalizations.of(context)!.validForm_campoRequerido;
    }
    if (displayError == UsernameErrorInput.format) {
      return AppLocalizations.of(context)!.validForm_formatoIncorrecto;
    }
    if (displayError == UsernameErrorInput.personalValidation) {
      return personalValidation!(value).message ?? "Error";
    }
    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  UsernameErrorInput? validator(String value) {
    value = value.trim();
    if (value.isEmpty) {
      if (isRequired) {
        return UsernameErrorInput.empty;
      } else {
        return null;
      }
    }
    if (!isValidUsername(value)) return UsernameErrorInput.format;
    if (personalValidation != null && !personalValidation!(value).isValid) {
      return UsernameErrorInput.personalValidation;
    }
    return null;
  }

  String get realValue => value.trim();
}
