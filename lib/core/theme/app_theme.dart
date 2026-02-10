import 'package:flutter/material.dart';

class AppTheme {
  final bool isDark;
  DynamicSchemeVariant dynamicSchemeVariant;

  static final Color primaryBase = Color(0xFF030099);
  static final Color secondaryBase = Color(0xFFFF3700);
  static final Color tertiaryBase = Color(0xFFFFE11F);

  AppTheme({
    this.isDark = false,
    this.dynamicSchemeVariant = DynamicSchemeVariant.tonalSpot,
  });

  ThemeData theme({
    DynamicSchemeVariant dynamicSchemeVariant = DynamicSchemeVariant.tonalSpot,
  }) {
    this.dynamicSchemeVariant = dynamicSchemeVariant;
    return _theme(isDark);
  }

  ThemeData themeLight({
    DynamicSchemeVariant dynamicSchemeVariant = DynamicSchemeVariant.tonalSpot,
  }) {
    this.dynamicSchemeVariant = dynamicSchemeVariant;
    return _theme(false);
  }

  ThemeData themeDark({
    DynamicSchemeVariant dynamicSchemeVariant = DynamicSchemeVariant.tonalSpot,
  }) {
    this.dynamicSchemeVariant = dynamicSchemeVariant;
    return _theme(true);
  }

  ThemeData _theme(bool isDarkMode) {
    // final dynamicSchemeVariant = DynamicSchemeVariant.tonalSpot;
    // final dynamicSchemeVariant = DynamicSchemeVariant.neutral;
    // final dynamicSchemeVariant = DynamicSchemeVariant.rainbow;
    // final dynamicSchemeVariant = DynamicSchemeVariant.fruitSalad;
    // final dynamicSchemeVariant = DynamicSchemeVariant.expressive;
    // final dynamicSchemeVariant = DynamicSchemeVariant.vibrant;
    // final secondaryTheme = ThemeData(
    //   useMaterial3: true,
    //   colorScheme: ColorScheme.fromSeed(
    //     seedColor: secondaryBase,
    //     dynamicSchemeVariant: dynamicSchemeVariant,
    //     brightness: isDarkMode ? Brightness.dark : Brightness.light,
    //   ),
    // );
    // final tertiaryTheme = ThemeData(
    //   useMaterial3: true,
    //   colorScheme: ColorScheme.fromSeed(
    //     seedColor: tertiaryBase,
    //     dynamicSchemeVariant: dynamicSchemeVariant,
    //     brightness: isDarkMode ? Brightness.dark : Brightness.light,
    //   ),
    // );
    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBase,
        dynamicSchemeVariant: dynamicSchemeVariant,

        // primary: isDarkMode ? null : primaryBase,
        // secondary: secondaryTheme.colorScheme.primary,
        // tertiary: tertiaryTheme.colorScheme.primary,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        // secondaryContainer: secondaryTheme.colorScheme.primaryContainer,
        // onSecondary: secondaryTheme.colorScheme.onPrimary,
        // onSecondaryContainer: secondaryTheme.colorScheme.onPrimaryContainer,
        // tertiaryContainer: tertiaryTheme.colorScheme.primaryContainer,
        // onTertiary: tertiaryTheme.colorScheme.onPrimary,
        // onTertiaryContainer: tertiaryTheme.colorScheme.onPrimaryContainer,
      ),
    );

    return theme.copyWith(
      appBarTheme: const AppBarTheme(centerTitle: false),
      primaryColor: primaryBase,
      scaffoldBackgroundColor: theme.colorScheme.surfaceContainerLow,
    );
  }
}
