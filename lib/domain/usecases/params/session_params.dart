// lib/domain/usecases/params/session_params.dart
import 'package:equatable/equatable.dart';

class StartSessionParams extends Equatable {
  final String userId;
  final String machineId;
  final String? recipeId;
  final String description;

  const StartSessionParams({
    required this.userId,
    required this.machineId,
    this.recipeId,
    required this.description,
  });

  @override
  List<Object?> get props => [userId, machineId, recipeId, description];
}
