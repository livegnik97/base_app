import 'package:flutter/material.dart';
import 'package:base_app/core/constants/constants.dart';
import 'package:base_app/core/router/predictive_transitions.dart';
import 'package:base_app/core/theme/app_colors.dart';

class AppTheme {
  final bool isDark;
  DynamicSchemeVariant dynamicSchemeVariant;

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
    final colorScheme = isDarkMode ? _darkColorScheme : _lightColorScheme;
    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colorScheme.primary,
        dynamicSchemeVariant: DynamicSchemeVariant.monochrome,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        primary: colorScheme.primary,
        onPrimary: colorScheme.onPrimary,
        surface: colorScheme.surface,
        onSurface: colorScheme.onSurface,
        onSurfaceVariant: colorScheme.onSurfaceVariant,
        outline: colorScheme.outline,
        surfaceContainerLow: colorScheme.surfaceContainerLow,
        error: colorScheme.error,
        onError: colorScheme.onError,
      ),
      //* agregar para las transiciones entre las paginas
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: MultiTransicionPredictivaBuilder(),
          TargetPlatform.iOS: MultiTransicionPredictivaBuilder(),
          TargetPlatform.macOS: MultiTransicionPredictivaBuilder(),
          TargetPlatform.windows: MultiTransicionPredictivaBuilder(),
          TargetPlatform.linux: MultiTransicionPredictivaBuilder(),
          TargetPlatform.fuchsia: MultiTransicionPredictivaBuilder(),
        },
      ),
    );
    // final theme = ThemeData(useMaterial3: true, colorScheme: colorScheme);

    return theme.copyWith(
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: colorScheme.surfaceContainerLow,
      appBarTheme: theme.appBarTheme.copyWith(
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        filled: false,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        hintStyle: TextStyle(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constants.borderRadius),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          side: BorderSide(color: colorScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constants.borderRadius),
          ),
        ),
      ),
      cardTheme: theme.cardTheme.copyWith(
        color: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.borderRadius),
        ),
      ),
      tabBarTheme: theme.tabBarTheme.copyWith(
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicatorColor: colorScheme.primary,
      ),
      floatingActionButtonTheme: theme.floatingActionButtonTheme.copyWith(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 2,
      ),
      drawerTheme: theme.drawerTheme.copyWith(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(Constants.borderRadius),
          ),
        ),
      ),
      listTileTheme: theme.listTileTheme.copyWith(
        textColor: colorScheme.onSurface,
        iconColor: colorScheme.onSurfaceVariant,
      ),
      progressIndicatorTheme: theme.progressIndicatorTheme.copyWith(
        color: colorScheme.onSurface,
        linearTrackColor: Colors.transparent,
      ),
      switchTheme: theme.switchTheme.copyWith(
        thumbColor: WidgetStateColor.resolveWith((states) {
          final result = theme.switchTheme.thumbColor?.resolve(states);
          return result ?? theme.colorScheme.surface;
        }),
      ),
    );
  }
  // ThemeData _theme(bool isDarkMode) {
  //   final colorScheme = isDarkMode ? _darkColorScheme : _lightColorScheme;
  //   final theme = ThemeData(useMaterial3: true, colorScheme: colorScheme);

  //   return theme.copyWith(
  //     primaryColor: colorScheme.primary,
  //     scaffoldBackgroundColor: colorScheme.surface,
  //     appBarTheme: AppBarTheme(
  //       centerTitle: true,
  //       backgroundColor: colorScheme.surface,
  //       foregroundColor: colorScheme.onSurface,
  //       elevation: 0,
  //       scrolledUnderElevation: 0,
  //       iconTheme: IconThemeData(color: colorScheme.onSurface),
  //     ),
  //     inputDecorationTheme: InputDecorationTheme(
  //       filled: false,
  //       border: UnderlineInputBorder(
  //         borderSide: BorderSide(color: colorScheme.outline),
  //       ),
  //       enabledBorder: UnderlineInputBorder(
  //         borderSide: BorderSide(color: colorScheme.outline),
  //       ),
  //       focusedBorder: UnderlineInputBorder(
  //         borderSide: BorderSide(color: colorScheme.primary, width: 2),
  //       ),
  //       labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
  //       hintStyle: TextStyle(
  //         color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
  //       ),
  //     ),
  //     elevatedButtonTheme: ElevatedButtonThemeData(
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: colorScheme.primary,
  //         foregroundColor: colorScheme.onPrimary,
  //         elevation: 0,
  //         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(Constants.borderRadius),
  //         ),
  //       ),
  //     ),
  //     outlinedButtonTheme: OutlinedButtonThemeData(
  //       style: OutlinedButton.styleFrom(
  //         foregroundColor: colorScheme.onSurface,
  //         side: BorderSide(color: colorScheme.outline),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(Constants.borderRadius),
  //         ),
  //       ),
  //     ),
  //     cardTheme: CardThemeData(
  //       color: colorScheme.surfaceContainerLow,
  //       elevation: 0,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(Constants.borderRadius),
  //       ),
  //     ),
  //     tabBarTheme: TabBarThemeData(
  //       labelColor: colorScheme.primary,
  //       unselectedLabelColor: colorScheme.onSurfaceVariant,
  //       indicatorColor: colorScheme.primary,
  //     ),
  //     floatingActionButtonTheme: FloatingActionButtonThemeData(
  //       backgroundColor: colorScheme.primary,
  //       foregroundColor: colorScheme.onPrimary,
  //       elevation: 2,
  //     ),
  //     drawerTheme: DrawerThemeData(
  //       backgroundColor: colorScheme.surface,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.horizontal(
  //           right: Radius.circular(Constants.borderRadius),
  //         ),
  //       ),
  //     ),
  //     listTileTheme: ListTileThemeData(
  //       textColor: colorScheme.onSurface,
  //       iconColor: colorScheme.onSurfaceVariant,
  //     ),
  //     progressIndicatorTheme: ProgressIndicatorThemeData(
  //       color: colorScheme.onSurface,
  //       linearTrackColor: Colors.transparent,
  //     ),
  //   );
  // }

  static ColorScheme get _lightColorScheme => ColorScheme.light(
    primary: AppColors.lightAccent,
    onPrimary: Colors.white,
    surface: AppColors.lightSurface,
    onSurface: AppColors.lightOnSurface,
    onSurfaceVariant: AppColors.lightOnSurfaceVariant,
    outline: AppColors.lightOutline,
    surfaceContainerLow: AppColors.lightSurfaceContainer,
    error: AppColors.error,
    onError: Colors.white,
  );

  static ColorScheme get _darkColorScheme => ColorScheme.dark(
    primary: AppColors.darkAccent,
    onPrimary: AppColors.darkSurface,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkOnSurface,
    onSurfaceVariant: AppColors.darkOnSurfaceVariant,
    outline: AppColors.darkOutline,
    surfaceContainerLow: AppColors.darkSurfaceContainer,
    error: AppColors.error,
    onError: Colors.white,
  );
}
