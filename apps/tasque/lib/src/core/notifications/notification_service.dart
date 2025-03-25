import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../shared/common_export.dart';

/// Service for sending local notifications to the user.
class NotificationService {
  const NotificationService._();

  /// Singleton instance.
  static const i = NotificationService._();

  static final _plugin = FlutterLocalNotificationsPlugin();

  /// Initializes the local notifications plugin.
  Future<void> init() async {
    try {
      const androidSettings = AndroidInitializationSettings('app_icon');
      const iosSettings = DarwinInitializationSettings();
      const initializationSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
        macOS: iosSettings,
      );
      await _plugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      );
    } catch (e) {
      log('notification init', e);
    }
  }

  /// Requests notification permissions from the user.
  Future<void> requestPermissions() async {
    try {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          final android =
              _plugin
                  .resolvePlatformSpecificImplementation<
                    AndroidFlutterLocalNotificationsPlugin
                  >()!;
          await android.requestNotificationsPermission();
          await android.requestExactAlarmsPermission();

        case TargetPlatform.iOS:
          await _plugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >()
              ?.requestPermissions(alert: true, badge: true, sound: true);

        case _:
      }
    } catch (e) {
      log('notification permission', e);
    }
  }

  /// Notification channel.
  static const _taskReminderDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'task_reminder',
      'Task Reminder',
      channelDescription: 'Remind you about tasks',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    ),
  );

  /// Schedules a notification at a specific time.
  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime time,
  }) async {
    final now = DateTime.now();
    if (time.isBefore(now)) return;
    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(time.difference(now)),
        _taskReminderDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      log('notification schedule', e);
    }
  }

  /// Cancels a scheduled notification.
  Future<void> cancelSchedule(int id) async {
    try {
      await _plugin.cancel(id);
    } catch (e) {
      log('notification cancel', e);
    }
  }

  // TODO(albin): deeplink
  Future<void> onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse,
  ) async {
    final payload = notificationResponse.payload;
    log('notification payload: $payload');
  }
}
