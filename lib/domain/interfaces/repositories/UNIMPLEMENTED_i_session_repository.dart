// lib/domain/repositories/session_repository.dart
import 'package:dartz/dartz.dart';
import 'package:experiment_planner/domain/models/session/sensor_reading.dart';
import 'package:experiment_planner/domain/models/session/session.dart';
import 'package:experiment_planner/domain/models/session/session_log.dart';
import 'package:experiment_planner/domain/failures/failures.dart';

abstract class SessionRepository {
  Future<Either<Failure, Session>> getSession(String id);
  Future<Either<Failure, List<Session>>> getMachineSessions(String machineId);
  Future<Either<Failure, List<Session>>> getUserSessions(String userId);
  Future<Either<Failure, String>> startSession(Session session);
  Future<Either<Failure, void>> endSession(String sessionId);
  Future<Either<Failure, void>> addSessionLog(String sessionId, SessionLog log);
  Future<Either<Failure, void>> addSensorReading(
    String sessionId,
    SensorReading reading,
  );
  Stream<Either<Failure, Session>> monitorSession(String sessionId);
}
