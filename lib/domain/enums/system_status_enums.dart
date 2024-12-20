enum SessionStatus {
  pending,
  running,
  completed,
  failed
}

enum ValidationStatus {
  valid,
  invalid,
  pending,
  warning
}

enum MonitoringState {
  active,
  paused,
  stopped,
  error
}

enum SystemStatus {
  operational,
  degraded,
  maintenance,
  warning,
  critical,
  offline;

  static SystemStatus fromString(String value) {
    return SystemStatus.values.firstWhere(
      (status) => status.name.toLowerCase() == value.toLowerCase(),
      orElse: () => SystemStatus.offline,
    );
  }
}

enum AnalysisStatus {
  pending,
  inProgress,
  completed,
  failed
}
