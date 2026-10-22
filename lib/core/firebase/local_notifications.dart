import 'dart:convert';
import 'package:base_app/core/constants/event_bus_constants.dart';
import 'package:base_app/core/helpers/custom_log_print.dart';
import 'package:base_app/data/shared_preferences/my_shared.dart';
import 'package:event_bus_riverpod/event_bus_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifications {
  static final flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    try {
      const androidInitialize = AndroidInitializationSettings(
        'drawable/ic_notification',
      );
      const iOSInitialize = DarwinInitializationSettings();

      const InitializationSettings initializationSettings =
          InitializationSettings(
            android: androidInitialize,
            iOS: iOSInitialize,
          );

      final notiAppLaunchDetails = await flutterLocalNotificationsPlugin
          .getNotificationAppLaunchDetails();

      await flutterLocalNotificationsPlugin.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse: selectNotificationHandle,
        onDidReceiveBackgroundNotificationResponse: selectNotificationHandle,
      );

      if (notiAppLaunchDetails?.didNotificationLaunchApp == true &&
          notiAppLaunchDetails?.notificationResponse != null) {
        await selectNotificationHandle(
          notiAppLaunchDetails!.notificationResponse!,
        );
      }
    } catch (_) {}
  }

  static int _idCounter = 0;

  static Future<void> showNotification({
    int id = 0,
    required String title,
    required String body,
    Map<String, dynamic>? payload,
    String? groupKey,
    bool replaceGroup = true,
  }) async {
    try {
      int notificationId = (groupKey != null && id == 0 && !replaceGroup)
          ? ++_idCounter
          : groupKey?.hashCode ?? id;
      if (notificationId > 0x7FFFFFFF || notificationId < -0x80000000) {
        _idCounter = 0;
        notificationId = ++_idCounter;
      }

      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
            'base-notification-channel',
            'Base Notification Channel',
            channelDescription: 'Base Notification Channel',
            playSound: true,
            importance: Importance.max,
            priority: Priority.high,
            groupKey: groupKey,
            icon: 'ic_notification',
          );

      final notif = NotificationDetails(android: androidNotificationDetails);

      flutterLocalNotificationsPlugin.show(
        id: notificationId,
        title: title,
        body: body,
        notificationDetails: notif,
        payload: payload != null ? json.encode(payload) : null,
      );
    } catch (e) {
      CustomPrint.call('Error al mostrar notificacion: $e');
    }
  }

  static Future<void> selectNotificationHandle(
    NotificationResponse noti,
  ) async {
    final payload = noti.payload;
    if (payload != null) {
      Map<String, dynamic> data = json.decode(payload);

      final isAuthenticated =
          (await MyShared.getStringOrNull(MySharedConstants.accessToken)) !=
          null;

      if (isAuthenticated) {
        await MyShared.setValue<String>(
          MySharedConstants.notificationPayload,
          jsonEncode(data),
        );
        if (EventBusGlobal.event(
          EventBusConstants.onNotificationTapped,
        ).hasClients) {
          EventBusGlobal.event(
            EventBusConstants.onNotificationTapped,
          ).emit(data);
        }
      }
    }
  }
}
