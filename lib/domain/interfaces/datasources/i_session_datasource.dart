// lib/domain/interfaces/datasources/i_session_datasource.dart

import 'package:experiment_planner/domain/models/session/session.dart';
import 'package:experiment_planner/domain/models/session/session_log.dart';
import 'package:experiment_planner/domain/models/session/sensor_reading.dart';
import 'package:experiment_planner/domain/models/session/session_result.dart';
import 'package:experiment_planner/domain/enums/session_enums.dart';
import 'package:experiment_planner/domain/models/process/process_event.dart';

abstract class ISessionDataSource {
  /// Starts a new experimental session
  Future<String> startSession(Session session);

  /// Ends an active session
  Future<void> endSession(String sessionId);

  /// Gets session by ID
  Future<Session?> getSession(String sessionId);

  /// Gets sessions for a specific machine
  Future<List<Session>> getMachineSessions(
    String machineId, {
    DateTime? startDate,
    DateTime? endDate,
    SessionStatus? status,
  });

  /// Gets sessions for a specific user
  Future<List<Session>> getUserSessions(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
    SessionStatus? status,
  });

  /// Adds a log entry to the session
  Future<void> addSessionLog(String sessionId, SessionLog log);

  /// Gets session logs
  Future<List<SessionLog>> getSessionLogs(
    String sessionId, {
    DateTime? startTime,
    DateTime? endTime,
    LogLevel? minLevel,
  });

  /// Records a sensor reading
  Future<void> addSensorReading(String sessionId, SensorReading reading);

  /// Gets sensor readings for a session
  Future<List<SensorReading>> getSensorReadings(
    String sessionId,
    String sensorId, {
    DateTime? startTime,
    DateTime? endTime,
  });

  /// Records a process event
  Future<void> recordProcessEvent(String sessionId, ProcessEvent event);

  /// Gets process events for a session
  Future<List<ProcessEvent>> getProcessEvents(
    String sessionId, {
    DateTime? startTime,
    DateTime? endTime,
    EventType? type,
  });

  /// Updates session status
  Future<void> updateSessionStatus(String sessionId, SessionStatus status);

  /// Saves session results
  Future<void> saveSessionResult(String sessionId, SessionResult result);

  /// Gets session results
  Future<SessionResult?> getSessionResult(String sessionId);

  /// Streams session updates
  Stream<Session> watchSession(String sessionId);

  /// Streams sensor readings
  Stream<SensorReading> watchSensorReadings(String sessionId, String sensorId);

  /// Gets session statistics
  Future<SessionStatistics> getSessionStatistics(
    String sessionId, {
    DateTime? startTime,
    DateTime? endTime,
  });

  /// Gets quality control data
  Future<QualityControlData> getQualityControlData(String sessionId);

  /// Validates session data
  Future<SessionValidation> validateSessionData(String sessionId);

  /// Exports session data
  Future<String> exportSessionData(
    String sessionId,
    SessionDataExportFormat format, {
    ExportOptions? options,
  });

  /// Archives session data
  Future<void> archiveSession(String sessionId);

  /// Retrieves archived session data
  Future<Session?> getArchivedSession(String sessionId);
}

/// Session statistics
class SessionStatistics {
  final Duration totalDuration;
  final int cycleCount;
  final Map<String, ParameterStatistics> parameterStats;
  final Map<ProcessPhase, Duration> phaseDurations;
  final double processEfficiency;
  final Map<String, int> eventCounts;

  SessionStatistics({
    required this.totalDuration,
    required this.cycleCount,
    required this.parameterStats,
    required this.phaseDurations,
    required this.processEfficiency,
    required this.eventCounts,
  });
}

/// Statistics for a specific parameter
class ParameterStatistics {
  final double minimum;
  final double maximum;
  final double average;
  final double standardDeviation;
  final double stability;
  final List<Deviation> significantDeviations;

  ParameterStatistics({
    required this.minimum,
    required this.maximum,
    required this.average,
    required this.standardDeviation,
    required this.stability,
    required this.significantDeviations,
  });
}

/// Represents a significant deviation in parameters
class Deviation {
  final DateTime timestamp;
  final double value;
  final double expectedValue;
  final String parameter;
  final String? cause;

  Deviation({
    required this.timestamp,
    required this.value,
    required this.expectedValue,
    required this.parameter,
    this.cause,
  });
}

/// Quality control data for the session
class QualityControlData {
  final double filmThickness;
  final double uniformity;
  final double growthRate;
  final Map<String, double> composition;
  final List<QualityIssue> issues;
  final ValidationStatus status;

  QualityControlData({
    required this.filmThickness,
    required this.uniformity,
    required this.growthRate,
    required this.composition,
    required this.issues,
    required this.status,
  });
}

/// Represents a quality control issue
class QualityIssue {
  final String parameter;
  final String description;
  final double severity;
  final String? recommendation;
  final DateTime timestamp;

  QualityIssue({
    required this.parameter,
    required this.description,
    required this.severity,
    this.recommendation,
    required this.timestamp,
  });
}

/// Session data validation results
class SessionValidation {
  final bool isValid;
  final List<ValidationError> errors;
  final List<ValidationWarning> warnings;
  final Map<String, List<String>> parameterIssues;

  SessionValidation({
    required this.isValid,
    required this.errors,
    required this.warnings,
    required this.parameterIssues,
  });
}

/// Validation error details
class ValidationError {
  final String code;
  final String message;
  final String? parameter;
  final DateTime timestamp;

  ValidationError({
    required this.code,
    required this.message,
    this.parameter,
    required this.timestamp,
  });
}

/// Validation warning details
class ValidationWarning {
  final String code;
  final String message;
  final String? parameter;
  final String? recommendation;

  ValidationWarning({
    required this.code,
    required this.message,
    this.parameter,
    this.recommendation,
  });
}

/// Options for data export
class ExportOptions {
  final bool includeRawData;
  final bool includeProcessedData;
  final bool includeLogs;
  final bool includeEvents;
  final bool includeQualityData;
  final List<String>? specificParameters;
  final DateTime? startTime;
  final DateTime? endTime;

  ExportOptions({
    this.includeRawData = true,
    this.includeProcessedData = true,
    this.includeLogs = true,
    this.includeEvents = true,
    this.includeQualityData = true,
    this.specificParameters,
    this.startTime,
    this.endTime,
  });
}