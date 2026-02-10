import 'dart:convert';
import 'package:base_app/core/firebase/firebase_manager.dart';
import 'package:base_app/core/helpers/dynamic_parse.dart';
import 'package:base_app/data/shared_preferences/my_shared.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> selectNotification(NotificationResponse noti) async {
  // Future<void> selectNotification(String? payload) async {
  final payload = noti.payload;
  if (payload != null) {
    Map<String, dynamic> data = json.decode(payload);

    final isAuthenticated =
        (await MyShared.getStringOrNull(MySharedConstants.accessToken)) != null;

    if (isAuthenticated && data.containsKey('xxxId')) {
      final xxxId = DynamicParse.toIntOrNull(data['xxxId']);
      if (xxxId != null) {
        await MyShared.setValue<int>(
          MySharedConstants.notificationXxxId,
          xxxId,
        );
        if (FirebaseManager.remoteSubscription != null) {
          FirebaseManager.remoteSubscription?.call(
            xxxId.toString(),
            true,
            message: data['message'],
          );
        }
      }
    }
  }
}

class LocalNotifications {
  static Future<void> initialize(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  ) async {
    const androidInitialize = AndroidInitializationSettings(
      'drawable/ic_notification',
      //'@drawable/notification_icon'
    );
    const iOSInitialize = DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: selectNotification,
      onDidReceiveBackgroundNotificationResponse: selectNotification,
    );
  }

  static Future<void> showNotification({
    int id = 0,
    required String title,
    required String body,
    Map<String, dynamic>? payload,
    required FlutterLocalNotificationsPlugin fln,
  }) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
          'channel_id',
          'Channel Name',
          channelDescription: 'Channel Description',
          playSound: true,
          importance: Importance.max,
          priority: Priority.high,
        );

    final notif = NotificationDetails(android: androidNotificationDetails);

    fln.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notif,
      payload: payload != null ? json.encode(payload) : null,
    );
  }
}
