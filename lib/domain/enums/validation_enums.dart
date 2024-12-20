/// Validation issue details
class ValidationIssue {
  final ValidationIssueType type;
  final String description;
  final String? parameter;
  final String? stepId;
  final String? recommendation;

  ValidationIssue({
    required this.type,
    required this.description,
    this.parameter,
    this.stepId,
    this.recommendation,
  });
}

/// Types of validation issues
enum ValidationIssueType {
  parameterOutOfRange,
  incompatibleSteps,
  missingDependency,
  safetyViolation,
  logicError
}

/// Validation severity
enum ValidationSeverity {
  info,
  warning,
  error,
  critical
}

