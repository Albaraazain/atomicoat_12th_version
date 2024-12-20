// lib/domain/interfaces/datasources/i_machine_datasource.dart

import 'package:experiment_planner/domain/entities/machine/machine.dart';
import 'package:experiment_planner/domain/entities/machine/component.dart';
import 'package:experiment_planner/domain/entities/machine/parameter.dart';
import 'package:experiment_planner/domain/enums/machine_enums.dart';
import 'package:experiment_planner/domain/enums/component_enums.dart';
import 'package:experiment_planner/domain/models/monitoring/system_health.dart';

abstract class IMachineDataSource {
  /// Gets machine by ID
  Future<Machine> getMachine(String machineId);

  /// Gets all registered machines
  Future<List<Machine>> getAllMachines();

  /// Updates machine status
  Future<void> updateMachineStatus(String machineId, MachineStatus status);

  /// Gets machine component by ID
  Future<Component> getComponent(String machineId, String componentId);

  /// Updates component status
  Future<void> updateComponentStatus(
    String machineId,
    String componentId,
    ComponentStatus status,
  );

  /// Updates component parameter
  Future<void> updateParameter(
    String machineId,
    String componentId,
    String parameterId,
    double value,
  );

  /// Gets parameter history
  Future<List<Reading>> getParameterHistory(
    String machineId,
    String componentId,
    String parameterId, {
    DateTime? startTime,
    DateTime? endTime,
  });

  /// Gets machine health status
  Future<SystemHealth> getMachineHealth(String machineId);

  /// Updates machine configuration
  Future<void> updateMachineConfig(
    String machineId,
    Map<String, dynamic> config,
  );

  /// Gets machine configuration
  Future<Map<String, dynamic>> getMachineConfig(String machineId);

  /// Records machine calibration data
  Future<void> recordCalibration(
    String machineId,
    CalibrationData calibrationData,
  );

  /// Gets last calibration data
  Future<CalibrationData?> getLastCalibration(String machineId);

  /// Records maintenance event
  Future<void> recordMaintenanceEvent(
    String machineId,
    MaintenanceEvent event,
  );

  /// Gets maintenance history
  Future<List<MaintenanceEvent>> getMaintenanceHistory(
    String machineId, {
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Streams machine status updates
  Stream<Machine> watchMachine(String machineId);

  /// Streams component status updates
  Stream<Component> watchComponent(String machineId, String componentId);

  /// Streams parameter updates
  Stream<Reading> watchParameter(
    String machineId,
    String componentId,
    String parameterId,
  );

  /// Gets component performance metrics
  Future<ComponentMetrics> getComponentMetrics(
    String machineId,
    String componentId, {
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Validates machine configuration
  Future<ValidationResult> validateMachineConfig(
    String machineId,
    Map<String, dynamic> config,
  );

  /// Gets operational statistics
  Future<OperationalStats> getOperationalStats(
    String machineId, {
    DateTime? startDate,
    DateTime? endDate,
  });
}

/// Represents calibration data for the machine
class CalibrationData {
  final String id;
  final DateTime timestamp;
  final String performedBy;
  final Map<String, CalibrationResult> results;
  final DateTime nextCalibrationDue;
  final String notes;

  CalibrationData({
    required this.id,
    required this.timestamp,
    required this.performedBy,
    required this.results,
    required this.nextCalibrationDue,
    required this.notes,
  });
}

/// Result of a component calibration
class CalibrationResult {
  final bool isSuccessful;
  final double deviation;
  final double correction;
  final String notes;

  CalibrationResult({
    required this.isSuccessful,
    required this.deviation,
    required this.correction,
    required this.notes,
  });
}

/// Represents a maintenance event
class MaintenanceEvent {
  final String id;
  final DateTime timestamp;
  final String performedBy;
  final MaintenanceType type;
  final String description;
  final List<String> componentsServiced;
  final Map<String, dynamic> details;
  final DateTime? nextMaintenanceDue;

  MaintenanceEvent({
    required this.id,
    required this.timestamp,
    required this.performedBy,
    required this.type,
    required this.description,
    required this.componentsServiced,
    required this.details,
    this.nextMaintenanceDue,
  });
}

/// Types of maintenance events
enum MaintenanceType {
  routine,
  repair,
  upgrade,
  cleaning,
  calibration,
  inspection
}

/// Component performance metrics
class ComponentMetrics {
  final double uptime;
  final double reliability;
  final int errorCount;
  final Map<String, double> performanceIndicators;
  final List<MaintenanceEvent> maintenanceHistory;

  ComponentMetrics({
    required this.uptime,
    required this.reliability,
    required this.errorCount,
    required this.performanceIndicators,
    required this.maintenanceHistory,
  });
}

/// Result of configuration validation
class ValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;
  final Map<String, dynamic> suggestedCorrections;

  ValidationResult({
    required this.isValid,
    required this.errors,
    required this.warnings,
    required this.suggestedCorrections,
  });
}

/// Operational statistics
class OperationalStats {
  final Duration totalUptime;
  final Duration totalRuntime;
  final Duration totalDowntime;
  final int totalCycles;
  final Map<ComponentType, Duration> componentUsage;
  final Map<String, List<double>> processParameters;
  final double efficiency;

  OperationalStats({
    required this.totalUptime,
    required this.totalRuntime,
    required this.totalDowntime,
    required this.totalCycles,
    required this.componentUsage,
    required this.processParameters,
    required this.efficiency,
  });
}