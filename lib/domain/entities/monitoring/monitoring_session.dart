import 'package:equatable/equatable.dart';
import 'package:experiment_planner/domain/value_objects/monitoring/measurement_value.dart';

class MonitoringSession extends Equatable {
  final String id;
  final String machineId;
  final DateTime startTime;
  final DateTime? endTime;
  final String initiatedBy;
  final Map<String, List<MeasurementValue>> measurements;
  final bool isActive;

  const MonitoringSession({
    required this.id,
    required this.machineId,
    required this.startTime,
    this.endTime,
    required this.initiatedBy,
    required this.measurements,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
    id, machineId, startTime, endTime,
    initiatedBy, measurements, isActive
  ];
}
