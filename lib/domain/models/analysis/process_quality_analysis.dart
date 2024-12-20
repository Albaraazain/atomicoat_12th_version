import 'package:experiment_planner/domain/enums/analysis_enums.dart';
import 'package:experiment_planner/domain/models/analysis/process_issue.dart';

class ProcessQualityAnalysis {
  final ProcessQuality overallQuality;
  final double stabilityScore;
  final double uniformityScore;
  final double cycleConsistencyScore;
  final List<ProcessIssue> identifiedIssues;
  final Map<String, double> parameterScores;

  ProcessQualityAnalysis({
    required this.overallQuality,
    required this.stabilityScore,
    required this.uniformityScore,
    required this.cycleConsistencyScore,
    required this.identifiedIssues,
    required this.parameterScores,
  });

  double get averageScore =>
      (stabilityScore + uniformityScore + cycleConsistencyScore) / 3;
}

