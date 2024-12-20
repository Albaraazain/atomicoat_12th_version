import 'package:equatable/equatable.dart';
import '../../../../domain/entities/alert/abstract_alert.dart';

class AlertState extends Equatable {
  final List<AbstractAlert> activeAlerts;
  final List<AbstractAlert> alertHistory;
  final bool isLoading;
  final String? error;

  const AlertState({
    this.activeAlerts = const [],
    this.alertHistory = const [],
    this.isLoading = false,
    this.error,
  });

  AlertState copyWith({
    List<AbstractAlert>? activeAlerts,
    List<AbstractAlert>? alertHistory,
    bool? isLoading,
    String? error,
  }) {
    return AlertState(
      activeAlerts: activeAlerts ?? this.activeAlerts,
      alertHistory: alertHistory ?? this.alertHistory,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [activeAlerts, alertHistory, isLoading, error];
}
