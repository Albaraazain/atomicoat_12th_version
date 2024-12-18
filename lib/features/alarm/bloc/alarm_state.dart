import 'package:equatable/equatable.dart';
import 'package:experiment_planner/features/alarm/models/alarm.dart';


sealed class AlarmState extends Equatable {
  const AlarmState();

  @override
  List<Object?> get props => [];
}

class AlarmInitial extends AlarmState {}

class AlarmLoadInProgress extends AlarmState {}

class AlarmLoadSuccess extends AlarmState {
  final List<Alarm> activeAlarms;
  final List<Alarm> alarmHistory;

  const AlarmLoadSuccess({
    required this.activeAlarms,
    required this.alarmHistory,
  });

  @override
  List<Object?> get props => [activeAlarms, alarmHistory];

  List<Alarm> get criticalAlarms =>
    activeAlarms.where((alarm) => alarm.severity == AlarmSeverity.critical).toList();

  bool get hasActiveAlarms => activeAlarms.isNotEmpty;
  bool get hasCriticalAlarm =>
    activeAlarms.any((alarm) => alarm.severity == AlarmSeverity.critical);

  List<Alarm> getAlarmsBySeverity(AlarmSeverity severity) {
    return activeAlarms.where((alarm) => alarm.severity == severity).toList();
  }

  List<Alarm> getRecentAlarms({int count = 5}) {
    return alarmHistory.reversed.take(count).toList();
  }

  Map<String, int> getAlarmStatistics() {
    return {
      'total': alarmHistory.length,
      'critical': alarmHistory.where((a) => a.severity == AlarmSeverity.critical).length,
      'warning': alarmHistory.where((a) => a.severity == AlarmSeverity.warning).length,
      'info': alarmHistory.where((a) => a.severity == AlarmSeverity.info).length,
      'acknowledged': alarmHistory.where((a) => a.acknowledged).length,
      'unacknowledged': alarmHistory.where((a) => !a.acknowledged).length,
    };
  }
}

class AlarmLoadFailure extends AlarmState {
  final String error;
  const AlarmLoadFailure(this.error);

  @override
  List<Object?> get props => [error];
}