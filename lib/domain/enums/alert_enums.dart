enum AlertType {
  measurement,
  system,
  process,
  maintenance,
  calibration,
  quality,
  safety;

  static AlertType fromString(String value) {
    return AlertType.values.firstWhere(
      (type) => type.toString().split('.').last == value,
      orElse: () => AlertType.system,
    );
  }
}

enum AlertSeverity {
  critical,
  high,
  medium,
  low;

  static AlertSeverity fromString(String value) {
    return AlertSeverity.values.firstWhere(
      (severity) => severity.toString().split('.').last == value,
      orElse: () => AlertSeverity.low,
    );
  }
}

enum AlertLevel {
  info,
  warning,
  error,
  critical
}

enum MonitoringAlertType {
  threshold,
  trend,
  statusChange,
  maintenance,
  calibration,
  custom
}
