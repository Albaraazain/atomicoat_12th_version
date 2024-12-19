import '../../../features/alarm/bloc/alarm_bloc.dart';
import '../../../features/alarm/bloc/alarm_event.dart';
import '../../../features/alarm/bloc/alarm_state.dart';
import '../../../features/alarm/models/alarm.dart';
import '../models/safety_error.dart';

class AlarmHandlingService {
  final AlarmBloc _alarmBloc;

  AlarmHandlingService(this._alarmBloc);

  void addAlarm(String userId, String message, AlarmSeverity severity) {
    if (userId.isEmpty) return;

    final newAlarm = Alarm(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: message,
      severity: severity,
      timestamp: DateTime.now(),
    );

    _alarmBloc.add(AddAlarmEvent(newAlarm, userId));
  }

  void acknowledgeAlarm(String userId, String alarmId) {
    if (userId.isEmpty) return;
    _alarmBloc.add(AcknowledgeAlarmEvent(alarmId, userId));
  }

  void clearAlarm(String userId, String alarmId) {
    if (userId.isEmpty) return;
    _alarmBloc.add(ClearAlarmEvent(alarmId, userId));
  }

  void clearAllAcknowledgedAlarms(String userId) {
    if (userId.isEmpty) return;
    _alarmBloc.add(ClearAllAcknowledgedAlarmsEvent(userId));
  }

  void triggerSafetyAlert(String userId, SafetyError error) {
    if (userId.isEmpty) return;

    final alarm = Alarm(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: error.description,
      severity: _mapSeverityToAlarmSeverity(error.severity),
      timestamp: DateTime.now(),
    );

    _alarmBloc.add(AddAlarmEvent(alarm, userId));
  }

  AlarmSeverity _mapSeverityToAlarmSeverity(SafetyErrorSeverity severity) {
    switch (severity) {
      case SafetyErrorSeverity.warning:
        return AlarmSeverity.warning;
      case SafetyErrorSeverity.critical:
        return AlarmSeverity.critical;
      default:
        return AlarmSeverity.info;
    }
  }

  List<Alarm> getActiveAlarms() {
    final state = _alarmBloc.state;
    return state is AlarmLoadSuccess ? state.activeAlarms : [];
  }
}
