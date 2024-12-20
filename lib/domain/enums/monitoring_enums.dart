enum MonitoringState {
  active,
  paused,
  stopped,
  error
}

enum AlertLevel {
  info,
  warning,
  error,
  critical
}

enum DataCollectionMode {
  continuous,
  interval,
  triggered,
  manual
}

enum MonitoringPriority {
  low,
  medium,
  high,
  critical
}

enum AnalysisType {
  realTime,
  postProcess,
  historical,
  predictive
}

enum RecommendationPriority {
  low,
  medium,
  high,
  critical
}

enum RecommendationType {
  processOptimization,
  parameterAdjustment,
  maintenance,
  qualityImprovement,
  safety,
  calibration,
  replacement
}

enum IssueType {
  stability,
  uniformity,
  contamination,
  equipment,
  process,
  other
}