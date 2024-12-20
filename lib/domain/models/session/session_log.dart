// lib/domain/entities/session/session_log.dart
import 'package:equatable/equatable.dart';
import 'package:experiment_planner/domain/enums/session_enums.dart';

class SessionLog extends Equatable {
  final String id;
  final DateTime timestamp;
  final LogLevel level;
  final String message;
  final String? componentId;
  final Map<String, dynamic> metadata;

  const SessionLog({
    required this.id,
    required this.timestamp,
    required this.level,
    required this.message,
    this.componentId,
    required this.metadata,
  });

  @override
  List<Object?> get props => [
    id,
    timestamp,
    level,
    message,
    componentId,
    metadata
  ];
}

