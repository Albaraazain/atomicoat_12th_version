// lib/domain/models/monitoring/monitoring_config.dart
class MonitoringConfig {
  final Map<String, ParameterConfig> parameters;
  final AlertConfig alertConfig;
  final DataCollectionConfig dataCollection;
  final DisplayConfig displayConfig;
  final bool autoReconnect;
  final Duration updateInterval;
  final int maxDataPoints;

  const MonitoringConfig({
    required this.parameters,
    required this.alertConfig,
    required this.dataCollection,
    required this.displayConfig,
    this.autoReconnect = true,
    this.updateInterval = const Duration(milliseconds: 100),
    this.maxDataPoints = 1000,
  });

  factory MonitoringConfig.fromJson(Map<String, dynamic> json) {
    return MonitoringConfig(
      parameters: Map.fromEntries(
        (json['parameters'] as Map<String, dynamic>).entries.map(
          (e) => MapEntry(e.key, ParameterConfig.fromJson(e.value)),
        ),
      ),
      alertConfig: AlertConfig.fromJson(json['alertConfig']),
      dataCollection: DataCollectionConfig.fromJson(json['dataCollection']),
      displayConfig: DisplayConfig.fromJson(json['displayConfig']),
      autoReconnect: json['autoReconnect'] ?? true,
      updateInterval: Duration(milliseconds: json['updateInterval'] ?? 100),
      maxDataPoints: json['maxDataPoints'] ?? 1000,
    );
  }

  Map<String, dynamic> toJson() => {
    'parameters': parameters.map((key, value) => MapEntry(key, value.toJson())),
    'alertConfig': alertConfig.toJson(),
    'dataCollection': dataCollection.toJson(),
    'displayConfig': displayConfig.toJson(),
    'autoReconnect': autoReconnect,
    'updateInterval': updateInterval.inMilliseconds,
    'maxDataPoints': maxDataPoints,
  };
}

class ParameterConfig {
  final bool enabled;
  final double? warningThreshold;
  final double? criticalThreshold;
  final bool trackHistory;
  final Duration averagingWindow;
  final List<String> correlatedParameters;

  const ParameterConfig({
    this.enabled = true,
    this.warningThreshold,
    this.criticalThreshold,
    this.trackHistory = true,
    this.averagingWindow = const Duration(minutes: 5),
    this.correlatedParameters = const [],
  });

  factory ParameterConfig.fromJson(Map<String, dynamic> json) {
    return ParameterConfig(
      enabled: json['enabled'] ?? true,
      warningThreshold: json['warningThreshold'],
      criticalThreshold: json['criticalThreshold'],
      trackHistory: json['trackHistory'] ?? true,
      averagingWindow: Duration(milliseconds: json['averagingWindow'] ?? 300000),
      correlatedParameters: List<String>.from(json['correlatedParameters'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'warningThreshold': warningThreshold,
    'criticalThreshold': criticalThreshold,
    'trackHistory': trackHistory,
    'averagingWindow': averagingWindow.inMilliseconds,
    'correlatedParameters': correlatedParameters,
  };
}
