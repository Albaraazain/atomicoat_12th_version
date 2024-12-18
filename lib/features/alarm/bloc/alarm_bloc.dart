import 'package:experiment_planner/features/alarm/models/alarm.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/alarm_repository.dart';
import 'alarm_event.dart';
import 'alarm_state.dart';

class AlarmBloc extends Bloc<AlarmEvent, AlarmState> {
  final AlarmRepository _repository;
  final String? userId;

  AlarmBloc(this._repository, this.userId) : super(AlarmInitial()) {
    on<LoadAlarmsEvent>(_onLoadAlarms);
    on<AddAlarmEvent>(_onAddAlarm);
    on<AddSafetyAlarmEvent>(_onAddSafetyAlarm);
    on<AcknowledgeAlarmEvent>(_onAcknowledgeAlarm);
    on<ClearAlarmEvent>(_onClearAlarm);
    on<ClearAllAcknowledgedAlarmsEvent>(_onClearAllAcknowledgedAlarms);

    if (userId != null) {
      add(LoadAlarmsEvent(userId!));
    }
  }

  Future<void> _onLoadAlarms(
    LoadAlarmsEvent event,
    Emitter<AlarmState> emit,
  ) async {
    emit(AlarmLoadInProgress());
    try {
      final history = await _repository.getAll(userId: event.userId);
      final active = await _repository.getActiveAlarms(event.userId);
      emit(AlarmLoadSuccess(activeAlarms: active, alarmHistory: history));
    } catch (e) {
      emit(AlarmLoadFailure(e.toString()));
    }
  }

  Future<void> _onAddAlarm(
    AddAlarmEvent event,
    Emitter<AlarmState> emit,
  ) async {
    try {
      await _repository.add(event.alarm.id, event.alarm, userId: event.userId);

      if (state is AlarmLoadSuccess) {
        final currentState = state as AlarmLoadSuccess;
        emit(AlarmLoadSuccess(
          activeAlarms: [...currentState.activeAlarms, event.alarm],
          alarmHistory: [...currentState.alarmHistory, event.alarm],
        ));
      }
    } catch (e) {
      emit(AlarmLoadFailure(e.toString()));
    }
  }

  Future<void> _onAddSafetyAlarm(
    AddSafetyAlarmEvent event,
    Emitter<AlarmState> emit,
  ) async {
    final newAlarm = Alarm(
      id: event.id,
      message: event.message,
      severity: event.severity,
      timestamp: DateTime.now(),
      isSafetyAlert: true,
    );
    add(AddAlarmEvent(newAlarm, event.userId));
  }

  Future<void> _onAcknowledgeAlarm(
    AcknowledgeAlarmEvent event,
    Emitter<AlarmState> emit,
  ) async {
    if (state is! AlarmLoadSuccess) return;
    final currentState = state as AlarmLoadSuccess;

    try {
      final alarmIndex = currentState.activeAlarms
          .indexWhere((alarm) => alarm.id == event.alarmId);

      if (alarmIndex != -1) {
        final alarm = currentState.activeAlarms[alarmIndex];
        final updatedAlarm = alarm.copyWith(acknowledged: true);

        await _repository.update(event.alarmId, updatedAlarm, userId: event.userId);

        final newActiveAlarms = List<Alarm>.from(currentState.activeAlarms)
          ..removeAt(alarmIndex);

        final newHistory = List<Alarm>.from(currentState.alarmHistory);
        final historyIndex = newHistory
            .indexWhere((alarm) => alarm.id == event.alarmId);
        if (historyIndex != -1) {
          newHistory[historyIndex] = updatedAlarm;
        }

        emit(AlarmLoadSuccess(
          activeAlarms: newActiveAlarms,
          alarmHistory: newHistory,
        ));
      }
    } catch (e) {
      emit(AlarmLoadFailure(e.toString()));
    }
  }

  Future<void> _onClearAlarm(
    ClearAlarmEvent event,
    Emitter<AlarmState> emit,
  ) async {
    if (state is! AlarmLoadSuccess) return;
    final currentState = state as AlarmLoadSuccess;

    try {
      await _repository.remove(event.alarmId, userId: event.userId);

      emit(AlarmLoadSuccess(
        activeAlarms: currentState.activeAlarms
            .where((alarm) => alarm.id != event.alarmId)
            .toList(),
        alarmHistory: currentState.alarmHistory
            .where((alarm) => alarm.id != event.alarmId)
            .toList(),
      ));
    } catch (e) {
      emit(AlarmLoadFailure(e.toString()));
    }
  }

  Future<void> _onClearAllAcknowledgedAlarms(
    ClearAllAcknowledgedAlarmsEvent event,
    Emitter<AlarmState> emit,
  ) async {
    if (state is! AlarmLoadSuccess) return;
    final currentState = state as AlarmLoadSuccess;

    try {
      await _repository.clearAcknowledged(event.userId);

      emit(AlarmLoadSuccess(
        activeAlarms: currentState.activeAlarms,
        alarmHistory: currentState.alarmHistory
            .where((alarm) => !alarm.acknowledged)
            .toList(),
      ));
    } catch (e) {
      emit(AlarmLoadFailure(e.toString()));
    }
  }
}