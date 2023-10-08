import 'package:todark/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationShow {
  Future showNotification(
    int id,
    String title,
    String body,
    DateTime? date,
  ) async {
    await requestNotificationPermission();
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      'ToDark',
      'DARK NIGHT',
      priority: Priority.high,
      importance: Importance.max,
    );
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    var scheduledTime = tz.TZDateTime.from(date!, tz.local);
    flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'notlification-payload',
    );
  }

  Future<void> requestNotificationPermission() async {
    final platform =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (platform != null) {
      await platform.requestExactAlarmsPermission();
      await platform.requestNotificationsPermission();
    }
  }
}
