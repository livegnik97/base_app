import 'package:base_app/core/helpers/theme_utils.dart';
import 'package:base_app/core/router/router.dart';
import 'package:base_app/core/theme/app_theme.dart';
import 'package:base_app/l10n/app_localizations.dart';
import 'package:base_app/presentation/providers/language/locale_provider.riverpod.dart';
import 'package:base_app/presentation/providers/theme/theme_provider.riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//* cambio de idioma
//? Nota: este archivo se genera luego de compilar
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// export 'package:flutter_gen/gen_l10n/app_localizations.dart';

/*
Instalar en dependencias
animate_do, dio, flutter_riverpod, go_router, intl, cached_network_image, auto_size_text, permission_handler, flutter_typeahead, flutter_debouncer
shared_preferences, connectivity_plus, extended_image, formz, image_picker, url_launcher, json_view, vibration, loading_animation_widget, socket_io_client

Instalar en dev dependencias
android_notification_icons, flutter_launcher_icons

Revisar el Manifest.xml para ver tema permisos y otras cosas
Revisar en /core/helpers/ los utiles que estan
Revisar en /core/extensions/ las extensiones que estan

Para cambiar de lenguaje: /////////////////////////////
+En el archivo: pubspec.yaml
  -Poner en dependencias
    flutter_localizations:
      sdk: flutter

  -Poner en flutter
    generate: true

+Crear archivo: l10n.yaml
  -Copiar dentro:
    arb-dir: lib/l10n
    template-arb-file: app_en.arb
    output-localization-file: app_localizations.dart

Para firebase y notificaciones: /////////////////////////////
+Intalar dependencias
  flutter_local_notifications, firebase_core, firebase_messaging, firebase_messaging_platform_interface
+Seguir los pasos oficiales o salta a los pasos siguientes
  https://firebase.google.com/docs/cloud-messaging/flutter/get-started?hl=es-419
+Pasos:
  1- ir a android/app/build.gradle.kts y agregar:
  compileOptions {
        isCoreLibraryDesugaringEnabled = true
        ...
    }
  
  2- y agregar al final:
  dependencies {
    // For AGP 7.4+
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    // For AGP 7.3
    // coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:1.2.3")
    // For AGP 4.0 to 7.2
    // coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:1.1.9")

    // Import the Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:34.1.0"))
  }
  2- Ejecuta el comando siguiente
    flutterfire configure
  3- revisar en el Manifest.xml los permisos y estilos de las notificaciones
*/

void main() async {
  //* para dejar de mostrar el splash
  WidgetsFlutterBinding.ensureInitialized();

  //* para poner la apk potrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //* para poner el color de la barra de navegación, solo en android
  // SystemChrome.setSystemUIOverlayStyle(
  //   SystemUiOverlayStyle(
  //     systemNavigationBarColor: Colors.blue, // navigation bar color
  //     statusBarColor: Colors.pink, // status bar color
  //   ),
  // );

  //* para saltarse protocolos de red
  // HttpOverrides.global = MyHttpOverrides();

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static BuildContext? context;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        MyApp.context = context;
        final locale = ref.watch(localeProvider);
        final theme = ref.watch(themeProvider);
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Base App',
          theme: AppTheme().themeLight(),
          darkTheme: AppTheme().themeDark(),
          themeMode: ThemeUtils.getThemeMode(theme),
          routerConfig: appRouter,

          //para el idioma
          locale: locale.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
        );
      },
    );
  }
}
