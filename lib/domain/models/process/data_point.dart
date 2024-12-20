import 'package:equatable/equatable.dart';

class DataPoint extends Equatable {
  final DateTime timestamp;
  final double value;
  final String sensorId;
  final Map<String, dynamic>? metadata;

  const DataPoint({
    required this.timestamp,
    required this.value,
    required this.sensorId,
    this.metadata,
  });

  @override
  List<Object?> get props => [timestamp, value, sensorId, metadata];
}
