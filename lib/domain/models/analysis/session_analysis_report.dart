import 'package:experiment_planner/domain/enums/analysis_enums.dart';
import 'package:experiment_planner/domain/models/analysis/film_quality_analysis.dart';
import 'package:experiment_planner/domain/models/analysis/process_quality_analysis.dart';
import 'package:experiment_planner/domain/models/analysis/process_recommendation.dart';

class SessionAnalysisReport {
  final SessionInfo sessionInfo;
  final ProcessQualityAnalysis processQuality;
  final FilmQualityAnalysis filmQuality;
  final List<ProcessRecommendation> recommendations;
  final DateTime generatedAt;

  SessionAnalysisReport({
    required this.sessionInfo,
    required this.processQuality,
    required this.filmQuality,
    required this.recommendations,
    DateTime? generatedAt,
  }) : this.generatedAt = generatedAt ?? DateTime.now();
}

class SessionInfo {
  final Duration actualDuration;
  final Duration expectedDuration;
  final double averageCycleTime;
  final double processEfficiency;
  final List<ProcessDeviation> deviations;

  SessionInfo({
    required this.actualDuration,
    required this.expectedDuration,
    required this.averageCycleTime,
    required this.processEfficiency,
    required this.deviations,
  });
}

class ProcessDeviation {
  final String parameter;
  final DeviationSeverity severity;
  final String description;
  final String impact;
  final DateTime timestamp;

  ProcessDeviation({
    required this.parameter,
    required this.severity,
    required this.description,
    required this.impact,
    DateTime? timestamp,
  }) : this.timestamp = timestamp ?? DateTime.now();
}
