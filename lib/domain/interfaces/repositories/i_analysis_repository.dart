// lib/domain/interfaces/repositories/i_analysis_repository.dart

import 'package:dartz/dartz.dart';
import 'package:experiment_planner/domain/enums/analysis_enums.dart';
import 'package:experiment_planner/domain/failures/failures.dart';
import 'package:experiment_planner/domain/interfaces/datasources/i_analysis_datasource.dart';
import 'package:experiment_planner/domain/models/analysis/correlation_result.dart';
import 'package:experiment_planner/domain/models/analysis/film_quality_analysis.dart';
import 'package:experiment_planner/domain/models/analysis/process_quality_analysis.dart';
import 'package:experiment_planner/domain/models/analysis/session_analysis_report.dart';

abstract class IAnalysisRepository {
  /// Analyzes a completed session and generates a comprehensive report
  Future<Either<Failure, SessionAnalysisReport>> analyzeSession(String sessionId);

  /// Performs film quality analysis for a session
  Future<Either<Failure, FilmQualityAnalysis>> analyzeFilmQuality(String sessionId);

  /// Analyzes process quality and stability
  Future<Either<Failure, ProcessQualityAnalysis>> analyzeProcessQuality(String sessionId);

  /// Performs correlation analysis between parameters
  Future<Either<Failure, List<CorrelationResult>>> analyzeParameterCorrelations(
    String sessionId, {
    List<String>? specificParameters,
    Duration? timeWindow,
  });

  /// Gets comparative analysis between multiple sessions
  Future<Either<Failure, ComparativeAnalysis>> compareSessionsAnalysis(
    List<String> sessionIds,
  );

  /// Gets analysis history for a recipe
  Future<Either<Failure, List<SessionAnalysisReport>>> getRecipeAnalysisHistory(
    String recipeId, {
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Analyzes process trends over time
  Future<Either<Failure, TrendAnalysis>> analyzeProcessTrends(
    String machineId, {
    DateTime? startDate,
    DateTime? endDate,
    List<String>? parameters,
  });

  /// Gets optimization suggestions based on analysis
  Future<Either<Failure, List<OptimizationSuggestion>>> getOptimizationSuggestions(
    String sessionId,
  );

  /// Validates analysis results
  Future<Either<Failure, ValidationResult>> validateAnalysisResults(
    String sessionId,
    SessionAnalysisReport report,
  );

  /// Exports analysis results in specified format
  Future<Either<Failure, String>> exportAnalysis(
    String sessionId,
    ExportFormat format,
  );

  /// Gets real-time analysis updates during session
  Stream<Either<Failure, RealTimeAnalysis>> watchRealTimeAnalysis(String sessionId);

  /// Archives analysis data
  Future<Either<Failure, void>> archiveAnalysis(String sessionId);

  /// Retrieves archived analysis data
  Future<Either<Failure, SessionAnalysisReport>> getArchivedAnalysis(String sessionId);
}

/// Real-time analysis data
class RealTimeAnalysis {
  final DateTime timestamp;
  final Map<String, double> currentMetrics;
  final List<ProcessDeviation> deviations;
  final QualityPrediction prediction;
  final Map<String, TrendInfo> trends;

  RealTimeAnalysis({
    required this.timestamp,
    required this.currentMetrics,
    required this.deviations,
    required this.prediction,
    required this.trends,
  });
}

/// Quality prediction for ongoing process
class QualityPrediction {
  final double predictedQuality;
  final double confidence;
  final Map<String, double> parameterContributions;
  final List<String> potentialIssues;

  QualityPrediction({
    required this.predictedQuality,
    required this.confidence,
    required this.parameterContributions,
    required this.potentialIssues,
  });
}

/// Trend information for a parameter
class TrendInfo {
  final TrendType type;
  final double slope;
  final double stability;
  final List<Point> recentPoints;

  TrendInfo({
    required this.type,
    required this.slope,
    required this.stability,
    required this.recentPoints,
  });
}

/// Data point for trend analysis
class Point {
  final DateTime timestamp;
  final double value;

  Point({
    required this.timestamp,
    required this.value,
  });
}

/// Analysis export formats
enum ExportFormat {
  csv,
  json,
  pdf,
  matlab
}

/// Validation result for analysis
class ValidationResult {
  final bool isValid;
  final List<String> issues;
  final Map<String, List<String>> parameterIssues;
  final double confidence;

  ValidationResult({
    required this.isValid,
    required this.issues,
    required this.parameterIssues,
    required this.confidence,
  });
}

/// Comparative analysis between sessions
class ComparativeAnalysis {
  final List<String> sessionIds;
  final Map<String, SessionAnalysisReport> reports;
  final List<Difference> significantDifferences;
  final Map<String, StatisticalComparison> parameterComparisons;
  final List<String> insights;

  ComparativeAnalysis({
    required this.sessionIds,
    required this.reports,
    required this.significantDifferences,
    required this.parameterComparisons,
    required this.insights,
  });
}

/// Represents a significant difference between sessions
class Difference {
  final String parameter;
  final String description;
  final double magnitude;
  final String impact;
  final List<String> possibleCauses;

  Difference({
    required this.parameter,
    required this.description,
    required this.magnitude,
    required this.impact,
    required this.possibleCauses,
  });
}

/// Statistical comparison between parameters
class StatisticalComparison {
  final String parameter;
  final double averageDifference;
  final double standardDeviation;
  final double significance;
  final bool isSignificant;
  final String interpretation;

  StatisticalComparison({
    required this.parameter,
    required this.averageDifference,
    required this.standardDeviation,
    required this.significance,
    required this.isSignificant,
    required this.interpretation,
  });
}