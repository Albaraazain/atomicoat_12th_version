import '../../../enums/alert_enums.dart';
import '../../../interfaces/repositories/i_alert_repository.dart';
import 'monitoring_alert.dart';

class AlertManager {
  final IAlertRepository _repository;
  final _alertThresholds = <String, double>{};

  AlertManager(this._repository);

  Future<void> processNewMeasurement(String componentId, double value) async {
    if (_shouldTriggerAlert(componentId, value)) {
      final alert = MonitoringAlert(
        type: AlertType.measurement,
        message: 'Measurement exceeded threshold for $componentId',
        severity: _determineSeverity(value, _alertThresholds[componentId]!),
        componentId: componentId,
        metadata: {
          'value': value,
          'threshold': _alertThresholds[componentId],
        },
      );

      await _repository.saveAlert(alert);
    }
  }

  bool _shouldTriggerAlert(String componentId, double value) {
    final threshold = _alertThresholds[componentId];
    if (threshold == null) return false;
    return value > threshold;
  }

  AlertSeverity _determineSeverity(double value, double threshold) {
    final exceedance = (value - threshold) / threshold;
    if (exceedance > 0.5) return AlertSeverity.critical;
    if (exceedance > 0.3) return AlertSeverity.high;
    if (exceedance > 0.1) return AlertSeverity.medium;
    return AlertSeverity.low;
  }

  Future<List<MonitoringAlert>> getActiveAlerts() {
    return _repository.getActiveAlerts();
  }

  Stream<List<MonitoringAlert>> watchActiveAlerts() {
    return _repository.watchActiveAlerts();
  }

  Future<void> acknowledgeAlert(String alertId) {
    return _repository.acknowledgeAlert(alertId);
  }

  Future<void> setThreshold(String componentId, double threshold) async {
    _alertThresholds[componentId] = threshold;
  }
}
