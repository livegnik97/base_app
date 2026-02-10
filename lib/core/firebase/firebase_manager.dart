import 'package:base_app/core/firebase/firebase_options.dart';
import 'package:base_app/core/firebase/local_notifications.dart';
import 'package:base_app/core/helpers/custom_log_print.dart';
import 'package:base_app/core/helpers/dynamic_parse.dart';
import 'package:base_app/data/shared_preferences/my_shared.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  CustomPrint.call('notiListen4 ${message.data}');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // showFlutterNotification(message);
}

// void showFlutterNotification(RemoteMessage message) async {
//   final isAuthenticated =
//       (await MyShared.getStringOrNull(MySharedConstants.accessToken)) != null;
//   if (isAuthenticated &&
//       message.data.isNotEmpty &&
//       message.data.containsKey('xxxId')) {
//     // await MyShared.setValue(
//     //   MySharedConstants.notificationXxxId,
//     //   message.data['xxxId'],
//     // );

//     // CustomNotification.showNotification(
//     //   title: message.notification?.title ?? 'Orden asignada',
//     //   body:
//     //       message.notification?.body ??
//     //       'La orden con numero de orden ${message.data['xxxId']} ha sido asignada a usted',
//     //   payload: {
//     //     'xxxId': message.data['xxxId'],
//     //     'message':
//     //         message.notification?.body ??
//     //         'La orden con numero de orden ${message.data['xxxId']} ha sido asignada a usted',
//     //   },
//     // );
//   }
// }

class CustomNotification {
  static void showNotification({
    int id = 0,
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await LocalNotifications.initialize(flutterLocalNotificationsPlugin);
    await LocalNotifications.showNotification(
      id: id,
      title: title,
      body: body,
      payload: payload,
      fln: flutterLocalNotificationsPlugin,
    );
  }
}

class FirebaseManager {
  static bool isInitialized = false;
  static String? deviceToken;
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static FirebaseApp? firebaseApp;

  /*
  MODO DE USO:
  En un provider donde se van a trabajar las notificaciones se debe inicializar la funcion
  FirebaseManager.remoteSubscription = processNotification;

  En el dispose del provider se debe hacer:
  FirebaseManager.remoteSubscription = null;
  */
  static Function(String xxxId, bool byUser, {String? message})?
  remoteSubscription;

  static Future<void> init() async {
    if (isInitialized && deviceToken != null) return;
    try {
      try {
        firebaseApp = Firebase.app();
      } catch (_) {
        firebaseApp = await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      NotificationSettings notificationSettings = await requestPermission();
      if (notificationSettings.authorizationStatus ==
          AuthorizationStatus.authorized) {
        isInitialized = true;
        await getToken();
        await messaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
        await messaging.setAutoInitEnabled(true);

        FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler,
        );

        FirebaseMessaging.instance.getInitialMessage().then((
          RemoteMessage? message,
        ) async {
          if (message != null) {
            CustomPrint.call('notiListen1 ${message.data}');
            final isAuthenticated =
                (await MyShared.getStringOrNull(
                  MySharedConstants.accessToken,
                )) !=
                null;
            if (isAuthenticated &&
                message.data.isNotEmpty &&
                message.data.containsKey('xxxId')) {
              final xxxId = DynamicParse.toIntOrNull(message.data['xxxId']);
              if (xxxId != null) {
                await MyShared.setValue<int>(
                  MySharedConstants.notificationXxxId,
                  xxxId,
                );
              }
            }
          }
        });

        FirebaseMessaging.onMessage.listen((message) async {
          CustomPrint.call('notiListen2 ${message.data}');
          final isAuthenticated =
              (await MyShared.getStringOrNull(MySharedConstants.accessToken)) !=
              null;
          if (isAuthenticated &&
              message.data.isNotEmpty &&
              message.data.containsKey('xxxId')) {
            remoteSubscription?.call(
              message.data['xxxId'],
              false,
              message: message.notification?.body,
            );
            final flutterLocalNotificationsPlugin =
                FlutterLocalNotificationsPlugin();
            await LocalNotifications.initialize(
              flutterLocalNotificationsPlugin,
            );
            final messageString =
                message.notification?.body ??
                'El objeto X con id ${message.data['xxxId']} se ha notificado';
            await LocalNotifications.showNotification(
              title: message.notification?.title ?? 'Titulo de notificación',
              body: messageString,
              payload: {
                'xxxId': message.data['xxxId'],
                'message': messageString,
              },
              fln: flutterLocalNotificationsPlugin,
            );
          }
        });

        FirebaseMessaging.onMessageOpenedApp.listen((
          RemoteMessage message,
        ) async {
          CustomPrint.call('notiListen3 ${message.data}');
          final isAuthenticated =
              (await MyShared.getStringOrNull(MySharedConstants.accessToken)) !=
              null;
          if (isAuthenticated &&
              message.data.isNotEmpty &&
              message.data.containsKey('xxxId')) {
            if (remoteSubscription != null) {
              remoteSubscription?.call(
                message.data['xxxId'],
                true,
                message: message.notification?.body,
              );
            } else {
              final xxxId = DynamicParse.toIntOrNull(message.data['xxxId']);
              if (xxxId != null) {
                await MyShared.setValue<int>(
                  MySharedConstants.notificationXxxId,
                  xxxId,
                );
              }
            }
          }
        });
      }
    } catch (_) {}
  }

  static Future<NotificationSettings> requestPermission() async {
    return await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  static Future<String?> getToken() async {
    try {
      deviceToken = await messaging.getToken();
      return deviceToken;
    } catch (e) {
      return null;
    }
  }
}
