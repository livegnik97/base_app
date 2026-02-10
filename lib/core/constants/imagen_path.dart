class ImagenPath {
  static String _defaultPath(String name) => 'assets/images/$name';
  static String _imgJpg(String name) => _defaultPath("$name.jpg");
  static String _imgPng(String name) => _defaultPath("$name.png");

  static const String placeholder = 'assets/images/placeholder.png';
}
