// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*
  MODO DE USO
  En cualquier parte donde tengas acceso al contexto puedes hacer uso de todos estos get
  Ejemplo:
  - context.colorScheme.primary
  - context.primary
  - context.size.width
  - context.width
  - context.isDarkMode
*/

extension CustomContext on BuildContext {
  //* Colors
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  //* Primary Colors
  Color get primary => colorScheme.primary;
  Color get onPrimary => colorScheme.onPrimary;
  Color get primaryContainer => colorScheme.primaryContainer;
  Color get onPrimaryContainer => colorScheme.onPrimaryContainer;

  //* Primary Fixed Colors
  Color get primaryFixed => colorScheme.primaryFixed;
  Color get primaryFixedDim => colorScheme.primaryFixedDim;
  Color get onPrimaryFixed => colorScheme.onPrimaryFixed;
  Color get onPrimaryFixedVariant => colorScheme.onPrimaryFixedVariant;

  //* Secondary Colors
  Color get secondary => colorScheme.secondary;
  Color get onSecondary => colorScheme.onSecondary;
  Color get secondaryContainer => colorScheme.secondaryContainer;
  Color get onSecondaryContainer => colorScheme.onSecondaryContainer;

  //* Secondary Fixed Colors
  Color get secondaryFixed => colorScheme.secondaryFixed;
  Color get secondaryFixedDim => colorScheme.secondaryFixedDim;
  Color get onSecondaryFixed => colorScheme.onSecondaryFixed;
  Color get onSecondaryFixedVariant => colorScheme.onSecondaryFixedVariant;

  //* Tertiary Colors
  Color get tertiary => colorScheme.tertiary;
  Color get onTertiary => colorScheme.onTertiary;
  Color get tertiaryContainer => colorScheme.tertiaryContainer;
  Color get onTertiaryContainer => colorScheme.onTertiaryContainer;

  //* Tertiary Fixed Colors
  Color get tertiaryFixed => colorScheme.tertiaryFixed;
  Color get tertiaryFixedDim => colorScheme.tertiaryFixedDim;
  Color get onTertiaryFixed => colorScheme.onTertiaryFixed;
  Color get onTertiaryFixedVariant => colorScheme.onTertiaryFixedVariant;

  //* Error Colors
  Color get error => colorScheme.error;
  Color get onError => colorScheme.onError;
  Color get errorContainer => colorScheme.errorContainer;
  Color get onErrorContainer => colorScheme.onErrorContainer;

  //* Surface Colors
  Color get surface => colorScheme.surface;
  Color get onSurface => colorScheme.onSurface;
  Color get onSurfaceVariant => colorScheme.onSurfaceVariant;
  Color get surfaceContainerLowest => colorScheme.surfaceContainerLowest;
  Color get surfaceContainerLow => colorScheme.surfaceContainerLow;
  Color get surfaceContainer => colorScheme.surfaceContainer;
  Color get surfaceContainerHigh => colorScheme.surfaceContainerHigh;
  Color get surfaceContainerHighest => colorScheme.surfaceContainerHighest;
  Color get surfaceTint => colorScheme.surfaceTint;
  Color get surfaceDim => colorScheme.surfaceDim;
  Color get surfaceBright => colorScheme.surfaceBright;

  //* Inverse Colors
  Color get inversePrimary => colorScheme.inversePrimary;
  Color get inverseSurface => colorScheme.inverseSurface;
  Color get onInverseSurface => colorScheme.onInverseSurface;

  //* Others Colors
  Color get scrim => colorScheme.scrim;
  Color get shadow => colorScheme.shadow;
  Color get outline => colorScheme.outline;
  Color get outlineVariant => colorScheme.outlineVariant;

  //* Brightness
  Brightness get brightness => colorScheme.brightness;
  bool get isLightMode => brightness == Brightness.light;
  bool get isDarkMode => brightness == Brightness.dark;

  //* Size
  Size get size => MediaQuery.sizeOf(this);
  double get width => size.width;
  double get height => size.height;

  //* TextTheme
  TextTheme get textTheme => Theme.of(this).textTheme; //Weight  Size  Spacing
  TextStyle get displayLarge => textTheme.displayLarge!; //57      64    0
  TextStyle get displayMedium => textTheme.displayMedium!; //45      52    0
  TextStyle get displaySmall => textTheme.displaySmall!; //36      44    0
  TextStyle get headlineLarge => textTheme.headlineLarge!; //32      40    0
  TextStyle get headlineMedium => textTheme.headlineMedium!; //28      36    0
  TextStyle get headlineSmall => textTheme.headlineSmall!; //24      32    0
  TextStyle get titleLarge => textTheme.titleLarge!; //22      28    0
  TextStyle get titleMedium => textTheme.titleMedium!; //16      24    0.15
  TextStyle get titleSmall => textTheme.titleSmall!; //14      20    0.1
  TextStyle get labelLarge => textTheme.labelLarge!; //14      20    0.1
  TextStyle get labelMedium => textTheme.labelMedium!; //12      16    0.5
  TextStyle get labelSmall => textTheme.labelSmall!; //11      16    0.5
  TextStyle get bodyLarge => textTheme.bodyLarge!; //16      24    0.15
  TextStyle get bodyMedium => textTheme.bodyMedium!; //14      20    0.25
  TextStyle get bodySmall => textTheme.bodySmall!; //12      16    0.4

  //* Position Global from current widget
  Rect? get currentWidgetPosition {
    final renderObject = findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);
      return renderObject!.paintBounds.shift(offset);
    } else {
      return null;
    }
  }

  //* Width and Height from current widget
  double get currentWidgetWidth => currentWidgetPosition?.width ?? 0;
  double get currentWidgetHeight => currentWidgetPosition?.height ?? 0;

  //* ViewInsets, para poner padding en los dialogs para que suban cuando sale el teclado
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  // //* Get all color scheme widget
  Widget get getAllColorMostDetailsWidget {
    Map<String, Color> primaryColors = {
      //* Primary Colors
      "primary": primary,
      "onPrimary": onPrimary,
      "primaryContainer": primaryContainer,
      "onPrimaryContainer": onPrimaryContainer,
    };
    Map<String, Color> primaryFixedColors = {
      //* Primary Fixed Colors
      "primaryFixed": primaryFixed,
      "primaryFixedDim": primaryFixedDim,
      "onPrimaryFixed": onPrimaryFixed,
      "onPrimaryFixedVariant": onPrimaryFixedVariant,
    };
    Map<String, Color> secondaryColors = {
      //* Secondary Colors
      "secondary": secondary,
      "onSecondary": onSecondary,
      "secondaryContainer": secondaryContainer,
      "onSecondaryContainer": onSecondaryContainer,
    };
    Map<String, Color> secondaryFixedColors = {
      //* Secondary Fixed Colors
      "secondaryFixed": secondaryFixed,
      "secondaryFixedDim": secondaryFixedDim,
      "onSecondaryFixed": onSecondaryFixed,
      "onSecondaryFixedVariant": onSecondaryFixedVariant,
    };
    Map<String, Color> tertiaryColors = {
      //* Tertiary Colors
      "tertiary": tertiary,
      "onTertiary": onTertiary,
      "tertiaryContainer": tertiaryContainer,
      "onTertiaryContainer": onTertiaryContainer,
    };
    Map<String, Color> tertiaryFixedColors = {
      //* Tertiary Fixed Colors
      "tertiaryFixed": tertiaryFixed,
      "tertiaryFixedDim": tertiaryFixedDim,
      "onTertiaryFixed": onTertiaryFixed,
      "onTertiaryFixedVariant": onTertiaryFixedVariant,
    };
    Map<String, Color> errorColors = {
      //* Error Colors
      "error": error,
      "onError": onError,
      "errorContainer": errorContainer,
      "onErrorContainer": onErrorContainer,
    };
    Map<String, Color> surfaceColors = {
      //* Surface Colors
      "surfaceDim": surfaceDim,
      "surface": surface,
      "surfaceBright": surfaceBright,

      "surfaceContainerLowest": surfaceContainerLowest,
      "surfaceContainerLow": surfaceContainerLow,
      "surfaceContainer": surfaceContainer,
      "surfaceContainerHigh": surfaceContainerHigh,
      "surfaceContainerHighest": surfaceContainerHighest,

      "onSurface": onSurface,
      "onSurfaceVariant": onSurfaceVariant,
      "surfaceTint": surfaceTint,
    };
    Map<String, Color> inverseColors = {
      //* Inverse Colors
      "inversePrimary": inversePrimary,
      "inverseSurface": inverseSurface,
      "onInverseSurface": onInverseSurface,
    };
    Map<String, Color> othersColors = {
      //* Others Colors
      "scrim": scrim,
      "shadow": shadow,
      "outline": outline,
      "outlineVariant": outlineVariant,
    };

    void copyValue(String colorCode) {
      Clipboard.setData(ClipboardData(text: colorCode));
      ScaffoldMessenger.of(this)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(
              "Color $colorCode copiado al portapapeles",
              style: TextStyle(color: onSecondaryContainer),
            ),
            backgroundColor: secondaryContainer,
          ),
        );
    }

    Widget item({
      required MapEntry<String, Color> entry,
      required Color textColor,
    }) {
      return GestureDetector(
        onTap: () => copyValue(
          "#${entry.value.toARGB32().toRadixString(16).padLeft(8, '0')}",
        ),
        child: Container(
          width: double.infinity,
          color: entry.value,
          padding: const EdgeInsets.all(12),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(entry.key, style: TextStyle(color: textColor)),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "#${entry.value.toARGB32().toRadixString(16).padLeft(8, '0')}",
                  style: TextStyle(color: textColor),
                ),
              ),
            ],
          ),
        ),
      );
    }

    //* Primary, Secondary, Tertiary, Error
    Widget sectionType1(Map<String, Color> colors) {
      int index = 0;
      final textColors = colors.values.toList();
      textColors.insert(0, textColors[1]);
      textColors.removeAt(2);
      textColors.insert(2, textColors[3]);
      textColors.removeAt(4);
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ...colors.entries.map((entry) {
              return item(entry: entry, textColor: textColors[index++]);
            }),
          ],
        ),
      );
    }

    //* Primary Fixed, Secondary Fixed, Tertiary Fixed
    Widget sectionType2(Map<String, Color> colors) {
      int index = 0;
      final textColors = colors.values.toList();
      textColors.insert(0, textColors[2]);
      textColors.removeAt(3);
      textColors.insert(1, textColors[3]);
      textColors.removeAt(4);
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                ...colors.entries.toList().sublist(0, 2).map((entry) {
                  return Expanded(
                    child: item(entry: entry, textColor: textColors[index++]),
                  );
                }),
              ],
            ),
            ...colors.entries.toList().sublist(2).map((entry) {
              return item(entry: entry, textColor: textColors[index++]);
            }),
          ],
        ),
      );
    }

    //* Inverse
    Widget sectionType3(Map<String, Color> colors) {
      int index = 0;
      final textColors = colors.values.toList();
      textColors.insert(1, textColors[2]);
      textColors.removeAt(3);
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ...colors.entries.map((entry) {
              if (index == 0) {
                index++;
                return item(entry: entry, textColor: primary);
              }
              return item(entry: entry, textColor: textColors[index++]);
            }),
          ],
        ),
      );
    }

    //* Others
    Widget sectionType4(Map<String, Color> colors) {
      int index = 0;
      final textColors = colors.values.toList();
      textColors.insert(2, textColors[3]);
      textColors.removeAt(4);
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                ...colors.entries.toList().sublist(0, 2).map((entry) {
                  index++;
                  return Expanded(
                    child: item(entry: entry, textColor: onSecondary),
                  );
                }),
              ],
            ),
            Row(
              children: <Widget>[
                ...colors.entries.toList().sublist(2).map((entry) {
                  return Expanded(
                    child: item(entry: entry, textColor: textColors[index++]),
                  );
                }),
              ],
            ),
          ],
        ),
      );
    }

    Widget surfaceSection() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                ...surfaceColors.entries.toList().sublist(0, 3).map((entry) {
                  return Expanded(
                    child: item(entry: entry, textColor: onSurface),
                  );
                }),
              ],
            ),
            ...surfaceColors.entries.toList().sublist(3, 8).map((entry) {
              return item(entry: entry, textColor: onSurface);
            }),
            Row(
              children: <Widget>[
                ...surfaceColors.entries.toList().sublist(8, 10).map((entry) {
                  return Expanded(
                    child: item(entry: entry, textColor: surface),
                  );
                }),
              ],
            ),
            ...surfaceColors.entries.toList().sublist(10).map((entry) {
              return item(entry: entry, textColor: surface);
            }),
          ],
        ),
      );
    }

    return Column(
      children: <Widget>[
        sectionType1(primaryColors),
        sectionType1(secondaryColors),
        sectionType1(tertiaryColors),
        sectionType1(errorColors),

        surfaceSection(),

        sectionType2(primaryFixedColors),
        sectionType2(secondaryFixedColors),
        sectionType2(tertiaryFixedColors),

        sectionType3(inverseColors),
        sectionType4(othersColors),
      ],
    );
  }

  Widget get getAllColorWidget {
    Map<String, Color> colors = {
      //* Primary Colors
      "primary": primary,
      "onPrimary": onPrimary,
      "primaryContainer": primaryContainer,
      "onPrimaryContainer": onPrimaryContainer,

      //* Primary Fixed Colors
      "primaryFixed": primaryFixed,
      "primaryFixedDim": primaryFixedDim,
      "onPrimaryFixed": onPrimaryFixed,
      "onPrimaryFixedVariant": onPrimaryFixedVariant,

      //* Secondary Colors
      "secondary": secondary,
      "onSecondary": onSecondary,
      "secondaryContainer": secondaryContainer,
      "onSecondaryContainer": onSecondaryContainer,

      //* Secondary Fixed Colors
      "secondaryFixed": secondaryFixed,
      "secondaryFixedDim": secondaryFixedDim,
      "onSecondaryFixed": onSecondaryFixed,
      "onSecondaryFixedVariant": onSecondaryFixedVariant,

      //* Tertiary Colors
      "tertiary": tertiary,
      "onTertiary": onTertiary,
      "tertiaryContainer": tertiaryContainer,
      "onTertiaryContainer": onTertiaryContainer,

      //* Tertiary Fixed Colors
      "tertiaryFixed": tertiaryFixed,
      "tertiaryFixedDim": tertiaryFixedDim,
      "onTertiaryFixed": onTertiaryFixed,
      "onTertiaryFixedVariant": onTertiaryFixedVariant,

      //* Error Colors
      "error": error,
      "onError": onError,
      "errorContainer": errorContainer,
      "onErrorContainer": onErrorContainer,

      //* Surface Colors
      "surface": surface,
      "onSurface": onSurface,
      "onSurfaceVariant": onSurfaceVariant,
      "surfaceContainerLowest": surfaceContainerLowest,
      "surfaceContainerLow": surfaceContainerLow,
      "surfaceContainer": surfaceContainer,
      "surfaceContainerHigh": surfaceContainerHigh,
      "surfaceContainerHighest": surfaceContainerHighest,
      "surfaceTint": surfaceTint,
      "surfaceDim": surfaceDim,
      "surfaceBright": surfaceBright,

      //* Inverse Colors
      "inversePrimary": inversePrimary,
      "inverseSurface": inverseSurface,
      "onInverseSurface": onInverseSurface,

      //* Others Colors
      "scrim": scrim,
      "shadow": shadow,
      "outline": outline,
      "outlineVariant": outlineVariant,
    };

    //* Descomentarear para copiar todos los colores al portapapeles
    // String cad = '';
    // for (final entry in colors.entries) {
    //   final color = entry.value;
    //   String colorCode = "#${color.value.toRadixString(16).padLeft(8, '0')}";
    //   cad += "${entry.key}: $colorCode\n";
    // }
    // Clipboard.setData(ClipboardData(text: cad));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ...colors.entries.map((entry) {
            final color = entry.value;
            String colorCode =
                "#${color.toARGB32().toRadixString(16).padLeft(8, '0')}";
            // String colorCode = color.toString();
            // colorCode = colorCode.substring(6, colorCode.length - 1);
            return ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  border: Border.all(width: 1, color: Color(0xfff1f1f1)),
                ),
              ),
              title: Text(entry.key),
              subtitle: Text(colorCode),
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: colorCode));
                ScaffoldMessenger.of(this)
                  ..clearSnackBars()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(
                        "Color $colorCode copiado al portapapeles",
                        style: TextStyle(color: onSecondaryContainer),
                      ),
                      backgroundColor: secondaryContainer,
                    ),
                  );
              },
            );
          }),
        ],
      ),
    );
  }

  //* Get all color scheme widget
  Widget get getTextStyleWidget {
    Map<String, TextStyle> textStyles = {
      "displayLarge": displayLarge,
      "displayMedium": displayMedium,
      "displaySmall": displaySmall,
      "headlineLarge": headlineLarge,
      "headlineMedium": headlineMedium,
      "headlineSmall": headlineSmall,
      "titleLarge": titleLarge,
      "titleMedium": titleMedium,
      "titleSmall": titleSmall,
      "labelLarge": labelLarge,
      "labelMedium": labelMedium,
      "labelSmall": labelSmall,
      "bodyLarge": bodyLarge,
      "bodyMedium": bodyMedium,
      "bodySmall": bodySmall,
    };

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ...textStyles.entries.map((entry) {
            return Text(entry.key, style: entry.value);
          }),
        ],
      ),
    );
  }
}
