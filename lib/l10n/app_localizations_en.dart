// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

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

  @override
  String get errorType_paginationIndexOfBounds => 'No more items.';

  @override
  String get errorType_unknownError => 'Unknown error.';

  @override
  String get errorType_error => 'An error has occurred.';

  @override
  String get errorType_createError => 'Error creating the item.';

  @override
  String get errorType_alreadyExists => 'The item already exists.';

  @override
  String get errorType_notFound => 'The item does not exist.';

  @override
  String get errorType_updateOrDeleteViolatesForeignKey =>
      'Some value of the item already exists.';

  @override
  String get errorType_emptyFields => 'Fields cannot be empty.';

  @override
  String get errorType_errorSaveFile => 'Error saving the file.';

  @override
  String get errorType_userNotActive => 'The user is not active.';

  @override
  String get errorType_userIsBlocked => 'The user is blocked.';

  @override
  String get errorType_userOrPasswordIncorrect =>
      'Incorrect username or password.';

  @override
  String get errorType_unauthorized => 'Unauthorized.';

  @override
  String get errorType_errorSendMail => 'Error sending the email.';

  @override
  String get errorType_insufficientPermissions => 'Insufficient permissions.';

  @override
  String get errorType_noFileUploaded => 'No file has been uploaded.';

  @override
  String get errorType_incorrectGoogleVerification =>
      'Incorrect Google verification. Are you sure you signed in with Google?';

  @override
  String get errorType_incorrectGoogleClientId =>
      'Incorrect Google client ID, does not match your account.';

  @override
  String get errorType_userDoesNotMeetRequirements =>
      'The user does not meet the requirements. Verify your personal data.';

  @override
  String get errorType_userNotConnected => 'The user is not connected.';

  @override
  String get errorType_invalidForm => 'Invalid form.';

  @override
  String get errorType_errorCompressImage => 'Error compressing image.';

  @override
  String get errorType_invalidField =>
      'The value of one of the fields is not valid.';

  @override
  String get errorType_serviceNotAvailable => 'The service is not available.';
}
