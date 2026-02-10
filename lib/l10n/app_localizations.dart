import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Aceptar'**
  String get accept;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @updating.
  ///
  /// In en, this message translates to:
  /// **'Actualizando'**
  String get updating;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Procesando'**
  String get processing;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// No description provided for @validForm_campoRequerido.
  ///
  /// In en, this message translates to:
  /// **'Campo requerido'**
  String get validForm_campoRequerido;

  /// No description provided for @validForm_formatoIncorrecto.
  ///
  /// In en, this message translates to:
  /// **'Formato incorrecto'**
  String get validForm_formatoIncorrecto;

  /// No description provided for @validForm_longitud.
  ///
  /// In en, this message translates to:
  /// **'Debe poseer mínimo {cant} caracteres'**
  String validForm_longitud(Object cant);

  /// No description provided for @validForm_invalid_char.
  ///
  /// In en, this message translates to:
  /// **'Caracteres no válidos'**
  String get validForm_invalid_char;

  /// No description provided for @validForm_confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Debe coincidir con la contraseña'**
  String get validForm_confirmPassword;

  /// No description provided for @validForm_outRangeValue.
  ///
  /// In en, this message translates to:
  /// **'Valor fuera de rango'**
  String get validForm_outRangeValue;

  /// No description provided for @validForm_notNegativeValue.
  ///
  /// In en, this message translates to:
  /// **'No puede ser negativo'**
  String get validForm_notNegativeValue;

  /// No description provided for @validForm_insecurePassword.
  ///
  /// In en, this message translates to:
  /// **'Contraseña insegura'**
  String get validForm_insecurePassword;

  /// No description provided for @errorType_noConnection.
  ///
  /// In en, this message translates to:
  /// **'No hay conexión a internet.'**
  String get errorType_noConnection;

  /// No description provided for @errorType_noLogin.
  ///
  /// In en, this message translates to:
  /// **'Error al iniciar sesión. Revise su conexión a internet e intente nuevamente.'**
  String get errorType_noLogin;

  /// No description provided for @errorType_noAuth.
  ///
  /// In en, this message translates to:
  /// **'Correo o contraseña incorrectos. Revise e intente nuevamente.'**
  String get errorType_noAuth;

  /// No description provided for @errorType_userNotFound.
  ///
  /// In en, this message translates to:
  /// **'Usuario no encontrado.'**
  String get errorType_userNotFound;

  /// No description provided for @errorType_noSendCode.
  ///
  /// In en, this message translates to:
  /// **'No se pudo enviar el código. Revise su conexión a internet e intente nuevamente.'**
  String get errorType_noSendCode;

  /// No description provided for @errorType_incorrectActivationCode.
  ///
  /// In en, this message translates to:
  /// **'Código de activación incorrecto'**
  String get errorType_incorrectActivationCode;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Seleccione el idioma'**
  String get selectLanguage;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Lenguaje'**
  String get language;

  /// No description provided for @languageEs.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageEs;

  /// No description provided for @languageEn.
  ///
  /// In en, this message translates to:
  /// **'Inglés'**
  String get languageEn;

  /// No description provided for @selectLanguageDetails.
  ///
  /// In en, this message translates to:
  /// **'Seleccione el idioma que deseas para trabajar en la aplicación. En los ajustes puedes volver a cambiarlo cuando quieras.'**
  String get selectLanguageDetails;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
