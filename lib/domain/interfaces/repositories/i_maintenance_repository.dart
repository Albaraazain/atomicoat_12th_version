// lib/domain/interfaces/repositories/i_maintenance_repository.dart

import 'package:dartz/dartz.dart';
import 'package:experiment_planner/domain/enums/maintenance_enums.dart';
import 'package:experiment_planner/domain/failures/failures.dart';
import 'package:experiment_planner/domain/interfaces/repositories/i_machine_repository.dart';
import 'package:experiment_planner/domain/enums/component_enums.dart';

abstract class IMaintenanceRepository {
  /// Schedules a maintenance event
  Future<Either<Failure, String>> scheduleMaintenance(MaintenanceEvent event);

  /// Gets scheduled maintenance events
  Future<Either<Failure, List<MaintenanceEvent>>> getScheduledMaintenance(
    String machineId, {
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Records completed maintenance
  Future<Either<Failure, void>> recordMaintenanceCompletion(
    String eventId,
    MaintenanceOutcome outcome,
  );

  /// Gets maintenance history
  Future<Either<Failure, List<MaintenanceRecord>>> getMaintenanceHistory(
    String machineId, {
    DateTime? startDate,
    DateTime? endDate,
    MaintenanceType? type,
  });

  /// Gets component maintenance schedule
  Future<Either<Failure, MaintenanceSchedule>> getMaintenanceSchedule(
    String machineId,
    String componentId,
  );

  /// Updates maintenance schedule
  Future<Either<Failure, void>> updateMaintenanceSchedule(
    String machineId,
    String componentId,
    MaintenanceSchedule schedule,
  );

  /// Gets pending maintenance tasks
  Future<Either<Failure, List<MaintenanceTask>>> getPendingTasks(
    String machineId, {
    MaintenancePriority? minPriority,
  });

  /// Records component replacement
  Future<Either<Failure, void>> recordComponentReplacement(
    String machineId,
    ComponentReplacement replacement,
  );

  /// Gets component health metrics
  Future<Either<Failure, ComponentHealth>> getComponentHealth(
    String machineId,
    String componentId,
  );

  /// Updates component health status
  Future<Either<Failure, void>> updateComponentHealth(
    String machineId,
    String componentId,
    ComponentHealth health,
  );

  /// Gets maintenance statistics
  Future<Either<Failure, MaintenanceStats>> getMaintenanceStats(
    String machineId, {
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Generates maintenance recommendations
  Future<Either<Failure, List<MaintenanceRecommendation>>> getRecommendations(
    String machineId,
  );

  /// Gets calibration history
  Future<Either<Failure, List<CalibrationRecord>>> getCalibrationHistory(
    String machineId,
    String componentId,
  );

  /// Records calibration result
  Future<Either<Failure, void>> recordCalibration(
    String machineId,
    String componentId,
    CalibrationRecord calibration,
  );
}

/// Component health status
class ComponentHealth {
  final HealthStatus status;
  final double healthScore;
  final Map<String, double> metrics;
  final List<String> issues;
  final DateTime lastAssessment;
  final List<MaintenanceRecommendation> recommendations;

  ComponentHealth({
    required this.status,
    required this.healthScore,
    required this.metrics,
    required this.issues,
    required this.lastAssessment,
    required this.recommendations,
  });
}

/// Component replacement record
class ComponentReplacement {
  final String componentId;
  final String newPartId;
  final DateTime replacementDate;
  final String replacedBy;
  final String reason;
  final Map<String, dynamic> specifications;
  final List<String> relatedIssues;
  final Duration downtime;

  ComponentReplacement({
    required this.componentId,
    required this.newPartId,
    required this.replacementDate,
    required this.replacedBy,
    required this.reason,
    required this.specifications,
    required this.relatedIssues,
    required this.downtime,
  });
}

/// Maintenance statistics
class MaintenanceStats {
  final Duration totalDowntime;
  final int totalMaintenanceEvents;
  final Map<MaintenanceType, int> eventsByType;
  final Map<String, Duration> downtimeByComponent;
  final double preventiveRatio;
  final double mtbf; // Mean Time Between Failures
  final double mttr; // Mean Time To Repair
  final List<MaintenanceTrend> trends;

  MaintenanceStats({
    required this.totalDowntime,
    required this.totalMaintenanceEvents,
    required this.eventsByType,
    required this.downtimeByComponent,
    required this.preventiveRatio,
    required this.mtbf,
    required this.mttr,
    required this.trends,
  });
}

/// Maintenance trend analysis
class MaintenanceTrend {
  final String metric;
  final List<TrendPoint> points;
  final double slope;
  final String interpretation;
  final double confidence;

  MaintenanceTrend({
    required this.metric,
    required this.points,
    required this.slope,
    required this.interpretation,
    required this.confidence,
  });
}

/// Point in trend analysis
class TrendPoint {
  final DateTime timestamp;
  final double value;

  TrendPoint({
    required this.timestamp,
    required this.value,
  });
}

/// Maintenance recommendation
class MaintenanceRecommendation {
  final String title;
  final String description;
  final MaintenancePriority priority;
  final MaintenanceType type;
  final DateTime suggestedDate;
  final Duration estimatedDuration;
  final List<String> affectedComponents;
  final Map<String, dynamic> justification;
  final double costEstimate;
  final double riskLevel;

  MaintenanceRecommendation({
    required this.title,
    required this.description,
    required this.priority,
    required this.type,
    required this.suggestedDate,
    required this.estimatedDuration,
    required this.affectedComponents,
    required this.justification,
    required this.costEstimate,
    required this.riskLevel,
  });
}

/// Calibration record
class CalibrationRecord {
  final DateTime timestamp;
  final String performedBy;
  final Map<String, double> measurements;
  final Map<String, double> adjustments;
  final bool successful;
  final String notes;
  final DateTime nextDueDate;
  final List<String> affectedParameters;

  CalibrationRecord({
    required this.timestamp,
    required this.performedBy,
    required this.measurements,
    required this.adjustments,
    required this.successful,
    required this.notes,
    required this.nextDueDate,
    required this.affectedParameters,
  });
}