// lib/domain/interfaces/datasources/i_monitoring_datasource.dart

import 'package:experiment_planner/domain/entities/monitoring/monitoring_session.dart';
import 'package:experiment_planner/domain/enums/monitoring_enums.dart';
import 'package:experiment_planner/domain/value_objects/monitoring/measurement_value.dart';
import 'package:experiment_planner/domain/models/process/data_point.dart';

abstract class IMonitoringDataSource {
  /// Starts a new monitoring session
  Future<MonitoringSession> startMonitoring(
    String machineId,
    Map<String, MonitoringConfig> parameterConfigs,
  );

  /// Stops an active monitoring session
  Future<void> stopMonitoring(String sessionId);

  /// Pauses an active monitoring session
  Future<void> pauseMonitoring(String sessionId);

  /// Resumes a paused monitoring session
  Future<void> resumeMonitoring(String sessionId);

  /// Records a measurement value
  Future<void> recordMeasurement(
    String sessionId,
    String parameterId,
    MeasurementValue value,
  );

  /// Records multiple measurements
  Future<void> recordMeasurements(
    String sessionId,
    Map<String, MeasurementValue> measurements,
  );

  /// Gets monitoring session by ID
  Future<MonitoringSession?> getSession(String sessionId);

  /// Gets monitoring sessions for a machine
  Future<List<MonitoringSession>> getMachineSessions(
    String machineId, {
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Gets active monitoring sessions
  Future<List<MonitoringSession>> getActiveSessions();

  /// Gets measurement history for a parameter
  Future<List<DataPoint>> getMeasurementHistory(
    String sessionId,
    String parameterId, {
    DateTime? startTime,
    DateTime? endTime,
  });

  /// Gets aggregated measurements
  Future<AggregatedMeasurements> getAggregatedMeasurements(
    String sessionId,
    String parameterId, {
    Duration aggregationInterval = const Duration(minutes: 1),
    DateTime? startTime,
    DateTime? endTime,
  });

  /// Updates monitoring configuration
  Future<void> updateMonitoringConfig(
    String sessionId,
    Map<String, MonitoringConfig> configs,
  );

  /// Gets current monitoring configuration
  Future<Map<String, MonitoringConfig>> getMonitoringConfig(String sessionId);

  /// Streams real-time measurements
  Stream<Map<String, MeasurementValue>> watchMeasurements(String sessionId);

  /// Streams session status updates
  Stream<MonitoringState> watchSessionState(String sessionId);

  /// Gets monitoring statistics
  Future<MonitoringStats> getMonitoringStats(
    String sessionId, {
    DateTime? startTime,
    DateTime? endTime,
  });

  /// Exports monitoring data
  Future<String> exportMonitoringData(
    String sessionId,
    MonitoringDataExportFormat format, {
    DateTime? startTime,
    DateTime? endTime,
  });
}

/// Configuration for parameter monitoring
class MonitoringConfig {
  final double samplingRate; // Hz
  final double? minValue;
  final double? maxValue;
  final double? warningThreshold;
  final double? criticalThreshold;
  final bool enableAlerting;
  final DataCollectionMode collectionMode;

  MonitoringConfig({
    required this.samplingRate,
    this.minValue,
    this.maxValue,
    this.warningThreshold,
    this.criticalThreshold,
    this.enableAlerting = true,
    this.collectionMode = DataCollectionMode.continuous,
  });
}

/// Aggregated measurement data
class AggregatedMeasurements {
  final List<AggregatedDataPoint> dataPoints;
  final Duration interval;
  final String parameterId;

  AggregatedMeasurements({
    required this.dataPoints,
    required this.interval,
    required this.parameterId,
  });
}

/// Single aggregated data point
class AggregatedDataPoint {
  final DateTime timestamp;
  final double average;
  final double minimum;
  final double maximum;
  final double standardDeviation;
  final int sampleCount;

  AggregatedDataPoint({
    required this.timestamp,
    required this.average,
    required this.minimum,
    required this.maximum,
    required this.standardDeviation,
    required this.sampleCount,
  });
}

/// Monitoring statistics
class MonitoringStats {
  final int totalMeasurements;
  final Duration monitoringDuration;
  final Map<String, ParameterStats> parameterStats;
  final double dataQualityScore;
  final int missedMeasurements;
  final Map<String, List<DataPoint>> outliers;

  MonitoringStats({
    required this.totalMeasurements,
    required this.monitoringDuration,
    required this.parameterStats,
    required this.dataQualityScore,
    required this.missedMeasurements,
    required this.outliers,
  });
}

/// Statistics for a specific parameter
class ParameterStats {
  final double minimum;
  final double maximum;
  final double average;
  final double standardDeviation;
  final int sampleCount;
  final double samplingRate;
  final List<OutlierInfo> outliers;

  ParameterStats({
    required this.minimum,
    required this.maximum,
    required this.average,
    required this.standardDeviation,
    required this.sampleCount,
    required this.samplingRate,
    required this.outliers,
  });
}

/// Information about an outlier measurement
class OutlierInfo {
  final DataPoint dataPoint;
  final double zScore;
  final String? possibleCause;

  OutlierInfo({
    required this.dataPoint,
    required this.zScore,
    this.possibleCause,
  });
}

/// Export format for monitoring data
enum MonitoringDataExportFormat {
  csv,
  json,
  hdf5,
  excel
}