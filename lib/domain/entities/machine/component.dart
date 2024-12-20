// lib/domain/entities/machine/component.dart
import 'package:equatable/equatable.dart';
import 'package:experiment_planner/domain/entities/machine/parameter.dart';
import 'package:experiment_planner/domain/enums/component_enums.dart';

class Component extends Equatable {
  final String id;
  final String name;
  final ComponentType type;
  final ComponentStatus status;
  final List<Parameter> parameters;
  final HealthStatus healthStatus;
  final DateTime lastMaintenanceDate;

  const Component({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.parameters,
    required this.healthStatus,
    required this.lastMaintenanceDate,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    status,
    parameters,
    healthStatus,
    lastMaintenanceDate
  ];
}

