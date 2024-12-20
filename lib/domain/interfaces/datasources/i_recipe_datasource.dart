// lib/domain/interfaces/datasources/i_recipe_datasource.dart

import 'package:experiment_planner/domain/entities/recipe/recipe.dart';
import 'package:experiment_planner/domain/entities/recipe/recipe_step.dart';
import 'package:experiment_planner/domain/enums/process_enums.dart';
import 'package:experiment_planner/domain/enums/recipe_enums.dart';
import 'package:experiment_planner/domain/enums/validation_enums';
import 'package:experiment_planner/domain/models/analysis/process_issue.dart';
import 'package:experiment_planner/domain/models/analysis/process_quality_analysis.dart';

abstract class IRecipeDataSource {
  /// Creates a new recipe
  Future<String> createRecipe(Recipe recipe);

  /// Gets recipe by ID
  Future<Recipe?> getRecipe(String id);

  /// Updates existing recipe
  Future<void> updateRecipe(Recipe recipe);

  /// Deletes recipe
  Future<void> deleteRecipe(String id);

  /// Gets all recipes for a specific machine
  Future<List<Recipe>> getRecipesByMachine(String machineId);

  /// Gets recipes created by a specific user
  Future<List<Recipe>> getUserRecipes(String userId);

  /// Creates a copy of a recipe
  Future<Recipe> cloneRecipe(String recipeId, String newUserId);

  /// Creates a new recipe version
  Future<String> createRecipeVersion(
    String originalRecipeId,
    Recipe newVersion,
    String changeDescription,
  );

  /// Gets recipe version history
  Future<List<RecipeVersion>> getRecipeVersions(String recipeId);

  /// Gets recipe performance metrics
  Future<RecipePerformance> getRecipePerformance(
    String recipeId, {
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Validates recipe parameters
  Future<RecipeValidation> validateRecipe(Recipe recipe);

  /// Gets optimization history for a recipe
  Future<List<RecipeOptimization>> getOptimizationHistory(String recipeId);

  /// Saves recipe optimization result
  Future<void> saveOptimizationResult(
    String recipeId,
    RecipeOptimization optimization,
  );

  /// Gets similar recipes based on parameters
  Future<List<Recipe>> getSimilarRecipes(
    String recipeId, {
    double similarityThreshold = 0.8,
  });

  /// Gets recommended parameter ranges
  Future<Map<String, ParameterRange>> getRecommendedRanges(String recipeId);

  /// Tags a recipe version as stable/tested
  Future<void> tagRecipeVersion(
    String recipeId,
    String versionId,
    RecipeTag tag,
  );

  /// Exports recipe to specified format
  Future<String> exportRecipe(String recipeId, RecipeExportFormat format);
}

/// Represents a version of a recipe
class RecipeVersion {
  final String versionId;
  final Recipe recipe;
  final String changeDescription;
  final String createdBy;
  final DateTime createdAt;
  final List<RecipeTag> tags;
  final ProcessQuality? quality;

  RecipeVersion({
    required this.versionId,
    required this.recipe,
    required this.changeDescription,
    required this.createdBy,
    required this.createdAt,
    required this.tags,
    this.quality,
  });
}

/// Recipe performance metrics
class RecipePerformance {
  final int totalRuns;
  final double successRate;
  final double averageQualityScore;
  final Map<String, ProcessStatistics> processStats;
  final List<ProcessIssue> commonIssues;
  final Map<String, double> parameterStability;

  RecipePerformance({
    required this.totalRuns,
    required this.successRate,
    required this.averageQualityScore,
    required this.processStats,
    required this.commonIssues,
    required this.parameterStability,
  });
}

/// Process statistics for recipe steps
class ProcessStatistics {
  final double averageDuration;
  final double standardDeviation;
  final Map<String, double> parameterRanges;
  final double stability;
  final int anomalyCount;

  ProcessStatistics({
    required this.averageDuration,
    required this.standardDeviation,
    required this.parameterRanges,
    required this.stability,
    required this.anomalyCount,
  });
}

/// Recipe validation result
class RecipeValidation {
  final bool isValid;
  final List<ValidationIssue> issues;
  final Map<String, List<String>> parameterIssues;
  final List<String> suggestions;

  RecipeValidation({
    required this.isValid,
    required this.issues,
    required this.parameterIssues,
    required this.suggestions,
  });
}

/// Recipe optimization record
class RecipeOptimization {
  final String id;
  final DateTime timestamp;
  final String initiatedBy;
  final Map<String, dynamic> originalParameters;
  final Map<String, dynamic> optimizedParameters;
  final double improvementScore;
  final String justification;
  final List<String> experimentalEvidence;

  RecipeOptimization({
    required this.id,
    required this.timestamp,
    required this.initiatedBy,
    required this.originalParameters,
    required this.optimizedParameters,
    required this.improvementScore,
    required this.justification,
    required this.experimentalEvidence,
  });
}

/// Recommended parameter range
class ParameterRange {
  final double minimum;
  final double maximum;
  final double optimal;
  final double confidence;
  final List<String> supportingData;

  ParameterRange({
    required this.minimum,
    required this.maximum,
    required this.optimal,
    required this.confidence,
    required this.supportingData,
  });
}



