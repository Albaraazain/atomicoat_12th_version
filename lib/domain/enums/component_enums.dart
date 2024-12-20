enum ComponentType {
  precursor,
  pump,
  valve,
  heater,
  sensor,
  chamber,
  gasLine,
  controller
}

enum ComponentStatus {
  active,
  inactive,
  maintenance,
  error,
  standby;

  static ComponentStatus fromString(String value) {
    return ComponentStatus.values.firstWhere(
      (status) => status.name.toLowerCase() == value.toLowerCase(),
      orElse: () => ComponentStatus.standby,
    );
  }
}

enum HealthStatus {
  good,
  warning,
  critical,
  unknown
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
