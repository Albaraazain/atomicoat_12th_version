enum StepType {
  precursorDelivery,
  precursorPurge,
  oxidantPurge,
  temperatureControl,
  pressureControl,
  wait,
  loop,
  substrateRotation,
}

/// Recipe tags for versioning
enum RecipeTag {
  stable,
  testing,
  optimized,
  experimental,
  deprecated
}

/// Export formats for recipes
enum RecipeExportFormat {
  json,
  yaml,
  xml,
  pdf
}

/// Version status
enum VersionStatus {
  draft,
  testing,
  stable,
  deprecated,
  archived
}

/// Optimization status
enum OptimizationStatus {
  proposed,
  testing,
  validated,
  rejected
}
/// Execution status
enum ExecutionStatus {
  completed,
  failed,
  aborted,
  partialSuccess
}

/// Deviation severity
enum DeviationSeverity {
  minor,
  moderate,
  major,
  critical
}

