import 'package:flutter/material.dart';

/// Colores nombrados para el diseño base ERP: acentos negros, diseño limpio.
abstract class AppColors {
  // Modo claro
  static const Color lightSurface = Color(0xFFFAFAFA);
  static const Color lightSurfaceContainer = Color(0xFFF5F5F5);
  static const Color lightOnSurface = Color(0xFF1A1A1A);
  static const Color lightOnSurfaceVariant = Color(0xFF757575);
  static const Color lightOutline = Color(0xFFE0E0E0);
  static const Color lightAccent = Color(0xFF000000);

  // Modo oscuro
  static const Color darkSurface = Color(0xFF121212);
  static const Color darkSurfaceContainer = Color(0xFF1E1E1E);
  static const Color darkOnSurface = Color(0xFFE8E8E8);
  static const Color darkOnSurfaceVariant = Color(0xFFB0B0B0);
  static const Color darkOutline = Color(0xFF3A3A3A);
  static const Color darkAccent = Color(0xFFFFFFFF);

  // Comunes
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF9A825);
  static const Color error = Color(0xFFC62828);
}
