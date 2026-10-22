import 'dart:io';

import 'package:event_bus_riverpod/event_bus_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:base_app/core/constants/constants.dart';
import 'package:base_app/core/firebase/firebase_manager.dart';
import 'package:base_app/core/firebase/local_notifications.dart';
import 'package:base_app/core/helpers/custom_log_print.dart';
import 'package:base_app/core/helpers/global_error_handler.dart';
import 'package:base_app/core/helpers/theme_utils.dart';
import 'package:base_app/core/localizations/am_pm_material_localizations.dart';
import 'package:base_app/core/network/remove_certificate.dart';
import 'package:base_app/core/router/router.dart';
import 'package:base_app/core/theme/app_theme.dart';
import 'package:base_app/l10n/app_localizations.dart';
import 'package:base_app/presentation/providers/conectivity_status/connectivity_status_provider.riverpod.dart';
import 'package:base_app/presentation/providers/language/locale_provider.riverpod.dart';
import 'package:base_app/presentation/providers/lifecycle/lifecycle.provider.riverpod.dart';
import 'package:base_app/presentation/providers/socketio/socketio_provider.dart';
import 'package:base_app/presentation/providers/theme/theme_provider.riverpod.dart';

//* cambio de idioma
//? Nota: este archivo se genera luego de compilar
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// export 'package:flutter_gen/gen_l10n/app_localizations.dart';

/*
Cómo usar esta plantilla: /////////////////////////////

1) Revisar el Manifest.xml (Android) e Info.plist (iOS) para permisos, tema y notificaciones
2) Revisar en /core/helpers/ los útiles que hay (url_launcher, calendar, debounce, image…)
3) Revisar en /core/extensions/ las extensiones que hay
4) Revisar en /core/router/ las rutas (router_path.dart, routes/) y añadir las tuyas
5) Revisar en /core/constants/constants.dart las URLs y flags (isDev, showDioError…)
6) /third_party/ contiene parches locales de paquetes (se resuelven con
   dependency_overrides en pubspec.yaml). Borrar si no se usan.

Dependencias ya incluidas: animate_do, dio, flutter_riverpod, go_router, intl,
cached_network_image, auto_size_text, permission_handler, flutter_typeahead,
flutter_debouncer, shared_preferences, connectivity_plus, extended_image, formz,
image_picker, url_launcher, json_view_plus, vibration, loading_animation_widget,
socket_io_client, event_bus_riverpod, uuid, sqflite, path, device_info_plus,
package_info_plus, phone_text_field, custom_image_crop, flutter_image_compress

Dev: android_notification_icons, flutter_launcher_icons, riverpod_lint

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
+Traducir en lib/l10n/app_en.arb y app_es.arb, luego: flutter gen-l10n
+Usar en los widgets con: context.l10n.<key>

Para firebase y notificaciones: /////////////////////////////
+Instalar dependencias
  flutter_local_notifications, firebase_core, firebase_messaging,
  firebase_messaging_platform_interface
+Seguir los pasos oficiales o saltar a los pasos siguientes
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
    // Import the Firebase Boom
    implementation(platform("com.google.firebase:firebase-bom:34.1.0"))
  }
  3- ejecutar: flutterfire configure
  4- revisar en el Manifest.xml los permisos y estilos de las notificaciones
  5- FirebaseManager.init() y LocalNotifications.initialize() ya se llaman en main()

Para sockets: /////////////////////////////
+socketioProvider (Notifier genérico) se mantiene vivo en MyApp.build
+configurar la URL en constants.dart (Constants.baseUrl) y conectar con:
  ref.read(socketioProvider.notifier).connect(token)
+los eventos se escuchan con EventBusGlobal (event_bus_riverpod)

Errores globales: /////////////////////////////
+GlobalErrorHandler.init() captura errores de framework y del root isolate
+para enviar crash reports a un backend asignar GlobalErrorHandler.reportHandler

SQLite local: /////////////////////////////
+ver lib/data/sqlite_handler/sqlite_handler.dart y lib/core/constants/db_constants.dart
*/

void main() async {
  //* para dejar de mostrar el splash
  WidgetsFlutterBinding.ensureInitialized();

  //* para poner la apk potrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //* capturar excepciones no manejadas
  GlobalErrorHandler.init();

  await FirebaseManager.init();

  //* iniciar notificaciones locales
  await LocalNotifications.initialize();

  //* para poner el color de la barra de navegación, solo en android
  // SystemChrome.setSystemUIOverlayStyle(
  //   SystemUiOverlayStyle(
  //     systemNavigationBarColor: Colors.blue, // navigation bar color
  //     statusBarColor: Colors.pink, // status bar color
  //   ),
  // );

  //* para saltarse protocolos de red
  HttpOverrides.global = MyHttpOverrides();

  if (Constants.isDev) {
    try {
      EventBusGlobal.logEvents((entry) {
        CustomPrint.call(
          'EventBusGlobal logs -> ${entry.eventName} ${entry.value}',
        );
      });
    } catch (_) {}
  }

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static BuildContext? context;
  static WidgetRef? ref;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //* keep alive providers that never must be disposed
        Consumer(
          builder: (_, WidgetRef ref, _) {
            final _ = ref.watch(socketioProvider);
            final _ = ref.watch(connectivityStatusProvider);
            final _ = ref.watch(lifecycleProvider);
            return const SizedBox.shrink();
          },
        ),

        //* app
        Expanded(
          child: Consumer(
            builder: (context, ref, child) {
              MyApp.context = context;
              MyApp.ref = ref;
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
                localizationsDelegates: [
                  AppLocalizations.delegate,
                  const AmPmMaterialLocalizationsDelegate(),
                  GlobalCupertinoLocalizations.delegate,
                  DefaultWidgetsLocalizations.delegate,
                ],
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(alwaysUse24HourFormat: false),
                  child: child!,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
