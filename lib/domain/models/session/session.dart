// lib/domain/entities/session/session.dart
import 'package:equatable/equatable.dart';
import 'package:experiment_planner/domain/models/session/session_log.dart';
import 'package:experiment_planner/domain/models/session/sensor_reading.dart';
import 'package:experiment_planner/domain/enums/session_enums.dart';

class Session extends Equatable {
  final String id;
  final String userId;
  final String machineId;
  final String? recipeId;
  final SessionStatus status;
  final DateTime startTime;
  final DateTime? endTime;
  final String description;
  final List<SessionLog> logs;
  final List<SensorReading> readings;

  const Session({
    required this.id,
    required this.userId,
    required this.machineId,
    this.recipeId,
    required this.status,
    required this.startTime,
    this.endTime,
    required this.description,
    required this.logs,
    required this.readings,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    machineId,
    recipeId,
    status,
    startTime,
    endTime,
    description,
    logs,
    readings
  ];
}