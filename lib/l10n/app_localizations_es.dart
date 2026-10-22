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

  @override
  String get errorType_paginationIndexOfBounds => 'No hay más elementos.';

  @override
  String get errorType_unknownError => 'Error desconocido.';

  @override
  String get errorType_error => 'Ha ocurrido un error.';

  @override
  String get errorType_createError => 'Error al crear el elemento.';

  @override
  String get errorType_alreadyExists => 'El elemento ya existe.';

  @override
  String get errorType_notFound => 'El elemento no existe.';

  @override
  String get errorType_updateOrDeleteViolatesForeignKey =>
      'Algún valor del elemento ya existe.';

  @override
  String get errorType_emptyFields => 'Los campos no pueden estar vacíos.';

  @override
  String get errorType_errorSaveFile => 'Error al guardar el archivo.';

  @override
  String get errorType_userNotActive => 'El usuario no está activo.';

  @override
  String get errorType_userIsBlocked => 'El usuario está bloqueado.';

  @override
  String get errorType_userOrPasswordIncorrect =>
      'Usuario o contraseña incorrectos.';

  @override
  String get errorType_unauthorized => 'No autorizado.';

  @override
  String get errorType_errorSendMail => 'Error al enviar el correo.';

  @override
  String get errorType_insufficientPermissions => 'Permisos insuficientes.';

  @override
  String get errorType_noFileUploaded => 'No se ha subido ningún archivo.';

  @override
  String get errorType_incorrectGoogleVerification =>
      'Verificación de Google incorrecta. ¿Seguro que iniciaste sesión con Google?';

  @override
  String get errorType_incorrectGoogleClientId =>
      'ID de cliente de Google incorrecto, no coincide con tu cuenta.';

  @override
  String get errorType_userDoesNotMeetRequirements =>
      'El usuario no cumple los requisitos. Verifique sus datos personales.';

  @override
  String get errorType_userNotConnected => 'El usuario no está conectado.';

  @override
  String get errorType_invalidForm => 'Formulario inválido.';

  @override
  String get errorType_errorCompressImage => 'Error al comprimir la imagen.';

  @override
  String get errorType_invalidField =>
      'El valor de uno de los campos no es válido.';

  @override
  String get errorType_serviceNotAvailable => 'El servicio no está disponible.';
}
