import 'package:flutter/foundation.dart';
import 'package:experiment_planner/domain/enums/machine_enums.dart';
import 'package:experiment_planner/domain/enums/monitoring_enums.dart';
import 'package:experiment_planner/domain/enums/component_enums.dart';

class AppConfig {
  // System Configuration
  final String apiBaseUrl;
  final String websocketUrl;
  final String appVersion;

  // Default Machine Settings
  final MachineType defaultMachineType;
  final OperationalMode defaultOperationalMode;
  final MonitoringState defaultMonitoringState;

  // Feature Flags
  final bool enableRealTimeMonitoring;
  final bool enableAutoMaintenance;
  final bool enableRemoteControl;

  // Alert Configuration
  final Duration alertTimeout;
  final AlertLevel minimumAlertLevel;

  const AppConfig({
    required this.apiBaseUrl,
    required this.websocketUrl,
    required this.appVersion,
    this.defaultMachineType = MachineType.thermalALD,
    this.defaultOperationalMode = OperationalMode.automatic,
    this.defaultMonitoringState = MonitoringState.active,
    this.enableRealTimeMonitoring = true,
    this.enableAutoMaintenance = true,
    this.enableRemoteControl = true,
    this.alertTimeout = const Duration(minutes: 5),
    this.minimumAlertLevel = AlertLevel.warning,
  });

  factory AppConfig.development() {
    return AppConfig(
      apiBaseUrl: 'http://localhost:8080',
      websocketUrl: 'ws://localhost:8081',
      appVersion: '1.0.0-dev',
    );
  }

  factory AppConfig.production() {
    return AppConfig(
      apiBaseUrl: 'https://api.atomicoat.com',
      websocketUrl: 'wss://ws.atomicoat.com',
      appVersion: '1.0.0',
    );
  }

  factory AppConfig.fromEnvironment() {
    return kDebugMode
        ? AppConfig.development()
        : AppConfig.production();
  }

  AppConfig copyWith({
    String? apiBaseUrl,
    String? websocketUrl,
    String? appVersion,
    MachineType? defaultMachineType,
    OperationalMode? defaultOperationalMode,
    MonitoringState? defaultMonitoringState,
    bool? enableRealTimeMonitoring,
    bool? enableAutoMaintenance,
    bool? enableRemoteControl,
    Duration? alertTimeout,
    AlertLevel? minimumAlertLevel,
  }) {
    return AppConfig(
      apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
      websocketUrl: websocketUrl ?? this.websocketUrl,
      appVersion: appVersion ?? this.appVersion,
      defaultMachineType: defaultMachineType ?? this.defaultMachineType,
      defaultOperationalMode: defaultOperationalMode ?? this.defaultOperationalMode,
      defaultMonitoringState: defaultMonitoringState ?? this.defaultMonitoringState,
      enableRealTimeMonitoring: enableRealTimeMonitoring ?? this.enableRealTimeMonitoring,
      enableAutoMaintenance: enableAutoMaintenance ?? this.enableAutoMaintenance,
      enableRemoteControl: enableRemoteControl ?? this.enableRemoteControl,
      alertTimeout: alertTimeout ?? this.alertTimeout,
      minimumAlertLevel: minimumAlertLevel ?? this.minimumAlertLevel,
    );
  }
}
