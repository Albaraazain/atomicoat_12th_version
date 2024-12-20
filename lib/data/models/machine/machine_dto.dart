// lib/data/models/machine/machine_dto.dart
import 'package:equatable/equatable.dart';
import 'package:experiment_planner/data/models/machine/component_dto.dart';
import 'package:experiment_planner/domain/entities/machine/machine.dart';
import 'package:experiment_planner/domain/enums/machine_enums.dart';

class MachineDTO extends Equatable {
  final String id;
  final String serialNumber;
  final String name;
  final String status;
  final List<ComponentDTO> components;
  final DateTime lastMaintenanceDate;
  final DateTime installationDate;

  const MachineDTO({
    required this.id,
    required this.serialNumber,
    required this.name,
    required this.status,
    required this.components,
    required this.lastMaintenanceDate,
    required this.installationDate,
  });

  factory MachineDTO.fromJson(Map<String, dynamic> json) {
    return MachineDTO(
      id: json['id'] as String,
      serialNumber: json['serialNumber'] as String,
      name: json['name'] as String,
      status: json['status'] as String,
      components: (json['components'] as List)
          .map((e) => ComponentDTO.fromJson(e))
          .toList(),
      lastMaintenanceDate: DateTime.parse(json['lastMaintenanceDate']),
      installationDate: DateTime.parse(json['installationDate']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'serialNumber': serialNumber,
    'name': name,
    'status': status,
    'components': components.map((e) => e.toJson()).toList(),
    'lastMaintenanceDate': lastMaintenanceDate.toIso8601String(),
    'installationDate': installationDate.toIso8601String(),
  };

  Machine toDomain() {
    return Machine(
      id: id,
      serialNumber: serialNumber,
      name: name,
      status: MachineStatus.values.firstWhere(
        (e) => e.toString().split('.').last == status,
      ),
      components: components.map((e) => e.toDomain()).toList(),
      lastMaintenanceDate: lastMaintenanceDate,
      installationDate: installationDate,
    );
  }

  factory MachineDTO.fromDomain(Machine machine) {
    return MachineDTO(
      id: machine.id,
      serialNumber: machine.serialNumber,
      name: machine.name,
      status: machine.status.toString().split('.').last,
      components: machine.components
          .map((e) => ComponentDTO.fromDomain(e))
          .toList(),
      lastMaintenanceDate: machine.lastMaintenanceDate,
      installationDate: machine.installationDate,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}