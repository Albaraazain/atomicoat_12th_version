import 'package:equatable/equatable.dart';
import 'package:experiment_planner/domain/entities/machine/machine.dart';
import '../../../../domain/entities/alert/abstract_alert.dart';

abstract class MachineState extends Equatable {
  const MachineState();

  @override
  List<Object?> get props => [];
}

class MachineInitial extends MachineState {}

class MachineLoading extends MachineState {}

class MachineMonitoring extends MachineState {
  final Machine machine;
  final List<AbstractAlert> activeAlerts;  // Changed from Alert to AbstractAlert
  final bool isUpdatingParameter;

  const MachineMonitoring({
    required this.machine,
    required this.activeAlerts,
    this.isUpdatingParameter = false,
  });

  @override
  List<Object?> get props => [machine, activeAlerts, isUpdatingParameter];

  MachineMonitoring copyWith({
    Machine? machine,
    List<AbstractAlert>? activeAlerts,  // Changed from Alert to AbstractAlert
    bool? isUpdatingParameter,
  }) {
    return MachineMonitoring(
      machine: machine ?? this.machine,
      activeAlerts: activeAlerts ?? this.activeAlerts,
      isUpdatingParameter: isUpdatingParameter ?? this.isUpdatingParameter,
    );
  }
}

class MachineError extends MachineState {
  final String message;

  const MachineError(this.message);

  @override
  List<Object?> get props => [message];
}
