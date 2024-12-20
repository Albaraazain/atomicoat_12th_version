// lib/domain/entities/recipe/recipe.dart
import 'package:equatable/equatable.dart';
import 'package:experiment_planner/domain/entities/recipe/recipe_step.dart';

class Recipe extends Equatable {
  final String id;
  final String name;
  final String description;
  final String creatorId;
  final bool isPrivate;
  final List<RecipeStep> steps;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final double targetThickness;
  final double minimumQualityThreshold;
  final Duration expectedDuration;
  final double temperatureTolerance;
  final double pressureTolerance;
  final double flowTolerance;

  const Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.creatorId,
    required this.isPrivate,
    required this.steps,
    required this.createdAt,
    required this.modifiedAt,
    required this.targetThickness,
    required this.minimumQualityThreshold,
    required this.expectedDuration,
    required this.temperatureTolerance,
    required this.pressureTolerance,
    required this.flowTolerance,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    creatorId,
    isPrivate,
    steps,
    createdAt,
    modifiedAt,
    targetThickness,
    minimumQualityThreshold,
    expectedDuration,
    temperatureTolerance,
    pressureTolerance,
    flowTolerance,
  ];
}
