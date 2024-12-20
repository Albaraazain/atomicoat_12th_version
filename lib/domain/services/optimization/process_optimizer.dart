// lib/domain/services/optimization/process_optimizer.dart
import 'package:ml_algo/ml_algo.dart';
import '../../../../domain/entities/machine/parameter.dart';
import '../../../../domain/entities/recipe/recipe.dart';
import '../../models/session/session.dart';

class ProcessOptimizer {
  final List<Session> historicalSessions;
  final List<Recipe> recipes;

  ProcessOptimizer({
    required this.historicalSessions,
    required this.recipes,
  });

  Future<List<OptimizationSuggestion>> generateSuggestions() async {
    final suggestions = <OptimizationSuggestion>[];

    suggestions.addAll(await _analyzeParameterCorrelations());
    suggestions.addAll(await _analyzeRecipePerformance());
    suggestions.addAll(await _analyzeEnergyEfficiency());
    suggestions.addAll(await _analyzeCycleTime());

    return suggestions..sort((a, b) => b.impact.compareTo(a.impact));
  }

  Future<List<OptimizationSuggestion>> _analyzeParameterCorrelations() async {
    final suggestions = <OptimizationSuggestion>[];

    for (final session in historicalSessions) {
      final correlations = _calculateParameterCorrelations(session);

      for (final correlation in correlations) {
        if (correlation.coefficient.abs() > 0.8) {
          suggestions.add(OptimizationSuggestion(
            type: SuggestionType.parameterCorrelation,
            description: 'Strong correlation found between ${correlation.parameter1} '
                'and ${correlation.parameter2}',
            recommendation: 'Consider adjusting ${correlation.parameter1} to optimize '
                '${correlation.parameter2}',
            impact: correlation.coefficient.abs(),
            confidence: _calculateConfidenceScore(correlation),
          ));
        }
      }
    }

    return suggestions;
  }

  Future<List<OptimizationSuggestion>> _analyzeRecipePerformance() async {
    final suggestions = <OptimizationSuggestion>[];
    final recipePerformance = <String, RecipePerformanceMetrics>{};

    // Calculate performance metrics for each recipe
    for (final recipe in recipes) {
      final sessions = historicalSessions
          .where((session) => session.recipeId == recipe.id)
          .toList();

      if (sessions.isEmpty) continue;

      final metrics = _calculateRecipePerformanceMetrics(sessions);
      recipePerformance[recipe.id] = metrics;

      // Analyze recipe steps
      final stepSuggestions = _analyzeRecipeSteps(recipe, sessions);
      suggestions.addAll(stepSuggestions);
    }

    // Compare recipes for similar processes
    final similarRecipes = _findSimilarRecipes(recipes);
    for (final pair in similarRecipes) {
      final performance1 = recipePerformance[pair.recipe1.id];
      final performance2 = recipePerformance[pair.recipe2.id];

      if (performance1 != null && performance2 != null) {
        final comparison = _compareRecipePerformance(
          pair.recipe1,
          performance1,
          pair.recipe2,
          performance2,
        );
        suggestions.add(comparison);
      }
    }

    return suggestions;
  }

  Future<List<OptimizationSuggestion>> _analyzeEnergyEfficiency() async {
    final suggestions = <OptimizationSuggestion>[];

    for (final session in historicalSessions) {
      final energyMetrics = _calculateEnergyMetrics(session);

      // Check for energy consumption patterns
      final highConsumptionPeriods = _findHighConsumptionPeriods(energyMetrics);
      for (final period in highConsumptionPeriods) {
        suggestions.add(OptimizationSuggestion(
          type: SuggestionType.energyEfficiency,
          description: 'High energy consumption detected during ${period.phase}',
          recommendation: 'Consider optimizing ${period.component} settings '
              'to reduce energy consumption',
          impact: period.excessConsumption,
          confidence: period.confidence,
        ));
      }

      // Analyze idle time energy consumption
      final idleTimeWaste = _analyzeIdleTimeEnergy(session);
      if (idleTimeWaste.significance > 0.7) {
        suggestions.add(OptimizationSuggestion(
          type: SuggestionType.energyEfficiency,
          description: 'Significant energy consumption during idle periods',
          recommendation: 'Implement automated shutdown procedures for '
              'non-critical components during idle periods',
          impact: idleTimeWaste.wastage,
          confidence: idleTimeWaste.confidence,
        ));
      }
    }

    return suggestions;
  }

  Future<List<OptimizationSuggestion>> _analyzeCycleTime() async {
    final suggestions = <OptimizationSuggestion>[];

    for (final recipe in recipes) {
      final sessions = historicalSessions
          .where((session) => session.recipeId == recipe.id)
          .toList();

      if (sessions.isEmpty) continue;

      final cycleTimeAnalysis = _analyzeCycleTimeComponents(recipe, sessions);

      // Identify bottlenecks
      for (final bottleneck in cycleTimeAnalysis.bottlenecks) {
        suggestions.add(OptimizationSuggestion(
          type: SuggestionType.cycleTime,
          description: 'Process bottleneck identified in ${bottleneck.step}',
          recommendation: bottleneck.recommendation,
          impact: bottleneck.impact,
          confidence: bottleneck.confidence,
        ));
      }

      // Analyze parallel processing opportunities
      final parallelizableSteps = _findParallelizableSteps(recipe);
      for (final steps in parallelizableSteps) {
        suggestions.add(OptimizationSuggestion(
          type: SuggestionType.cycleTime,
          description: 'Potential for parallel processing identified',
          recommendation: 'Consider running ${steps.step1} and ${steps.step2} '
              'in parallel to reduce cycle time',
          impact: steps.potentialTimeSaving,
          confidence: steps.confidence,
        ));
      }
    }

    return suggestions;
  }

  double _calculateConfidenceScore(ParameterCorrelation correlation) {
    return min(
      1.0,
      (correlation.dataPoints.length / 100) * // Data points factor
          correlation.coefficient.abs() * // Correlation strength
          (1 - correlation.pValue), // Statistical significance
    );
  }
}

