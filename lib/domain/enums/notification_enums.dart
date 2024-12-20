
/// Notification channels
enum NotificationChannel {
  inApp,
  email,
  sms,
  push,
  all
}

/// Types of notifications
enum NotificationType {
  processAlert,
  maintenanceReminder,
  systemStatus,
  experimentCompletion,
  qualityAlert,
  calibrationDue,
  parameterDeviation,
  securityAlert
}

/// Notification topics
enum NotificationTopic {
  processMonitoring,
  maintenance,
  systemHealth,
  qualityControl,
  security,
  experiments,
  calibration,
  general
}


/// Action behavior options
enum ActionBehavior {
  navigate,
  dialog,
  bottomSheet,
  external
}

/// Notification priority levels
enum NotificationPriority {
  low,
  normal,
  high,
  urgent
}