import 'dart:convert';

import 'package:base_app/core/constants/event_bus_constants.dart';
import 'package:base_app/core/firebase/local_notifications.dart';
import 'package:base_app/core/helpers/custom_log_print.dart';
import 'package:base_app/data/shared_preferences/my_shared.dart';
import 'package:base_app/core/firebase/firebase_options.dart';
import 'package:event_bus_riverpod/event_bus_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  LocalNotifications.selectNotificationHandle(response);
}

class CustomNotification {
  static void showNotification({
    int id = 0,
    required String title,
    required String body,
    Map<String, dynamic>? payload,
    String? groupKey,
    bool replaceGroup = true,
  }) async {
    await LocalNotifications.showNotification(
      id: id,
      title: title,
      body: body,
      payload: payload,
      groupKey: groupKey,
      replaceGroup: replaceGroup,
    );
  }
}

class FirebaseManager {
  static bool isInitialized = false;
  static String? deviceToken;
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static FirebaseApp? firebaseApp;

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

        //* escucha de actualizaciones del token para mantenerlo siempre fresco
        messaging.onTokenRefresh.listen((newToken) {
          deviceToken = newToken;
          CustomPrint.call('FCM token refreshed: $newToken');
        });

        //* en iOS el token se deriva del APNs, puede tardar en estar disponible.
        //* messaging.getAPNSToken().then((apns) {
        //*   if (apns != null) CustomPrint.call('APNS token obtained: $apns');
        //* });

        FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler,
        );

        //* Cuando la apk esta cerrada, llega una notificacion y la toco
        //* Tambien funciona si la apk esta en 2do plano, cierras la app y tocas la notificacion
        FirebaseMessaging.instance.getInitialMessage().then((
          RemoteMessage? message,
        ) async {
          if (message != null) {
            CustomPrint.call('noti-listen 1 ${message.data}');
            await processNotification(message);
          }
        });

        //* Notificacion en primer plano cuando está abierta la app, no se crea la notificacion automatica
        FirebaseMessaging.onMessage.listen((message) async {
          CustomPrint.call('noti-listen 2 ${message.data}');
          final isAuthenticated =
              (await MyShared.getStringOrNull(MySharedConstants.accessToken)) !=
              null;
          if (isAuthenticated && message.data.isNotEmpty) {
            if (message.notification?.title != null &&
                message.notification?.body != null) {
              final title = message.notification!.title!;
              final body = message.notification!.body!;
              final tag = message.notification?.android?.tag;
              await LocalNotifications.showNotification(
                title: title,
                body: body,
                payload: message.data,
                groupKey: tag is String && tag.isNotEmpty ? tag : null,
              );
            } else {
              await processNotification(message);
            }
          }
        });

        //* Cuando la apk está en 2do plano, llega la notificacion y la toco
        FirebaseMessaging.onMessageOpenedApp.listen((
          RemoteMessage message,
        ) async {
          CustomPrint.call('noti-listen 3 ${message.data}');
          await processNotification(message);
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
      if (deviceToken != null) return deviceToken;
    } on FirebaseException catch (fe) {
      if (fe.code == 'apns-token-not-set') {
        CustomPrint.call('APNS token not set yet');
      } else {
        rethrow;
      }
    } catch (e) {
      CustomPrint.call('Error getting token: $e');
    }
    return null;
  }

  static Future<void> processNotification(RemoteMessage message) async {
    try {
      final isAuthenticated =
          (await MyShared.getStringOrNull(MySharedConstants.accessToken)) !=
          null;
      if (isAuthenticated) {
        if (EventBusGlobal.event(
          EventBusConstants.onNotificationTapped,
        ).hasClients) {
          EventBusGlobal.event(
            EventBusConstants.onNotificationTapped,
          ).emit(message.data);
        } else {
          await MyShared.setValue<String>(
            MySharedConstants.notificationPayload,
            jsonEncode(message.data),
          );
        }
      }
    } catch (e) {
      CustomPrint.call(
        'processNotification Error al procesar la notificación: $e',
      );
    }
  }
}
