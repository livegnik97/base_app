class ImagenPath {
  static String _defaultPath(String name) => 'assets/images/$name';

  /// Ruta a una imagen JPG de assets/images/
  static String imgJpg(String name) => _defaultPath("$name.jpg");

  /// Ruta a una imagen PNG de assets/images/
  static String imgPng(String name) => _defaultPath("$name.png");

  static const String placeholder = 'assets/images/placeholder.png';
}
