// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get accept => 'Aceptar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get updating => 'Actualizando';

  @override
  String get processing => 'Procesando';

  @override
  String get delete => 'Eliminar';

  @override
  String get validForm_campoRequerido => 'Campo requerido';

  @override
  String get validForm_formatoIncorrecto => 'Formato incorrecto';

  @override
  String validForm_longitud(Object cant) {
    return 'Debe poseer mínimo $cant caracteres';
  }

  @override
  String get validForm_invalid_char => 'Caracteres no válidos';

  @override
  String get validForm_confirmPassword => 'Debe coincidir con la contraseña';

  @override
  String get validForm_outRangeValue => 'Valor fuera de rango';

  @override
  String get validForm_notNegativeValue => 'No puede ser negativo';

  @override
  String get validForm_insecurePassword => 'Contraseña insegura';

  @override
  String get errorType_noConnection => 'No hay conexión a internet.';

  @override
  String get errorType_noLogin =>
      'Error al iniciar sesión. Revise su conexión a internet e intente nuevamente.';

  @override
  String get errorType_noAuth =>
      'Correo o contraseña incorrectos. Revise e intente nuevamente.';

  @override
  String get errorType_userNotFound => 'Usuario no encontrado.';

  @override
  String get errorType_noSendCode =>
      'No se pudo enviar el código. Revise su conexión a internet e intente nuevamente.';

  @override
  String get errorType_incorrectActivationCode =>
      'Código de activación incorrecto';

  @override
  String get selectLanguage => 'Seleccione el idioma';

  @override
  String get language => 'Lenguaje';

  @override
  String get languageEs => 'Español';

  @override
  String get languageEn => 'Inglés';

  @override
  String get selectLanguageDetails =>
      'Seleccione el idioma que deseas para trabajar en la aplicación. En los ajustes puedes volver a cambiarlo cuando quieras.';
}
