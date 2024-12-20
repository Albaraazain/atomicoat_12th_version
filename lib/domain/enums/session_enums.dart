
enum SessionStatus {
  pending,
  running,
  completed,
  failed
}

enum ProcessPhase {
  initialization,
  precursorPulse,
  precursorPurge,
  oxidantPulse,
  oxidantPurge,
  cooldown,
  complete
}

enum ValidationStatus {
  valid,
  invalid,
  pending,
  warning
}

enum LogLevel {
  debug,
  info,
  warning,
  error,
  critical,
  trace
}

/// Export format options for session data
enum SessionDataExportFormat {
  csv,
  json,
  hdf5,
  matlab
}
