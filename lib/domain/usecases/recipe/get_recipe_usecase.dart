import 'package:dartz/dartz.dart';
import 'package:experiment_planner/domain/entities/recipe/recipe.dart';
import 'package:experiment_planner/domain/failures/failures.dart';
import 'package:experiment_planner/domain/repositories/recipe_repository.dart';
import 'package:experiment_planner/domain/usecases/base_usecase.dart';

class GetRecipeUseCase implements UseCase<Recipe, String> {
  final RecipeRepository repository;

  GetRecipeUseCase(this.repository);

  @override
  Future<Either<Failure, Recipe>> call(String recipeId) {
    return repository.getRecipe(recipeId);
  }
}
