import 'package:equatable/equatable.dart';
import 'package:experiment_planner/domain/enums/analysis_enums.dart';

class ProcessIssue extends Equatable {
  final IssueType type;
  final IssueSeverity severity;
  final String description;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  ProcessIssue({
    required this.type,
    required this.severity,
    required this.description,
    DateTime? timestamp,
    this.metadata,
  }) : this.timestamp = timestamp ?? DateTime.now();

  @override
  List<Object> get props => [type, severity, description, timestamp];
}
