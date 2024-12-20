// lib/domain/entities/machine/machine.dart
import 'package:equatable/equatable.dart';
import 'package:experiment_planner/domain/entities/machine/component.dart';
import 'package:experiment_planner/domain/enums/machine_enums.dart';

class Machine extends Equatable {
  final String id;
  final String serialNumber;
  final String name;
  final MachineStatus status;
  final List<Component> components;
  final DateTime lastMaintenanceDate;
  final DateTime installationDate;

  const Machine({
    required this.id,
    required this.serialNumber,
    required this.name,
    required this.status,
    required this.components,
    required this.lastMaintenanceDate,
    required this.installationDate,
  });

  @override
  List<Object?> get props => [
    id,
    serialNumber,
    name,
    status,
    components,
    lastMaintenanceDate,
    installationDate
  ];
}

