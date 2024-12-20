// lib/domain/services/notification/notification_service.dart
import 'package:experiment_planner/domain/enums/alert_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../../domain/entities/alert/alert.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  NotificationService._internal();

  Future<void> initialize() async {
    if (_isInitialized) return;

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _isInitialized = true;
  }

  Future<void> showAlertNotification(Alert alert) async {
    final androidDetails = AndroidNotificationDetails(
      'alerts_channel',
      'System Alerts',
      channelDescription: 'ALD System Alerts and Notifications',
      importance: _getNotificationImportance(alert.severity),
      priority: _getNotificationPriority(alert.severity),
      color: _getAlertColor(alert.severity),
      category: AndroidNotificationCategory.alarm,
      styleInformation: BigTextStyleInformation(alert.message),
    );

    final iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: _getInterruptionLevel(alert.severity),
    );

    await _notifications.show(
      alert.hashCode,
      '${alert.severity.toString().split('.').last} Alert',
      alert.message,
      NotificationDetails(android: androidDetails, iOS: iOSDetails),
      payload: alert.id,
    );
  }

  Importance _getNotificationImportance(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.critical:
        return Importance.max;
      case AlertSeverity.high:
        return Importance.high;
      case AlertSeverity.medium:
        return Importance.defaultImportance;
      case AlertSeverity.low:
        return Importance.low;
    }
  }

  Priority _getNotificationPriority(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.critical:
        return Priority.max;
      case AlertSeverity.high:
        return Priority.high;
      case AlertSeverity.medium:
        return Priority.defaultPriority;
      case AlertSeverity.low:
        return Priority.low;
    }
  }

  InterruptionLevel _getInterruptionLevel(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.critical:
        return InterruptionLevel.timeSensitive;
      case AlertSeverity.high:
        return InterruptionLevel.active;
      default:
        return InterruptionLevel.passive;
    }
  }

  Color _getAlertColor(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.critical:
        return Colors.red;
      case AlertSeverity.high:
        return Colors.orange;
      case AlertSeverity.medium:
        return Colors.yellow;
      case AlertSeverity.low:
        return Colors.blue;
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    if (response.payload != null) {
      // Navigate to alert details
      navigatorKey.currentState?.pushNamed(
        '/alert-details',
        arguments: response.payload,
      );
    }
  }
}
