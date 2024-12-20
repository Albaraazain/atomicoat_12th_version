// lib/domain/interfaces/repositories/i_recipe_repository.dart

import 'package:dartz/dartz.dart';
import 'package:experiment_planner/domain/entities/recipe/recipe.dart';
import 'package:experiment_planner/domain/entities/recipe/recipe_step.dart';
import 'package:experiment_planner/domain/enums/validation_enums.dart';
import 'package:experiment_planner/domain/failures/failures.dart';
import 'package:experiment_planner/domain/enums/recipe_enums.dart';
import 'package:experiment_planner/domain/enums/process_enums.dart';
import 'package:experiment_planner/domain/interfaces/repositories/i_machine_repository.dart';
import 'package:experiment_planner/domain/models/process/process_event.dart';

abstract class IRecipeRepository {
  /// Creates a new recipe
  Future<Either<Failure, String>> createRecipe(Recipe recipe);

  /// Gets recipe by ID
  Future<Either<Failure, Recipe>> getRecipe(String id);

  /// Gets all recipes for a machine
  Future<Either<Failure, List<Recipe>>> getRecipesByMachine(String machineId);

  /// Gets recipes created by a user
  Future<Either<Failure, List<Recipe>>> getUserRecipes(String userId);

  /// Updates an existing recipe
  Future<Either<Failure, void>> updateRecipe(Recipe recipe);

  /// Deletes a recipe
  Future<Either<Failure, void>> deleteRecipe(String id);

  /// Creates a copy of an existing recipe
  Future<Either<Failure, Recipe>> copyRecipe(String recipeId, String newUserId);

  /// Gets recipe version history
  Future<Either<Failure, List<RecipeVersion>>> getRecipeVersions(String recipeId);

  /// Creates a new recipe version
  Future<Either<Failure, String>> createRecipeVersion(
    String recipeId,
    Recipe newVersion,
    String changeDescription,
  );

  /// Gets recipe execution history
  Future<Either<Failure, List<RecipeExecution>>> getRecipeExecutions(
    String recipeId, {
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Gets recipe performance metrics
  Future<Either<Failure, RecipePerformanceMetrics>> getRecipePerformance(
    String recipeId,
  );

  /// Validates recipe parameters
  Future<Either<Failure, RecipeValidation>> validateRecipe(Recipe recipe);

  /// Gets optimization suggestions
  Future<Either<Failure, List<RecipeOptimization>>> getOptimizationSuggestions(
    String recipeId,
  );

  /// Saves optimization result
  Future<Either<Failure, void>> saveOptimizationResult(
    String recipeId,
    RecipeOptimization optimization,
  );

  /// Gets similar recipes
  Future<Either<Failure, List<Recipe>>> getSimilarRecipes(
    String recipeId, {
    double similarityThreshold = 0.8,
  });

  /// Exports recipe to specified format
  Future<Either<Failure, String>> exportRecipe(
    String recipeId,
    RecipeExportFormat format,
  );
}

/// Recipe version information
class RecipeVersion {
  final String versionId;
  final Recipe recipe;
  final String changeDescription;
  final String createdBy;
  final DateTime createdAt;
  final List<String> tags;
  final VersionStatus status;

  RecipeVersion({
    required this.versionId,
    required this.recipe,
    required this.changeDescription,
    required this.createdBy,
    required this.createdAt,
    required this.tags,
    required this.status,
  });
}

/// Recipe execution record
class RecipeExecution {
  final String sessionId;
  final DateTime startTime;
  final DateTime endTime;
  final String operatorId;
  final ExecutionStatus status;
  final Map<String, ProcessMetric> processMetrics;
  final List<ProcessEvent> events;
  final QualityResults qualityResults;

  RecipeExecution({
    required this.sessionId,
    required this.startTime,
    required this.endTime,
    required this.operatorId,
    required this.status,
    required this.processMetrics,
    required this.events,
    required this.qualityResults,
  });
}

/// Process metric data
class ProcessMetric {
  final String name;
  final double average;
  final double minimum;
  final double maximum;
  final double standardDeviation;
  final double stability;
  final List<Deviation> deviations;

  ProcessMetric({
    required this.name,
    required this.average,
    required this.minimum,
    required this.maximum,
    required this.standardDeviation,
    required this.stability,
    required this.deviations,
  });
}

/// Process event
class ProcessEvent {
  final DateTime timestamp;
  final ProcessPhase phase;
  final String description;
  final EventType type;
  final Map<String, dynamic>? data;

  ProcessEvent({
    required this.timestamp,
    required this.phase,
    required this.description,
    required this.type,
    this.data,
  });
}

/// Quality results
class QualityResults {
  final double thickness;
  final double uniformity;
  final double quality;
  final Map<String, double> composition;
  final List<String> issues;

  QualityResults({
    required this.thickness,
    required this.uniformity,
    required this.quality,
    required this.composition,
    required this.issues,
  });
}

/// Recipe performance metrics
class RecipePerformanceMetrics {
  final int totalExecutions;
  final double successRate;
  final double averageQuality;
  final Duration averageDuration;
  final Map<String, ProcessStatistics> processStats;
  final List<QualityTrend> qualityTrends;
  final List<ParameterCorrelation> parameterCorrelations;

  RecipePerformanceMetrics({
    required this.totalExecutions,
    required this.successRate,
    required this.averageQuality,
    required this.averageDuration,
    required this.processStats,
    required this.qualityTrends,
    required this.parameterCorrelations,
  });
}

/// Recipe validation result
class RecipeValidation {
  final bool isValid;
  final List<ValidationIssue> issues;
  final Map<String, List<String>> parameterIssues;
  final List<String> suggestions;
  final double safetyScore;

  RecipeValidation({
    required this.isValid,
    required this.issues,
    required this.parameterIssues,
    required this.suggestions,
    required this.safetyScore,
  });
}

/// Recipe optimization suggestion
class RecipeOptimization {
  final String id;
  final DateTime timestamp;
  final String initiatedBy;
  final Map<String, dynamic> originalParameters;
  final Map<String, dynamic> optimizedParameters;
  final double improvementScore;
  final String justification;
  final List<String> experimentalEvidence;
  final Map<String, OptimizationMetric> metrics;
  final OptimizationStatus status;

  RecipeOptimization({
    required this.id,
    required this.timestamp,
    required this.initiatedBy,
    required this.originalParameters,
    required this.optimizedParameters,
    required this.improvementScore,
    required this.justification,
    required this.experimentalEvidence,
    required this.metrics,
    required this.status,
  });
}

/// Metric for optimization analysis
class OptimizationMetric {
  final String name;
  final double originalValue;
  final double optimizedValue;
  final double improvement;
  final double confidence;
  final List<String> supportingData;

  OptimizationMetric({
    required this.name,
    required this.originalValue,
    required this.optimizedValue,
    required this.improvement,
    required this.confidence,
    required this.supportingData,
  });
}

/// Process statistics
class ProcessStatistics {
  final double mean;
  final double standardDeviation;
  final double stability;
  final List<Deviation> significantDeviations;
  final Map<String, CorrelationInfo> correlations;

  ProcessStatistics({
    required this.mean,
    required this.standardDeviation,
    required this.stability,
    required this.significantDeviations,
    required this.correlations,
  });
}

/// Quality trend analysis
class QualityTrend {
  final String metric;
  final List<TrendPoint> points;
  final double slope;
  final String interpretation;
  final double confidence;
  final List<String> influencingFactors;

  QualityTrend({
    required this.metric,
    required this.points,
    required this.slope,
    required this.interpretation,
    required this.confidence,
    required this.influencingFactors,
  });
}

/// Parameter correlation analysis
class ParameterCorrelation {
  final String parameter1;
  final String parameter2;
  final double correlationCoefficient;
  final String relationship;
  final double significance;
  final List<CorrelationPoint> data;

  ParameterCorrelation({
    required this.parameter1,
    required this.parameter2,
    required this.correlationCoefficient,
    required this.relationship,
    required this.significance,
    required this.data,
  });
}

/// Correlation data point
class CorrelationPoint {
  final double x;
  final double y;
  final DateTime timestamp;
  final String? sessionId;

  CorrelationPoint({
    required this.x,
    required this.y,
    required this.timestamp,
    this.sessionId,
  });
}

/// Correlation information
class CorrelationInfo {
  final String targetParameter;
  final double coefficient;
  final double pValue;
  final String interpretation;

  CorrelationInfo({
    required this.targetParameter,
    required this.coefficient,
    required this.pValue,
    required this.interpretation,
  });
}

/// Process deviation
class Deviation {
  final DateTime timestamp;
  final String parameter;
  final double expectedValue;
  final double actualValue;
  final double significance;
  final String? cause;
  final DeviationSeverity severity;

  Deviation({
    required this.timestamp,
    required this.parameter,
    required this.expectedValue,
    required this.actualValue,
    required this.significance,
    this.cause,
    required this.severity,
  });
}

/// Validation issue
class ValidationIssue {
  final String code;
  final String message;
  final String? parameter;
  final ValidationSeverity severity;
  final String? recommendation;

  ValidationIssue({
    required this.code,
    required this.message,
    this.parameter,
    required this.severity,
    this.recommendation,
  });
}

/// Trend data point
class TrendPoint {
  final DateTime timestamp;
  final double value;
  final String? sessionId;
  final Map<String, dynamic>? metadata;

  TrendPoint({
    required this.timestamp,
    required this.value,
    this.sessionId,
    this.metadata,
  });
}

