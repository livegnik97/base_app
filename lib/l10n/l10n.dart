import 'package:base_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class L10n {
  static final all = [const Locale('es'), const Locale('en')];

  static String getFlag(String code) {
    switch (code) {
      case 'es':
        return '🇪🇸';
      case 'en':
        return '🇺🇸';
      default:
        return '🇪🇸';
    }
  }

  static String getLanguageLabel(BuildContext context, String code) {
    switch (code) {
      case 'es':
        return AppLocalizations.of(context)!.languageEs;
      case 'en':
        return AppLocalizations.of(context)!.languageEn;
      default:
        return AppLocalizations.of(context)!.languageEs;
    }
  }
}

/*

En los archivos .arb

- con {algo} se envían parámetros
- con @delante se explica de que va ese texto, no lleva traducción

{
    "greeting": "Hola",
    "language": "Español",
    "@language": {
        "description": "El actual lenguaje"
    },
    "hello": "Hola {username}"
}
*/
