// lib/domain/interfaces/datasources/i_analysis_datasource.dart

import 'package:experiment_planner/domain/enums/analysis_enums.dart';
import 'package:experiment_planner/domain/models/analysis/correlation_result.dart';
import 'package:experiment_planner/domain/models/analysis/film_quality_analysis.dart';
import 'package:experiment_planner/domain/models/analysis/process_quality_analysis.dart';
import 'package:experiment_planner/domain/models/analysis/session_analysis_report.dart';

abstract class IAnalysisDataSource {
  /// Saves a session analysis report
  Future<void> saveAnalysisReport(SessionAnalysisReport report);

  /// Gets analysis report by session ID
  Future<SessionAnalysisReport?> getAnalysisReport(String sessionId);

  /// Gets analysis reports by date range
  Future<List<SessionAnalysisReport>> getAnalysisReports({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  });

  /// Saves film quality analysis results
  Future<void> saveFilmQualityAnalysis(
    String sessionId,
    FilmQualityAnalysis analysis,
  );

  /// Gets film quality analysis by session ID
  Future<FilmQualityAnalysis?> getFilmQualityAnalysis(String sessionId);

  /// Saves process quality analysis results
  Future<void> saveProcessQualityAnalysis(
    String sessionId,
    ProcessQualityAnalysis analysis,
  );

  /// Gets process quality analysis by session ID
  Future<ProcessQualityAnalysis?> getProcessQualityAnalysis(String sessionId);

  /// Saves correlation analysis results
  Future<void> saveCorrelationResults(
    String sessionId,
    List<CorrelationResult> correlations,
  );

  /// Gets correlation analysis results by session ID
  Future<List<CorrelationResult>> getCorrelationResults(String sessionId);

  /// Gets quality trends over time
  Future<QualityTrends> getQualityTrends({
    DateTime? startDate,
    DateTime? endDate,
    String? recipeId,
  });

  /// Gets comparative analysis between sessions
  Future<ComparativeAnalysis> getComparativeAnalysis(
    List<String> sessionIds,
  );

  /// Gets process optimization suggestions
  Future<List<OptimizationSuggestion>> getOptimizationSuggestions(
    String sessionId,
  );

  /// Saves analysis metadata
  Future<void> saveAnalysisMetadata(
    String sessionId,
    Map<String, dynamic> metadata,
  );

  /// Gets analysis metadata
  Future<Map<String, dynamic>?> getAnalysisMetadata(String sessionId);

  /// Gets analysis by specific criteria
  Future<List<SessionAnalysisReport>> getAnalysisByCriteria({
    double? minQualityScore,
    double? minUniformity,
    CrystallineStructure? crystallineStructure,
    ProcessQuality? processQuality,
    String? recipeId,
  });

  /// Exports analysis data to specified format
  Future<String> exportAnalysis(
    String sessionId,
    AnalysisExportFormat format,
  );
}

/// Format options for exporting analysis data
enum AnalysisExportFormat {
  csv,
  json,
  pdf,
  excel
}

/// Represents quality trends over time
class QualityTrends {
  final Map<DateTime, double> uniformityTrend;
  final Map<DateTime, double> thicknessTrend;
  final Map<DateTime, double> qualityScoreTrend;
  final List<TrendAnalysis> processParameterTrends;

  QualityTrends({
    required this.uniformityTrend,
    required this.thicknessTrend,
    required this.qualityScoreTrend,
    required this.processParameterTrends,
  });
}

/// Analysis of parameter trends
class TrendAnalysis {
  final String parameterName;
  final Map<DateTime, double> values;
  final TrendType trendType;
  final double correlation;
  final double significance;

  TrendAnalysis({
    required this.parameterName,
    required this.values,
    required this.trendType,
    required this.correlation,
    required this.significance,
  });
}

/// Comparative analysis between sessions
class ComparativeAnalysis {
  final Map<String, SessionAnalysisReport> sessionReports;
  final Map<String, List<String>> significantDifferences;
  final Map<String, double> performanceMetrics;
  final List<String> recommendations;

  ComparativeAnalysis({
    required this.sessionReports,
    required this.significantDifferences,
    required this.performanceMetrics,
    required this.recommendations,
  });
}

/// Suggestion for process optimization
class OptimizationSuggestion {
  final String description;
  final Map<String, dynamic> suggestedParameters;
  final double expectedImprovement;
  final double confidence;
  final List<String> supportingEvidence;

  OptimizationSuggestion({
    required this.description,
    required this.suggestedParameters,
    required this.expectedImprovement,
    required this.confidence,
    required this.supportingEvidence,
  });
}