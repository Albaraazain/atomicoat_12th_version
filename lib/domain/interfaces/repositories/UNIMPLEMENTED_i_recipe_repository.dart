// lib/domain/repositories/recipe_repository.dart
import 'package:dartz/dartz.dart';
import 'package:experiment_planner/domain/entities/recipe/recipe.dart';
import 'package:experiment_planner/domain/failures/failures.dart';
import 'package:experiment_planner/domain/usecases/params/recipe_params.dart';

abstract class RecipeRepository {
  Future<Either<Failure, Recipe>> getRecipe(String id);
  Future<Either<Failure, List<Recipe>>> getRecipesByMachine(String machineId);
  Future<Either<Failure, List<Recipe>>> getUserRecipes(String userId);
  Future<Either<Failure, String>> createRecipe(Recipe recipe);
  Future<Either<Failure, void>> updateRecipe(Recipe recipe);
  Future<Either<Failure, void>> deleteRecipe(String id);
  Future<Either<Failure, Recipe>> copyRecipe(String recipeId, String newUserId);
  Future<Either<Failure, String>> createRecipeFromParams(CreateRecipeParams params);
}
