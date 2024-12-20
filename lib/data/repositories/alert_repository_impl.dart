import 'dart:async';

import '../../domain/interfaces/repositories/i_alert_repository.dart';
import '../../domain/services/monitoring/alerts/monitoring_alert.dart';

class AlertRepositoryImpl implements IAlertRepository {
  final _activeAlerts = <MonitoringAlert>[];
  final _alertHistory = <MonitoringAlert>[];
  final _alertStreamController = StreamController<List<MonitoringAlert>>.broadcast();

  @override
  Future<List<MonitoringAlert>> getActiveAlerts() async {
    return _activeAlerts;
  }

  @override
  Future<List<MonitoringAlert>> getAlertHistory({int? limit}) async {
    if (limit != null) {
      return _alertHistory.take(limit).toList();
    }
    return _alertHistory;
  }

  @override
  Future<void> saveAlert(MonitoringAlert alert) async {
    _activeAlerts.add(alert);
    _alertStreamController.add(_activeAlerts);
  }

  @override
  Future<void> acknowledgeAlert(String alertId) async {
    final alert = _activeAlerts.firstWhere((a) => a.id == alertId);
    _activeAlerts.remove(alert);
    _alertHistory.insert(0, alert);
    _alertStreamController.add(_activeAlerts);
  }

  @override
  Future<void> muteAlert(String alertId) async {
    final alert = _activeAlerts.firstWhere((a) => a.id == alertId);
    // Implementation would update the alert's muted status
    _alertStreamController.add(_activeAlerts);
  }

  @override
  Future<void> unmuteAlert(String alertId) async {
    final alert = _activeAlerts.firstWhere((a) => a.id == alertId);
    // Implementation would update the alert's muted status
    _alertStreamController.add(_activeAlerts);
  }

  @override
  Stream<List<MonitoringAlert>> watchActiveAlerts() {
    return _alertStreamController.stream;
  }

  @override
  Future<void> deleteAlert(String alertId) async {
    _activeAlerts.removeWhere((a) => a.id == alertId);
    _alertHistory.removeWhere((a) => a.id == alertId);
    _alertStreamController.add(_activeAlerts);
  }

  @override
  Future<void> clearAlertHistory() async {
    _alertHistory.clear();
  }
}
