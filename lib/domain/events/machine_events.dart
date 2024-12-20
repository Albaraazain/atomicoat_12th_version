// lib/domain/events/machine_events.dart
import 'package:equatable/equatable.dart';
import 'package:experiment_planner/domain/enums/machine_enums.dart';

abstract class MachineEvent extends Equatable {
  const MachineEvent();

  @override
  List<Object?> get props => [];
}

class MachineStatusChanged extends MachineEvent {
  final String machineId;
  final MachineStatus oldStatus;
  final MachineStatus newStatus;
  final DateTime timestamp;

  const MachineStatusChanged({
    required this.machineId,
    required this.oldStatus,
    required this.newStatus,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [machineId, oldStatus, newStatus, timestamp];
}

class ComponentParameterUpdated extends MachineEvent {
  final String machineId;
  final String componentId;
  final String parameterId;
  final double oldValue;
  final double newValue;
  final DateTime timestamp;

  const ComponentParameterUpdated({
    required this.machineId,
    required this.componentId,
    required this.parameterId,
    required this.oldValue,
    required this.newValue,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
    machineId,
    componentId,
    parameterId,
    oldValue,
    newValue,
    timestamp,
  ];
}
