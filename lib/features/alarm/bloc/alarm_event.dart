import 'package:equatable/equatable.dart';
import 'package:experiment_planner/features/alarm/models/alarm.dart';

sealed class AlarmEvent extends Equatable {
  const AlarmEvent();

  @override
  List<Object?> get props => [];
}

class LoadAlarmsEvent extends AlarmEvent {
  final String userId;
  const LoadAlarmsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddAlarmEvent extends AlarmEvent {
  final Alarm alarm;
  final String userId;
  const AddAlarmEvent(this.alarm, this.userId);

  @override
  List<Object?> get props => [alarm, userId];
}

class AddSafetyAlarmEvent extends AlarmEvent {
  final String id;
  final String message;
  final AlarmSeverity severity;
  final String userId;

  const AddSafetyAlarmEvent({
    required this.id,
    required this.message,
    required this.severity,
    required this.userId,
  });

  @override
  List<Object?> get props => [id, message, severity, userId];
}

class AcknowledgeAlarmEvent extends AlarmEvent {
  final String alarmId;
  final String userId;
  const AcknowledgeAlarmEvent(this.alarmId, this.userId);

  @override
  List<Object?> get props => [alarmId, userId];
}

class ClearAlarmEvent extends AlarmEvent {
  final String alarmId;
  final String userId;
  const ClearAlarmEvent(this.alarmId, this.userId);

  @override
  List<Object?> get props => [alarmId, userId];
}

class ClearAllAcknowledgedAlarmsEvent extends AlarmEvent {
  final String userId;
  const ClearAllAcknowledgedAlarmsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}