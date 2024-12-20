import 'package:equatable/equatable.dart';
import '../../../../domain/entities/alert/abstract_alert.dart';

abstract class AlertEvent extends Equatable {
  const AlertEvent();

  @override
  List<Object?> get props => [];
}

class StartAlertMonitoring extends AlertEvent {}

class StopAlertMonitoring extends AlertEvent {}

class NewAlertReceived extends AlertEvent {
  final AbstractAlert alert;

  const NewAlertReceived(this.alert);

  @override
  List<Object> get props => [alert];
}

class AcknowledgeAlert extends AlertEvent {
  final String alertId;

  const AcknowledgeAlert({required this.alertId});

  @override
  List<Object> get props => [alertId];
}

class ToggleAlertMute extends AlertEvent {
  final String alertId;

  const ToggleAlertMute({required this.alertId});

  @override
  List<Object> get props => [alertId];
}

class MuteAllAlerts extends AlertEvent {}

class ClearResolvedAlerts extends AlertEvent {}
