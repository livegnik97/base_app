import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

enum AccountErrorInput { empty, format }

class AccountInputValidator extends FormzInput<String, AccountErrorInput> {
  // Regex para validar formato de tarjeta:
  // - Permite dígitos, espacios y guiones
  // - Después de normalizar (eliminar espacios/guiones), debe tener entre 13 y 19 dígitos
  static final RegExp _cardCleanRegex = RegExp(r'^[\d\s-]+$');
  static const int minLength = 13;
  static const int maxLength = 19;

  final bool isRequired;

  const AccountInputValidator.pure({
    String intialValue = '',
    this.isRequired = true,
  }) : super.pure(intialValue);

  const AccountInputValidator.dirty(super.value, {this.isRequired = true})
    : super.dirty();

  String? errorMessage(BuildContext context) {
    if (isValid || isPure) return null;
    if (displayError == AccountErrorInput.empty) {
      return 'La cuenta es obligatoria'; // Podrías usar AppLocalizations
    }
    if (displayError == AccountErrorInput.format) {
      return 'Formato de tarjeta inválido';
    }
    return null;
  }

  @override
  AccountErrorInput? validator(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return isRequired ? AccountErrorInput.empty : null;
    }

    // Verificar que solo contenga dígitos, espacios o guiones
    if (!_cardCleanRegex.hasMatch(trimmed)) {
      return AccountErrorInput.format;
    }

    // Normalizar: eliminar espacios y guiones
    final normalized = trimmed.replaceAll(RegExp(r'[\s-]'), '');

    // Verificar que solo sean dígitos
    if (!RegExp(r'^\d+$').hasMatch(normalized)) {
      return AccountErrorInput.format;
    }

    // Verificar longitud
    if (normalized.length < minLength || normalized.length > maxLength) {
      return AccountErrorInput.format;
    }

    // Opcional: implementar algoritmo de Luhn aquí si se desea mayor validación
    // if (!isValidLuhn(normalized)) return AccountErrorInput.format;

    return null;
  }

  String get realValue => value.trim();
}
