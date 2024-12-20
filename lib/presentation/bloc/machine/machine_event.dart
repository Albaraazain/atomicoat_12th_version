import 'package:equatable/equatable.dart';
import 'package:experiment_planner/domain/entities/machine/machine.dart';

abstract class MachineEvent extends Equatable {
  const MachineEvent();

  @override
  List<Object?> get props => [];
}

class StartMachineMonitoring extends MachineEvent {
  final String machineId;

  const StartMachineMonitoring(this.machineId);

  @override
  List<Object?> get props => [machineId];
}

class StopMachineMonitoring extends MachineEvent {}

class UpdateParameter extends MachineEvent {
  final String componentId;
  final String parameterId;
  final double value;

  const UpdateParameter({
    required this.componentId,
    required this.parameterId,
    required this.value,
  });

  @override
  List<Object?> get props => [componentId, parameterId, value];
}

class UpdateMachineState extends MachineEvent {
  final Machine machine;

  const UpdateMachineState(this.machine);

  @override
  List<Object?> get props => [machine];
}

class MonitoringError extends MachineEvent {
  final String error;

  const MonitoringError(this.error);

  @override
  List<Object?> get props => [error];
}

