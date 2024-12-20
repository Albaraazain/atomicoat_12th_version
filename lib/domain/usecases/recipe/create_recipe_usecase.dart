// lib/domain/usecases/recipe/create_recipe_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:experiment_planner/domain/failures/failures.dart';
import 'package:experiment_planner/domain/repositories/recipe_repository.dart';
import 'package:experiment_planner/domain/usecases/base_usecase.dart';
import 'package:experiment_planner/domain/usecases/params/recipe_params.dart';

class CreateRecipeUseCase implements UseCase<String, CreateRecipeParams> {
  final RecipeRepository repository;

  CreateRecipeUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(CreateRecipeParams params) {
    return repository.createRecipeFromParams(params);
  }
}
