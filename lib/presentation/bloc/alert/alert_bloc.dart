import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/alert/abstract_alert.dart';
import '../../../../domain/entities/alert/system_alert.dart';
import '../../../../domain/entities/alert/monitoring_alert.dart';
import '../../../../domain/services/notification/notification_service.dart';
import 'alert_event.dart';
import 'alert_state.dart';

class AlertBloc extends Bloc<AlertEvent, AlertState> {
  final NotificationService _notificationService;
  StreamSubscription<AbstractAlert>? _alertSubscription;  // Updated type here

  AlertBloc({
    required NotificationService notificationService,
  })  : _notificationService = notificationService,
        super(const AlertState()) {
    on<StartAlertMonitoring>(_onStartMonitoring);
    on<StopAlertMonitoring>(_onStopMonitoring);
    on<NewAlertReceived>(_onNewAlert);
    on<AcknowledgeAlert>(_onAcknowledgeAlert);
    on<ToggleAlertMute>(_onToggleAlertMute);
    on<MuteAllAlerts>(_onMuteAllAlerts);
    on<ClearResolvedAlerts>(_onClearResolvedAlerts);
  }

  Future<void> _onStartMonitoring(
    StartAlertMonitoring event,
    Emitter<AlertState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    // Initialize notification service
    await _notificationService.initialize();
    emit(state.copyWith(isLoading: false));
  }

  Future<void> _onStopMonitoring(
    StopAlertMonitoring event,
    Emitter<AlertState> emit,
  ) async {
    await _alertSubscription?.cancel();
    emit(const AlertState());
  }

  Future<void> _onNewAlert(
    NewAlertReceived event,
    Emitter<AlertState> emit,
  ) async {
    final alert = event.alert;

    if (alert is SystemAlert) {
      if (!alert.isResolved && !alert.isAcknowledged) {
        await _notificationService.showAlertNotification(alert);
        final updatedActiveAlerts = List<AbstractAlert>.from(state.activeAlerts)
          ..add(alert);
        emit(state.copyWith(activeAlerts: updatedActiveAlerts));
      }
    } else if (alert is MonitoringAlert) {
      await _notificationService.showAlertNotification(alert);
      final updatedActiveAlerts = List<AbstractAlert>.from(state.activeAlerts)
        ..add(alert);
      emit(state.copyWith(activeAlerts: updatedActiveAlerts));
    }
  }

  Future<void> _onAcknowledgeAlert(
    AcknowledgeAlert event,
    Emitter<AlertState> emit,
  ) async {
    final alert = state.activeAlerts
        .firstWhere((alert) => alert.id == event.alertId);

    if (alert is SystemAlert) {
      final acknowledgedAlert = alert.copyWith(
        isAcknowledged: true,
        acknowledgedAt: DateTime.now(),
      );

      final updatedActiveAlerts = state.activeAlerts
          .where((alert) => alert.id != event.alertId)
          .toList();

      final updatedHistory = List<AbstractAlert>.from(state.alertHistory)
        ..add(acknowledgedAlert);

      emit(state.copyWith(
        activeAlerts: updatedActiveAlerts,
        alertHistory: updatedHistory,
      ));
    }
  }

  void _onToggleAlertMute(
    ToggleAlertMute event,
    Emitter<AlertState> emit,
  ) {
    final updatedAlerts = state.activeAlerts.map((alert) {
      if (alert.id == event.alertId && alert is SystemAlert) {
        return alert.copyWith(isMuted: !alert.isMuted);
      }
      return alert;
    }).toList();

    emit(state.copyWith(activeAlerts: updatedAlerts));
  }

  void _onMuteAllAlerts(
    MuteAllAlerts event,
    Emitter<AlertState> emit,
  ) {
    final mutedAlerts = state.activeAlerts.map((alert) {
      if (alert is SystemAlert) {
        return alert.copyWith(isMuted: true);
      }
      return alert;
    }).toList();

    emit(state.copyWith(activeAlerts: mutedAlerts));
  }

  void _onClearResolvedAlerts(
    ClearResolvedAlerts event,
    Emitter<AlertState> emit,
  ) {
    final updatedHistory = state.alertHistory
        .where((alert) => !(alert is SystemAlert && alert.isResolved))
        .toList();

    emit(state.copyWith(alertHistory: updatedHistory));
  }

  @override
  Future<void> close() {
    _alertSubscription?.cancel();
    return super.close();
  }
}
