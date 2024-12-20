import 'package:equatable/equatable.dart';
import 'package:experiment_planner/domain/entities/machine/parameter.dart';

class ParameterDTO extends Equatable {
  final String id;
  final String name;
  final double currentValue;
  final double minValue;
  final double maxValue;
  final String unit;
  final bool isAdjustable;
  final String lastUpdated;

  const ParameterDTO({
    required this.id,
    required this.name,
    required this.currentValue,
    required this.minValue,
    required this.maxValue,
    required this.unit,
    required this.isAdjustable,
    required this.lastUpdated,
  });

  factory ParameterDTO.fromJson(Map<String, dynamic> json) {
    return ParameterDTO(
      id: json['id'] as String,
      name: json['name'] as String,
      currentValue: json['currentValue'] as double,
      minValue: json['minValue'] as double,
      maxValue: json['maxValue'] as double,
      unit: json['unit'] as String,
      isAdjustable: json['isAdjustable'] as bool,
      lastUpdated: json['lastUpdated'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'currentValue': currentValue,
    'minValue': minValue,
    'maxValue': maxValue,
    'unit': unit,
    'isAdjustable': isAdjustable,
    'lastUpdated': lastUpdated,
  };

  Parameter toDomain() => Parameter(
    id: id,
    name: name,
    currentValue: currentValue,
    minValue: minValue,
    maxValue: maxValue,
    unit: unit,
    isAdjustable: isAdjustable,
    lastUpdated: DateTime.parse(lastUpdated),
  );

  factory ParameterDTO.fromDomain(Parameter parameter) => ParameterDTO(
    id: parameter.id,
    name: parameter.name,
    currentValue: parameter.currentValue,
    minValue: parameter.minValue,
    maxValue: parameter.maxValue,
    unit: parameter.unit,
    isAdjustable: parameter.isAdjustable,
    lastUpdated: parameter.lastUpdated.toIso8601String(),
  );

  @override
  List<Object?> get props => [
    id,
    name,
    currentValue,
    minValue,
    maxValue,
    unit,
    isAdjustable,
    lastUpdated,
  ];
}
