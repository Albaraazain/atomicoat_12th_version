import 'package:experiment_planner/domain/enums/component_enums.dart';
import 'package:experiment_planner/domain/models/monitoring/system_health.dart';

class SystemHealthDto {
  final String timestamp;
  final String status;
  final List<Map<String, dynamic>> components;
  final Map<String, dynamic> metrics;

  SystemHealthDto({
    required this.timestamp,
    required this.status,
    required this.components,
    required this.metrics,
  });

  factory SystemHealthDto.fromJson(Map<String, dynamic> json) {
    return SystemHealthDto(
      timestamp: json['timestamp'],
      status: json['status'],
      components: List<Map<String, dynamic>>.from(json['components']),
      metrics: Map<String, dynamic>.from(json['metrics']),
    );
  }

  SystemHealth toDomain() {
    return SystemHealth(
      timestamp: DateTime.parse(timestamp),
      status: SystemStatus.fromString(status),
      components: components.map((c) => ComponentHealth.fromJson(c)).toList(),
      metrics: SystemMetrics.fromJson(metrics),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'status': status,
      'components': components,
      'metrics': metrics,
    };
  }
}
