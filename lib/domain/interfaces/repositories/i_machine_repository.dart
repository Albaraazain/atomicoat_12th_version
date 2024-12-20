// lib/domain/interfaces/repositories/i_machine_repository.dart

import 'package:dartz/dartz.dart';
import 'package:experiment_planner/domain/entities/machine/machine.dart';
import 'package:experiment_planner/domain/entities/machine/component.dart';
import 'package:experiment_planner/domain/enums/alert_enums.dart';
import 'package:experiment_planner/domain/enums/analysis_enums.dart';
import 'package:experiment_planner/domain/enums/component_enums.dart';
import 'package:experiment_planner/domain/enums/issues_enums.dart';
import 'package:experiment_planner/domain/enums/machine_enums.dart';
import 'package:experiment_planner/domain/enums/maintenance_enums.dart';
import 'package:experiment_planner/domain/enums/validation_enums';
import 'package:experiment_planner/domain/failures/failures.dart';
import 'package:experiment_planner/domain/interfaces/datasources/i_machine_datasource.dart';
import 'package:experiment_planner/domain/models/monitoring/system_health.dart';

abstract class IMachineRepository {
  /// Gets machine by ID
  Future<Either<Failure, Machine>> getMachine(String machineId);

  /// Gets all registered machines
  Future<Either<Failure, List<Machine>>> getAllMachines();

  /// Updates machine status
  Future<Either<Failure, void>> updateMachineStatus(
    String machineId,
    MachineStatus status,
  );

  /// Gets component by ID
  Future<Either<Failure, Component>> getComponent(
    String machineId,
    String componentId,
  );

  /// Updates component status
  Future<Either<Failure, void>> updateComponentStatus(
    String machineId,
    String componentId,
    ComponentStatus status,
  );

  /// Updates component parameter
  Future<Either<Failure, void>> updateParameter(
    String machineId,
    String componentId,
    String parameterId,
    double value,
  );

  /// Gets parameter history
  Future<Either<Failure, List<ParameterHistory>>> getParameterHistory(
    String machineId,
    String componentId,
    String parameterId, {
    DateTime? startTime,
    DateTime? endTime,
  });

  /// Gets machine health status
  Future<Either<Failure, SystemHealth>> getMachineHealth(String machineId);

  /// Gets machine calibration status
  Future<Either<Failure, CalibrationStatus>> getCalibrationStatus(String machineId);

  /// Initiates machine calibration
  Future<Either<Failure, void>> initiateCalibration(
    String machineId,
    CalibrationConfig config,
  );

  /// Updates machine configuration
  Future<Either<Failure, void>> updateMachineConfig(
    String machineId,
    MachineConfig config,
  );

  /// Validates machine configuration
  Future<Either<Failure, ValidationResult>> validateMachineConfig(
    String machineId,
    MachineConfig config,
  );

  /// Gets machine maintenance history
  Future<Either<Failure, List<MaintenanceRecord>>> getMaintenanceHistory(
    String machineId, {
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Records maintenance event
  Future<Either<Failure, void>> recordMaintenanceEvent(
    String machineId,
    MaintenanceEvent event,
  );

  /// Streams machine status updates
  Stream<Either<Failure, Machine>> watchMachine(String machineId);

  /// Streams component status updates
  Stream<Either<Failure, Component>> watchComponent(
    String machineId,
    String componentId,
  );

  /// Streams parameter updates
  Stream<Either<Failure, ParameterUpdate>> watchParameter(
    String machineId,
    String componentId,
    String parameterId,
  );

  /// Performs system diagnostics
  Future<Either<Failure, DiagnosticResult>> runDiagnostics(
    String machineId, {
    List<String>? specificComponents,
  });

  /// Gets operational statistics
  Future<Either<Failure, OperationalStats>> getOperationalStats(
    String machineId, {
    DateTime? startDate,
    DateTime? endDate,
  });
}

/// Machine configuration
class MachineConfig {
  final Map<String, ComponentConfig> components;
  final Map<String, double> safetyLimits;
  final Map<String, dynamic> processDefaults;
  final NetworkConfig networkConfig;
  final AlertConfig alertConfig;

  MachineConfig({
    required this.components,
    required this.safetyLimits,
    required this.processDefaults,
    required this.networkConfig,
    required this.alertConfig,
  });
}

/// Component configuration
class ComponentConfig {
  final Map<String, double> parameterLimits;
  final Map<String, dynamic> operationalSettings;
  final CalibrationConfig calibrationSettings;
  final MaintenanceSchedule maintenanceSchedule;

  ComponentConfig({
    required this.parameterLimits,
    required this.operationalSettings,
    required this.calibrationSettings,
    required this.maintenanceSchedule,
  });
}

/// Network configuration
class NetworkConfig {
  final String ipAddress;
  final int port;
  final bool useSSL;
  final Duration timeout;
  final RetryPolicy retryPolicy;

  NetworkConfig({
    required this.ipAddress,
    required this.port,
    required this.useSSL,
    required this.timeout,
    required this.retryPolicy,
  });
}

/// Alert configuration
class AlertConfig {
  final Map<String, double> thresholds;
  final Map<String, AlertSeverity> severityLevels;
  final List<String> recipients;
  final bool enableEmailAlerts;
  final bool enablePushNotifications;

  AlertConfig({
    required this.thresholds,
    required this.severityLevels,
    required this.recipients,
    required this.enableEmailAlerts,
    required this.enablePushNotifications,
  });
}

/// Parameter history entry
class ParameterHistory {
  final DateTime timestamp;
  final double value;
  final String? updatedBy;
  final Map<String, dynamic>? metadata;

  ParameterHistory({
    required this.timestamp,
    required this.value,
    this.updatedBy,
    this.metadata,
  });
}

/// Real-time parameter update
class ParameterUpdate {
  final DateTime timestamp;
  final String parameterId;
  final double value;
  final ParameterStatus status;

  ParameterUpdate({
    required this.timestamp,
    required this.parameterId,
    required this.value,
    required this.status,
  });
}

/// Parameter status
enum ParameterStatus {
  normal,
  warning,
  critical,
  outOfRange
}

/// Diagnostic result
class DiagnosticResult {
  final bool isHealthy;
  final Map<String, ComponentDiagnostic> componentResults;
  final List<String> recommendations;
  final DateTime timestamp;

  DiagnosticResult({
    required this.isHealthy,
    required this.componentResults,
    required this.recommendations,
    required this.timestamp,
  });
}

/// Component diagnostic result
class ComponentDiagnostic {
  final bool isOperational;
  final List<String> issues;
  final Map<String, double> metrics;
  final String? recommendedAction;

  ComponentDiagnostic({
    required this.isOperational,
    required this.issues,
    required this.metrics,
    this.recommendedAction,
  });
}

/// Calibration configuration
class CalibrationConfig {
  final List<String> parametersToCalibrate;
  final Map<String, double> targetValues;
  final int iterations;
  final Duration timeout;

  CalibrationConfig({
    required this.parametersToCalibrate,
    required this.targetValues,
    required this.iterations,
    required this.timeout,
  });
}

/// Calibration status
class CalibrationStatus {
  final DateTime lastCalibration;
  final DateTime nextDue;
  final Map<String, double> deviations;
  final bool isCalibrated;
  final List<String> pendingCalibrations;

  CalibrationStatus({
    required this.lastCalibration,
    required this.nextDue,
    required this.deviations,
    required this.isCalibrated,
    required this.pendingCalibrations,
  });
}

/// Configuration validation result
class ValidationResult {
  final bool isValid;
  final List<ValidationIssue> issues;
  final Map<String, List<String>> componentIssues;
  final List<String> recommendations;

  ValidationResult({
    required this.isValid,
    required this.issues,
    required this.componentIssues,
    required this.recommendations,
  });

}

  /// Validation issue details
class ValidationIssue {
  final String code;
  final String message;
  final IssueSeverity severity;
  final String? component;
  final String? parameter;

  ValidationIssue({
    required this.code,
    required this.message,
    required this.severity,
    this.component,
    this.parameter,
  });
}

/// Maintenance record
class MaintenanceRecord {
  final String id;
  final DateTime timestamp;
  final String performedBy;
  final MaintenanceType type;
  final String description;
  final List<String> componentsServiced;
  final Map<String, dynamic> measurements;
  final List<String> partsReplaced;
  final Duration downtime;
  final MaintenanceOutcome outcome;

  MaintenanceRecord({
    required this.id,
    required this.timestamp,
    required this.performedBy,
    required this.type,
    required this.description,
    required this.componentsServiced,
    required this.measurements,
    required this.partsReplaced,
    required this.downtime,
    required this.outcome,
  });
}

/// Maintenance event details
class MaintenanceEvent {
  final String description;
  final MaintenanceType type;
  final String performedBy;
  final List<String> componentsToService;
  final Map<String, dynamic> plannedActions;
  final DateTime scheduledTime;
  final Duration estimatedDuration;
  final MaintenancePriority priority;

  MaintenanceEvent({
    required this.description,
    required this.type,
    required this.performedBy,
    required this.componentsToService,
    required this.plannedActions,
    required this.scheduledTime,
    required this.estimatedDuration,
    required this.priority,
  });
}

/// Types of maintenance
enum MaintenanceType {
  preventive,
  corrective,
  predictive,
  calibration,
  upgrade,
  emergency
}

/// Maintenance outcome
class MaintenanceOutcome {
  final bool successful;
  final List<String> completedActions;
  final List<String> pendingIssues;
  final Map<String, dynamic> measurements;
  final String notes;
  final List<String> recommendations;

  MaintenanceOutcome({
    required this.successful,
    required this.completedActions,
    required this.pendingIssues,
    required this.measurements,
    required this.notes,
    required this.recommendations,
  });
}

/// Maintenance schedule
class MaintenanceSchedule {
  final Map<MaintenanceType, Duration> intervals;
  final Map<String, DateTime> nextDueDates;
  final List<MaintenanceTask> pendingTasks;
  final Map<String, List<String>> dependencies;

  MaintenanceSchedule({
    required this.intervals,
    required this.nextDueDates,
    required this.pendingTasks,
    required this.dependencies,
  });
}

/// Maintenance task details
class MaintenanceTask {
  final String id;
  final String description;
  final MaintenanceType type;
  final DateTime dueDate;
  final Duration estimatedDuration;
  final List<String> requiredParts;
  final List<String> procedures;
  final MaintenancePriority priority;

  MaintenanceTask({
    required this.id,
    required this.description,
    required this.type,
    required this.dueDate,
    required this.estimatedDuration,
    required this.requiredParts,
    required this.procedures,
    required this.priority,
  });
}



/// Network retry policy
class RetryPolicy {
  final int maxAttempts;
  final Duration initialDelay;
  final Duration maxDelay;
  final double backoffMultiplier;

  RetryPolicy({
    required this.maxAttempts,
    required this.initialDelay,
    required this.maxDelay,
    required this.backoffMultiplier,
  });
}
