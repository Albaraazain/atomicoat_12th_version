import 'package:equatable/equatable.dart';
import 'package:experiment_planner/domain/entities/recipe/recipe.dart';

abstract class RecipeState extends Equatable {
  const RecipeState();

  @override
  List<Object?> get props => [];
}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipesLoaded extends RecipeState {
  final List<Recipe> recipes;

  const RecipesLoaded(this.recipes);

  @override
  List<Object?> get props => [recipes];
}

class RecipeOperationSuccess extends RecipeState {
  final String message;

  const RecipeOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class RecipeError extends RecipeState {
  final String message;

  const RecipeError(this.message);

  @override
  List<Object?> get props => [message];
}
