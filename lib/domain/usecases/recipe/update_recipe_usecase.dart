import 'package:dartz/dartz.dart';
import 'package:experiment_planner/domain/entities/recipe/recipe.dart';
import 'package:experiment_planner/domain/failures/failures.dart';
import 'package:experiment_planner/domain/repositories/recipe_repository.dart';
import 'package:experiment_planner/domain/usecases/base_usecase.dart';

class UpdateRecipeUseCase implements UseCase<void, Recipe> {
  final RecipeRepository repository;

  UpdateRecipeUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(Recipe recipe) {
    return repository.updateRecipe(recipe);
  }
}
