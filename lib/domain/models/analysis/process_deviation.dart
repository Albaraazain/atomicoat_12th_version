import 'package:experiment_planner/domain/enums/analysis_enums.dart';

class ProcessDeviation {
  final String parameter;
  final DeviationSeverity severity;
  final String description;
  final String impact;
  final Map<String, dynamic>? data;

  ProcessDeviation({
    required this.parameter,
    required this.severity,
    required this.description,
    required this.impact,
    this.data,
  });
}
