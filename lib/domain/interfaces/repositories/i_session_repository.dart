// lib/domain/interfaces/repositories/i_session_repository.dart

import 'package:dartz/dartz.dart';
import 'package:experiment_planner/domain/interfaces/datasources/i_session_datasource.dart';
import 'package:experiment_planner/domain/interfaces/repositories/i_recipe_repository.dart';
import 'package:experiment_planner/domain/models/session/session.dart';
import 'package:experiment_planner/domain/models/session/session_log.dart';
import 'package:experiment_planner/domain/models/session/sensor_reading.dart';
import 'package:experiment_planner/domain/models/session/session_result.dart';
import 'package:experiment_planner/domain/failures/failures.dart';
import 'package:experiment_planner/domain/enums/session_enums.dart';
import 'package:experiment_planner/domain/models/process/data_point.dart';

abstract class ISessionRepository {
  /// Starts a new experimental session
  Future<Either<Failure, String>> startSession(Session session);

  /// Ends an active session
  Future<Either<Failure, void>> endSession(String sessionId);

  /// Gets session by ID
  Future<Either<Failure, Session>> getSession(String sessionId);

  /// Gets sessions for a specific machine
  Future<Either<Failure, List<Session>>> getMachineSessions(
    String machineId, {
    DateTime? startDate,
    DateTime? endDate,
    SessionStatus? status,
  });

  /// Gets sessions for a specific user
  Future<Either<Failure, List<Session>>> getUserSessions(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
    SessionStatus? status,
  });

  /// Adds a log entry to the session
  Future<Either<Failure, void>> addSessionLog(String sessionId, SessionLog log);

  /// Gets session logs
  Future<Either<Failure, List<SessionLog>>> getSessionLogs(
    String sessionId, {
    DateTime? startTime,
    DateTime? endTime,
    LogLevel? minLevel,
  });

  /// Records a sensor reading
  Future<Either<Failure, void>> addSensorReading(
    String sessionId,
    SensorReading reading,
  );

  /// Gets sensor readings for a session
  Future<Either<Failure, List<SensorReading>>> getSensorReadings(
    String sessionId,
    String sensorId, {
    DateTime? startTime,
    DateTime? endTime,
  });

  /// Records session result
  Future<Either<Failure, void>> saveSessionResult(
    String sessionId,
    SessionResult result,
  );

  /// Gets session result
  Future<Either<Failure, SessionResult>> getSessionResult(String sessionId);

  /// Streams real-time session updates
  Stream<Either<Failure, Session>> watchSession(String sessionId);

  /// Streams real-time sensor readings
  Stream<Either<Failure, SensorReading>> watchSensorReadings(
    String sessionId,
    String sensorId,
  );

  /// Gets session statistics
  Future<Either<Failure, SessionStatistics>> getSessionStatistics(
    String sessionId, {
    DateTime? startTime,
    DateTime? endTime,
  });

  /// Gets quality control data
  Future<Either<Failure, QualityControlData>> getQualityControlData(
    String sessionId,
  );

  /// Validates session data
  Future<Either<Failure, SessionValidation>> validateSessionData(
    String sessionId,
  );

  /// Updates session metadata
  Future<Either<Failure, void>> updateSessionMetadata(
    String sessionId,
    Map<String, dynamic> metadata,
  );

  /// Gets aggregated session data
  Future<Either<Failure, AggregatedData>> getAggregatedData(
    String sessionId,
    AggregationConfig config,
  );

  /// Exports session data
  Future<Either<Failure, String>> exportSessionData(
    String sessionId,
    ExportConfig config,
  );
}

/// Session statistics
class SessionStatistics {
  final Duration totalDuration;
  final int cycleCount;
  final Map<String, ParameterStats> parameterStats;
  final Map<ProcessPhase, PhaseStats> phaseStats;
  final List<ProcessEvent> significantEvents;
  final Map<String, QualityMetric> qualityMetrics;

  SessionStatistics({
    required this.totalDuration,
    required this.cycleCount,
    required this.parameterStats,
    required this.phaseStats,
    required this.significantEvents,
    required this.qualityMetrics,
  });
}

/// Parameter statistics
class ParameterStats {
  final double minimum;
  final double maximum;
  final double average;
  final double standardDeviation;
  final double stability;
  final List<SessionParameterDeviation> deviations;
  final Map<String, double> correlations;

  ParameterStats({
    required this.minimum,
    required this.maximum,
    required this.average,
    required this.standardDeviation,
    required this.stability,
    required this.deviations,
    required this.correlations,
  });
}

/// Session parameter deviation
class SessionParameterDeviation {
  final DateTime timestamp;
  final String parameter;
  final double expectedValue;
  final double actualValue;
  final double significance;
  final String? cause;
  final SessionDeviationSeverity severity;

  SessionParameterDeviation({
    required this.timestamp,
    required this.parameter,
    required this.expectedValue,
    required this.actualValue,
    required this.significance,
    this.cause,
    required this.severity,
  });
}

/// Process phase statistics
class PhaseStats {
  final Duration averageDuration;
  final Duration minDuration;
  final Duration maxDuration;
  final double stability;
  final List<ProcessEvent> events;
  final Map<String, double> averageParameters;

  PhaseStats({
    required this.averageDuration,
    required this.minDuration,
    required this.maxDuration,
    required this.stability,
    required this.events,
    required this.averageParameters,
  });
}

/// Quality metric
class QualityMetric {
  final String name;
  final double value;
  final double target;
  final double deviation;
  final bool withinSpec;
  final String? note;

  QualityMetric({
    required this.name,
    required this.value,
    required this.target,
    required this.deviation,
    required this.withinSpec,
    this.note,
  });
}

/// Session validation
class SessionValidation {
  final bool isValid;
  final List<ValidationIssue> issues;
  final Map<String, List<ValidationIssue>> parameterIssues;
  final Map<ProcessPhase, List<ValidationIssue>> phaseIssues;
  final double validityScore;

  SessionValidation({
    required this.isValid,
    required this.issues,
    required this.parameterIssues,
    required this.phaseIssues,
    required this.validityScore,
  });
}

/// Aggregated data statistics
class AggregatedStats {
  final double mean;
  final double median;
  final double standardDeviation;
  final double min;
  final double max;
  final int count;
  final double sum;
  final Map<String, double> percentiles;
  final double variance;
  final double skewness;
  final double kurtosis;

  AggregatedStats({
    required this.mean,
    required this.median,
    required this.standardDeviation,
    required this.min,
    required this.max,
    required this.count,
    required this.sum,
    required this.percentiles,
    required this.variance,
    required this.skewness,
    required this.kurtosis,
  });
}

/// Aggregation configuration
class AggregationConfig {
  final Duration interval;
  final List<String> parameters;
  final List<AggregationType> types;
  final bool includeStats;
  final bool detectOutliers;

  AggregationConfig({
    required this.interval,
    required this.parameters,
    required this.types,
    required this.includeStats,
    required this.detectOutliers,
  });
}

/// Aggregated data
class AggregatedData {
  final List<TimeSlice> timeSlices;
  final Map<String, AggregatedStats> parameterStats;
  final List<DataPoint> outliers;
  final Map<String, TrendInfo> trends;

  AggregatedData({
    required this.timeSlices,
    required this.parameterStats,
    required this.outliers,
    required this.trends,
  });
}

/// Time slice of aggregated data
class TimeSlice {
  final DateTime startTime;
  final DateTime endTime;
  final Map<String, double> aggregatedValues;
  final ProcessPhase? phase;
  final List<ProcessEvent> events;

  TimeSlice({
    required this.startTime,
    required this.endTime,
    required this.aggregatedValues,
    this.phase,
    required this.events,
  });
}

/// Export configuration
class ExportConfig {
  final ExportFormat format;
  final List<String> parameters;
  final bool includeMetadata;
  final bool includeLogs;
  final bool includeEvents;
  final bool includeQualityData;
  final DateTime? startTime;
  final DateTime? endTime;
  final Duration? aggregationInterval;

  ExportConfig({
    required this.format,
    required this.parameters,
    required this.includeMetadata,
    required this.includeLogs,
    required this.includeEvents,
    required this.includeQualityData,
    this.startTime,
    this.endTime,
    this.aggregationInterval,
  });
}

/// Export formats
enum ExportFormat {
  csv,
  json,
  hdf5,
  excel
}

/// Aggregation types
enum AggregationType {
  average,
  minimum,
  maximum,
  standardDeviation,
  count,
  sum
}

/// Session deviation severity
enum SessionDeviationSeverity {
  minor,
  moderate,
  major,
  critical
}

/// Trend information
class TrendInfo {
  final TrendType type;
  final double slope;
  final double correlation;
  final String interpretation;

  TrendInfo({
    required this.type,
    required this.slope,
    required this.correlation,
    required this.interpretation,
  });
}

/// Trend types
enum TrendType {
  increasing,
  decreasing,
  stable,
  fluctuating,
  cyclical
}
