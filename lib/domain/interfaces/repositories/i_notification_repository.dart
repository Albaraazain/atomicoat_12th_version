// lib/domain/interfaces/repositories/i_notification_repository.dart

import 'package:dartz/dartz.dart';
import 'package:experiment_planner/domain/entities/alert/monitoring_alert.dart';
import 'package:experiment_planner/domain/entities/alert/system_alert.dart';
import 'package:experiment_planner/domain/enums/notification_enums.dart';
import 'package:experiment_planner/domain/failures/failures.dart';
import 'package:experiment_planner/domain/enums/alert_enums.dart';

abstract class INotificationRepository {
  /// Sends a monitoring alert notification
  Future<Either<Failure, void>> sendMonitoringAlert(MonitoringAlert alert);

  /// Sends a system alert notification
  Future<Either<Failure, void>> sendSystemAlert(SystemAlert alert);

  /// Gets notification preferences for a user
  Future<Either<Failure, NotificationPreferences>> getNotificationPreferences(
    String userId,
  );

  /// Updates notification preferences
  Future<Either<Failure, void>> updateNotificationPreferences(
    String userId,
    NotificationPreferences preferences,
  );

  /// Gets notification history for a user
  Future<Either<Failure, List<NotificationRecord>>> getNotificationHistory(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
    NotificationType? type,
  });

  /// Marks a notification as read
  Future<Either<Failure, void>> markAsRead(String notificationId);

  /// Marks multiple notifications as read
  Future<Either<Failure, void>> markMultipleAsRead(List<String> notificationIds);

  /// Gets unread notification count
  Future<Either<Failure, int>> getUnreadCount(String userId);

  /// Subscribes to notification topics
  Future<Either<Failure, void>> subscribeToTopics(
    String userId,
    List<NotificationTopic> topics,
  );

  /// Unsubscribes from notification topics
  Future<Either<Failure, void>> unsubscribeFromTopics(
    String userId,
    List<NotificationTopic> topics,
  );

  /// Gets active notification subscriptions
  Future<Either<Failure, List<NotificationTopic>>> getActiveSubscriptions(
    String userId,
  );

  /// Streams real-time notifications
  Stream<Either<Failure, NotificationMessage>> watchNotifications(String userId);

  /// Tests notification delivery
  Future<Either<Failure, NotificationTestResult>> testNotification(
    String userId,
    NotificationType type,
  );

  /// Gets notification statistics
  Future<Either<Failure, NotificationStats>> getNotificationStats(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
  });
}

/// Notification preferences
class NotificationPreferences {
  final Map<NotificationType, bool> enabledTypes;
  final Map<AlertSeverity, NotificationChannel> channelsBySeverity;
  final Map<String, bool> componentAlerts;
  final bool enableEmailNotifications;
  final bool enablePushNotifications;
  final bool enableSMSNotifications;
  final List<String> emailAddresses;
  final List<String> phoneNumbers;
  final Map<NotificationTopic, bool> topicSubscriptions;
  final NotificationSchedule quietHours;
  final Map<String, double> alertThresholds;

  NotificationPreferences({
    required this.enabledTypes,
    required this.channelsBySeverity,
    required this.componentAlerts,
    required this.enableEmailNotifications,
    required this.enablePushNotifications,
    required this.enableSMSNotifications,
    required this.emailAddresses,
    required this.phoneNumbers,
    required this.topicSubscriptions,
    required this.quietHours,
    required this.alertThresholds,
  });
}

/// Notification schedule
class NotificationSchedule {
  final bool enabled;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final List<int> activeDays; // 1-7 representing Monday-Sunday
  final Set<NotificationType> excludedTypes;

  NotificationSchedule({
    required this.enabled,
    required this.startTime,
    required this.endTime,
    required this.activeDays,
    required this.excludedTypes,
  });
}

/// Notification record
class NotificationRecord {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationChannel channel;
  final bool isRead;
  final String? actionUrl;
  final Map<String, dynamic>? metadata;
  final NotificationPriority priority;

  NotificationRecord({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.channel,
    required this.isRead,
    this.actionUrl,
    this.metadata,
    required this.priority,
  });
}

/// Real-time notification message
class NotificationMessage {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationPriority priority;
  final Map<String, dynamic>? data;
  final NotificationAction? action;

  NotificationMessage({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.priority,
    this.data,
    this.action,
  });
}

/// Notification action
class NotificationAction {
  final String label;
  final String route;
  final Map<String, dynamic>? parameters;
  final ActionBehavior behavior;

  NotificationAction({
    required this.label,
    required this.route,
    this.parameters,
    required this.behavior,
  });
}

/// Time of day representation
class TimeOfDay {
  final int hour;
  final int minute;

  const TimeOfDay({
    required this.hour,
    required this.minute,
  });

  @override
  String toString() => '$hour:${minute.toString().padLeft(2, '0')}';
}

/// Notification test result
class NotificationTestResult {
  final bool success;
  final List<NotificationChannel> deliveredTo;
  final Duration deliveryTime;
  final List<String> failedChannels;
  final String? errorMessage;

  NotificationTestResult({
    required this.success,
    required this.deliveredTo,
    required this.deliveryTime,
    required this.failedChannels,
    this.errorMessage,
  });
}

/// Notification statistics
class NotificationStats {
  final int totalNotifications;
  final int unreadCount;
  final Map<NotificationType, int> countByType;
  final Map<NotificationChannel, int> countByChannel;
  final double averageDeliveryTime;
  final Map<NotificationPriority, int> countByPriority;
  final Map<String, int> interactionStats;

  NotificationStats({
    required this.totalNotifications,
    required this.unreadCount,
    required this.countByType,
    required this.countByChannel,
    required this.averageDeliveryTime,
    required this.countByPriority,
    required this.interactionStats,
  });
}