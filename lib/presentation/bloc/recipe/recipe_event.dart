import 'package:equatable/equatable.dart';
import 'package:experiment_planner/domain/entities/recipe/recipe.dart';
import 'package:experiment_planner/domain/usecases/params/recipe_params.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object?> get props => [];
}

class LoadRecipes extends RecipeEvent {
  final String machineId;

  const LoadRecipes(this.machineId);

  @override
  List<Object?> get props => [machineId];
}

class CreateNewRecipe extends RecipeEvent {
  final CreateRecipeParams params;

  const CreateNewRecipe(this.params);

  @override
  List<Object?> get props => [params];
}

class UpdateExistingRecipe extends RecipeEvent {
  final Recipe recipe;

  const UpdateExistingRecipe(this.recipe);

  @override
  List<Object?> get props => [recipe];
}
