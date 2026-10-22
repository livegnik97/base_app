part of 'my_shared.dart';

class MySharedConstants {
  static String get accessToken => "accessToken";
  static String get userId => "userId";
  static String get userData => "userData";
  static String get notificationPayload => "notificationPayload";

  /*
  themeModeSelect
  0 - ThemeMode.system
  1 - ThemeMode.light
  2 - ThemeMode.dark
  */
  static String get themeModeSelect => "themeModeSelect";

  /*
  languageSelect
  es - Español
  en - Inglés
  */
  static String get languageSelect => "languageSelect";

  /*
  lastMainRoute
  Guarda la última ruta principal visitada (ej: /app/home)
  */
  static String get lastMainRoute => "lastMainRoute";

  /*
  onboardingCompleted
  Indica si el usuario ya vio el onboarding al menos una vez.
  */
  static String get onboardingCompleted => "onboardingCompleted";
}
