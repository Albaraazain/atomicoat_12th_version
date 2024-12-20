// lib/domain/interfaces/datasources/i_alarm_datasource.dart

import 'package:experiment_planner/domain/entities/alert/monitoring_alert.dart';
import 'package:experiment_planner/domain/entities/alert/system_alert.dart';
import 'package:experiment_planner/domain/enums/alert_enums.dart';

abstract class IAlarmDataSource {
  /// Gets all active alerts
  Future<List<MonitoringAlert>> getActiveAlerts({String? componentId});

  /// Gets alert history within a specific time range
  Future<List<MonitoringAlert>> getAlertHistory({
    DateTime? startTime,
    DateTime? endTime,
    AlertType? type,
    AlertSeverity? minSeverity,
    String? componentId,
    int? limit,
  });

  /// Saves a new monitoring alert
  Future<void> saveMonitoringAlert(MonitoringAlert alert);

  /// Saves a new system alert
  Future<void> saveSystemAlert(SystemAlert alert);

  /// Acknowledges an alert
  Future<void> acknowledgeAlert(String alertId, String acknowledgedBy);

  /// Resolves an alert
  Future<void> resolveAlert(String alertId, String resolvedBy);

  /// Mutes an alert
  Future<void> muteAlert(String alertId);

  /// Unmutes an alert
  Future<void> unmuteAlert(String alertId);

  /// Gets alerts by severity
  Future<List<MonitoringAlert>> getAlertsBySeverity(AlertSeverity severity);

  /// Gets alerts by component
  Future<List<MonitoringAlert>> getAlertsByComponent(String componentId);

  /// Gets alert statistics
  Future<AlertStatistics> getAlertStatistics({
    DateTime? startTime,
    DateTime? endTime,
    String? componentId,
  });

  /// Streams active alerts
  Stream<List<MonitoringAlert>> watchActiveAlerts();

  /// Deletes an alert
  Future<void> deleteAlert(String alertId);

  /// Clears alert history
  Future<void> clearAlertHistory({
    DateTime? before,
    AlertType? type,
    String? componentId,
  });

  /// Updates alert thresholds for a component
  Future<void> updateAlertThresholds(
    String componentId,
    Map<String, double> thresholds,
  );

  /// Gets current alert thresholds for a component
  Future<Map<String, double>> getAlertThresholds(String componentId);
}

/// Statistics about alerts
class AlertStatistics {
  final int totalAlerts;
  final int activeAlerts;
  final int criticalAlerts;
  final Map<AlertType, int> alertsByType;
  final Map<AlertSeverity, int> alertsBySeverity;
  final Map<String, int> alertsByComponent;
  final DateTime startTime;
  final DateTime endTime;

  AlertStatistics({
    required this.totalAlerts,
    required this.activeAlerts,
    required this.criticalAlerts,
    required this.alertsByType,
    required this.alertsBySeverity,
    required this.alertsByComponent,
    required this.startTime,
    required this.endTime,
  });
}