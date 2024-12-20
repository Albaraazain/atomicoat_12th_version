import 'package:equatable/equatable.dart';

class ProcessEvent extends Equatable {
  final String id;
  final DateTime timestamp;
  final EventType type;
  final String description;
  final Map<String, dynamic>? data;

  const ProcessEvent({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.description,
    this.data,
  });

  @override
  List<Object?> get props => [id, timestamp, type, description, data];
}

enum EventType {
  info,
  warning,
  error,
  milestone,
  phaseChange,
  parameterChange
}
