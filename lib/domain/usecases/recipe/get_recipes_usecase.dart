import 'package:dartz/dartz.dart';
import 'package:experiment_planner/domain/entities/recipe/recipe.dart';
import 'package:experiment_planner/domain/failures/failures.dart';
import 'package:experiment_planner/domain/repositories/recipe_repository.dart';
import 'package:experiment_planner/domain/usecases/base_usecase.dart';

class GetRecipesUseCase implements UseCase<List<Recipe>, String> {
  final RecipeRepository repository;

  GetRecipesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Recipe>>> call(String machineId) {
    return repository.getRecipesByMachine(machineId);
  }
}
