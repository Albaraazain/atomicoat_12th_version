
import 'package:experiment_planner/domain/entities/alert/monitoring_alert.dart';

abstract class IAlertRepository {
  Future<List<MonitoringAlert>> getActiveAlerts();
  Future<List<MonitoringAlert>> getAlertHistory({int? limit});
  Future<void> saveAlert(MonitoringAlert alert);
  Future<void> acknowledgeAlert(String alertId);
  Future<void> muteAlert(String alertId);
  Future<void> unmuteAlert(String alertId);
  Stream<List<MonitoringAlert>> watchActiveAlerts();
  Future<void> deleteAlert(String alertId);
  Future<void> clearAlertHistory();
}
