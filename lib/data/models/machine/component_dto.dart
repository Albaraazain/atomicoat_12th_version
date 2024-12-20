import 'package:equatable/equatable.dart';
import 'package:experiment_planner/domain/entities/machine/component.dart';
import 'package:experiment_planner/domain/entities/machine/parameter.dart';
import 'package:experiment_planner/domain/enums/component_enums.dart';
import 'package:experiment_planner/data/models/machine/parameter_dto.dart';

class ComponentDTO extends Equatable {
  final String id;
  final String name;
  final String type;
  final String status;
  final List<Map<String, dynamic>> parameters;
  final String healthStatus;
  final DateTime lastMaintenanceDate;

  const ComponentDTO({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.parameters,
    required this.healthStatus,
    required this.lastMaintenanceDate,
  });

  factory ComponentDTO.fromJson(Map<String, dynamic> json) {
    return ComponentDTO(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      parameters: List<Map<String, dynamic>>.from(json['parameters'] ?? []),
      healthStatus: json['healthStatus'] as String,
      lastMaintenanceDate: DateTime.parse(json['lastMaintenanceDate']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'status': status,
    'parameters': parameters,
    'healthStatus': healthStatus,
    'lastMaintenanceDate': lastMaintenanceDate.toIso8601String(),
  };

  Component toDomain() {
    return Component(
      id: id,
      name: name,
      type: ComponentType.values.firstWhere(
        (e) => e.toString().split('.').last == type,
      ),
      status: ComponentStatus.fromString(status),
      parameters: parameters.map((p) => ParameterDTO.fromJson(p).toDomain()).toList(),
      healthStatus: HealthStatus.values.firstWhere(
        (e) => e.toString().split('.').last == healthStatus,
      ),
      lastMaintenanceDate: lastMaintenanceDate,
    );
  }

  factory ComponentDTO.fromDomain(Component component) {
    return ComponentDTO(
      id: component.id,
      name: component.name,
      type: component.type.toString().split('.').last,
      status: component.status.name,
      parameters: component.parameters
          .map((p) => ParameterDTO.fromDomain(p).toJson())
          .toList(),
      healthStatus: component.healthStatus.toString().split('.').last,
      lastMaintenanceDate: component.lastMaintenanceDate,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    status,
    parameters,
    healthStatus,
    lastMaintenanceDate,
  ];
}
