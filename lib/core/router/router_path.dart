// ignore_for_file: non_constant_identifier_names, constant_identifier_names

/// Mapa de rutas estáticas (sin parámetros) → nombre legible.
/// Orden idéntico al de los archivos en `routes/`.
class RouterPath {
  static const Map<String, String> routeNames = {
    //* auth
    '/login': 'Iniciar sesión',
    '/forgot_password': 'Recuperar contraseña',

    //* home
    '/home': 'Inicio',

    //* settings
    '/settings': 'Configuración',
    '/change_password': 'Cambiar contraseña',
    '/report': 'Reporte',
    '/edit_profile': 'Editar perfil',

    //* utility
    '/crop_image': 'Recortar imagen',
  };

  //* splash
  static const String SPLASH_PAGE = '/';

  //* auth_routes
  static const String LOGIN_PAGE = '/login';
  static const String FORGOT_PASSWORD_PAGE = '/forgot_password';

  //* home_routes
  static const String HOME_PAGE = '/home';

  //* settings_routes
  static const String SETTINGS_PAGE = '/settings';
  static const String CHANGE_PASSWORD_PAGE = '/change_password';
  static const String REPORT_PAGE = '/report';
  static const String EDIT_PROFILE_PAGE = '/edit_profile';

  //* utility_routes
  static const String CROP_IMAGE_PAGE = '/crop_image';

  //* helpers
  /// Obtener nombre de ruta por path
  static String getRouteName(String path) {
    if (routeNames.containsKey(path)) {
      return routeNames[path]!;
    }
    // Check dynamic routes with parameters
    for (final entry in routeNames.entries) {
      final pattern = entry.key.replaceAll(
        RegExp(r':[A-Za-z_0-9]+'),
        r'([^/]+)',
      );
      final regex = RegExp('^$pattern\$');
      if (regex.hasMatch(path)) {
        return entry.value;
      }
    }
    return 'Pantalla Anterior';
  }
}
