// lib/domain/usecases/params/recipe_params.dart
import 'package:experiment_planner/domain/entities/recipe/recipe_step.dart';
import 'package:equatable/equatable.dart';

class CreateRecipeParams extends Equatable {
  final String name;
  final String description;
  final String creatorId;
  final String machineId;
  final bool isPrivate;
  final List<RecipeStep> steps;

  const CreateRecipeParams({
    required this.name,
    required this.description,
    required this.creatorId,
    required this.machineId,
    required this.isPrivate,
    required this.steps,
  });

  @override
  List<Object?> get props => [
    name,
    description,
    creatorId,
    machineId,
    isPrivate,
    steps,
  ];
}
