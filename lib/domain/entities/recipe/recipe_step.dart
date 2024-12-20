// lib/domain/entities/recipe/recipe_step.dart
import 'package:equatable/equatable.dart';
import 'package:experiment_planner/domain/enums/recipe_enums.dart';

class RecipeStep extends Equatable {
  final String id;  // Has identity
  final int orderIndex;
  final StepType type;
  final Map<String, dynamic> parameters;
  final int? loopCount;
  final Duration duration;

  const RecipeStep({
    required this.id,
    required this.orderIndex,
    required this.type,
    required this.parameters,
    this.loopCount,
    required this.duration,
  });

  @override
  List<Object?> get props => [
    id,
    orderIndex,
    type,
    parameters,
    loopCount,
    duration
  ];
}

