import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:experiment_planner/domain/usecases/recipe/create_recipe_usecase.dart';
import 'package:experiment_planner/domain/usecases/recipe/get_recipes_usecase.dart';
import 'package:experiment_planner/domain/usecases/recipe/update_recipe_usecase.dart';
import 'recipe_event.dart';
import 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final GetRecipesUseCase getRecipes;
  final CreateRecipeUseCase createRecipe;
  final UpdateRecipeUseCase updateRecipe;

  RecipeBloc({
    required this.getRecipes,
    required this.createRecipe,
    required this.updateRecipe,
  }) : super(RecipeInitial()) {
    on<LoadRecipes>(_onLoadRecipes);
    on<CreateNewRecipe>(_onCreateRecipe);
    on<UpdateExistingRecipe>(_onUpdateRecipe);
  }

  Future<void> _onLoadRecipes(
    LoadRecipes event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeLoading());

    final result = await getRecipes(event.machineId);

    emit(result.fold(
      (failure) => RecipeError(failure.message),
      (recipes) => RecipesLoaded(recipes),
    ));
  }

  Future<void> _onCreateRecipe(
    CreateNewRecipe event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeLoading());

    final result = await createRecipe(event.params);

    emit(result.fold(
      (failure) => RecipeError(failure.message),
      (recipeId) => const RecipeOperationSuccess('Recipe created successfully'),
    ));
  }

  Future<void> _onUpdateRecipe(
    UpdateExistingRecipe event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeLoading());

    final result = await updateRecipe(event.recipe);

    emit(result.fold(
      (failure) => RecipeError(failure.message),
      (_) => const RecipeOperationSuccess('Recipe updated successfully'),
    ));
  }
}
