// lib/domain/events/session_events.dart
import 'package:equatable/equatable.dart';

abstract class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object?> get props => [];
}

class SessionStarted extends SessionEvent {
  final String sessionId;
  final String userId;
  final String machineId;
  final String? recipeId;
  final DateTime timestamp;

  const SessionStarted({
    required this.sessionId,
    required this.userId,
    required this.machineId,
    this.recipeId,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
    sessionId,
    userId,
    machineId,
    recipeId,
    timestamp,
  ];
}

