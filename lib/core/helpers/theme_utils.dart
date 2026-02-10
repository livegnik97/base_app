import 'package:flutter/material.dart';

class ThemeUtils {
  static ThemeMode getThemeMode(int themeIndex) {
    switch (themeIndex) {
      case 0:
        return ThemeMode.system;
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static List<DynamicSchemeVariant> get dynamicSchemeVariants =>
      DynamicSchemeVariant.values;

  static List<String> get dynamicSchemeVariantsNames =>
      dynamicSchemeVariants.map((e) => e.name).toList();
}
