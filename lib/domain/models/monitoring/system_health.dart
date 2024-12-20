// lib/domain/models/monitoring/system_health.dart
import 'package:experiment_planner/domain/enums/component_enums.dart';

class SystemHealth {
  final DateTime timestamp;
  final SystemStatus status;
  final List<ComponentHealth> components;
  final SystemMetrics metrics;

  SystemHealth({
    required this.timestamp,
    required this.status,
    required this.components,
    required this.metrics,
  });
}

class ComponentHealth {
  final String id;
  final String name;
  final ComponentStatus status;
  final Map<String, double> metrics;
  final DateTime lastUpdate;

  ComponentHealth({
    required this.id,
    required this.name,
    required this.status,
    required this.metrics,
    required this.lastUpdate,
  });

  factory ComponentHealth.fromJson(Map<String, dynamic> json) {
    return ComponentHealth(
      id: json['id'],
      name: json['name'],
      status: ComponentStatus.fromString(json['status']),
      metrics: Map<String, double>.from(json['metrics']),
      lastUpdate: DateTime.parse(json['lastUpdate']),
    );
  }
}

class SystemMetrics {
  final double cpuUsage;
  final double memoryUsage;
  final double diskUsage;
  final double networkLatency;
  final int activeConnections;
  final Map<String, double> customMetrics;

  SystemMetrics({
    required this.cpuUsage,
    required this.memoryUsage,
    required this.diskUsage,
    required this.networkLatency,
    required this.activeConnections,
    required this.customMetrics,
  });

  factory SystemMetrics.fromJson(Map<String, dynamic> json) {
    return SystemMetrics(
      cpuUsage: json['cpuUsage'],
      memoryUsage: json['memoryUsage'],
      diskUsage: json['diskUsage'],
      networkLatency: json['networkLatency'],
      activeConnections: json['activeConnections'],
      customMetrics: Map<String, double>.from(json['customMetrics'] ?? {}),
    );
  }
}

