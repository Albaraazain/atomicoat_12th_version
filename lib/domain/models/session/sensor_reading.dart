import 'package:equatable/equatable.dart';

class SensorReading extends Equatable {
  final String id;
  final DateTime timestamp;
  final String sensorId;
  final double value;
  final String unit;
  final bool isValid;
  final Map<String, dynamic>? metadata;

  const SensorReading({
    required this.id,
    required this.timestamp,
    required this.sensorId,
    required this.value,
    required this.unit,
    this.isValid = true,
    this.metadata,
  });

  @override
  List<Object?> get props => [
    id,
    timestamp,
    sensorId,
    value,
    unit,
    isValid,
    metadata,
  ];
}
