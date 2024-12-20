import 'package:experiment_planner/domain/enums/analysis_enums.dart';

class ProcessRecommendation {
  final String title;
  final String description;
  final RecommendationPriority priority;
  final RecommendationType type;
  final Map<String, dynamic> suggestedParameters;
  final String expectedOutcome;
  final double confidenceLevel;
  final DateTime createdAt;

  ProcessRecommendation({
    required this.title,
    required this.description,
    required this.priority,
    required this.type,
    required this.suggestedParameters,
    required this.expectedOutcome,
    required this.confidenceLevel,
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();
}
