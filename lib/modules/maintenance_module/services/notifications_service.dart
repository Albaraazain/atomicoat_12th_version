import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationsService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationsService() {
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

    final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleDailyMaintenanceReminder() async {
    final tz.TZDateTime scheduledTime = _nextInstanceOfTime(9, 0); // 9:00 AM
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Daily Maintenance Reminder',
        'Don\'t forget to check your maintenance tasks for today!',
        scheduledTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_maintenance_channel',
            'Daily Maintenance Reminders',
            importance: Importance.high,
            priority: Priority.high,
            styleInformation: BigPictureStyleInformation(
              DrawableResourceAndroidBitmap('app_icon'),
              largeIcon: DrawableResourceAndroidBitmap('app_icon'),
            ),
          ),
        ),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        androidScheduleMode: AndroidScheduleMode.exact
    );
  }

  Future<void> scheduleCalibrationReminder(DateTime dueDate, String componentName) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        1,
        'Calibration Due',
        'Calibration for $componentName is due today',
        tz.TZDateTime.from(dueDate, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'calibration_channel',
            'Calibration Reminders',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exact
    );
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
