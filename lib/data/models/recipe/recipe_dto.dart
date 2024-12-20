import 'package:experiment_planner/domain/entities/recipe/recipe.dart';
import 'package:experiment_planner/domain/entities/recipe/recipe_step.dart';
import 'package:experiment_planner/domain/enums/recipe_enums.dart';

class RecipeDTO {
  final String id;
  final String name;
  final String description;
  final String creatorId;
  final bool isPrivate;
  final List<RecipeStepDTO> steps;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final double targetThickness;
  final double minimumQualityThreshold;
  final Duration expectedDuration;
  final double temperatureTolerance;
  final double pressureTolerance;
  final double flowTolerance;

  const RecipeDTO({
    required this.id,
    required this.name,
    required this.description,
    required this.creatorId,
    required this.isPrivate,
    required this.steps,
    required this.createdAt,
    required this.modifiedAt,
    required this.targetThickness,
    required this.minimumQualityThreshold,
    required this.expectedDuration,
    required this.temperatureTolerance,
    required this.pressureTolerance,
    required this.flowTolerance,
  });

  factory RecipeDTO.fromDomain(Recipe recipe) {
    return RecipeDTO(
      id: recipe.id,
      name: recipe.name,
      description: recipe.description,
      creatorId: recipe.creatorId,
      isPrivate: recipe.isPrivate,
      steps: recipe.steps.map((step) => RecipeStepDTO.fromDomain(step)).toList(),
      createdAt: recipe.createdAt,
      modifiedAt: recipe.modifiedAt,
      targetThickness: recipe.targetThickness,
      minimumQualityThreshold: recipe.minimumQualityThreshold,
      expectedDuration: recipe.expectedDuration,
      temperatureTolerance: recipe.temperatureTolerance,
      pressureTolerance: recipe.pressureTolerance,
      flowTolerance: recipe.flowTolerance,
    );
  }

  Recipe toDomain() {
    return Recipe(
      id: id,
      name: name,
      description: description,
      creatorId: creatorId,
      isPrivate: isPrivate,
      steps: steps.map((step) => step.toDomain()).toList(),
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      targetThickness: targetThickness,
      minimumQualityThreshold: minimumQualityThreshold,
      expectedDuration: expectedDuration,
      temperatureTolerance: temperatureTolerance,
      pressureTolerance: pressureTolerance,
      flowTolerance: flowTolerance,
    );
  }

  factory RecipeDTO.fromJson(Map<String, dynamic> json) {
    return RecipeDTO(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      creatorId: json['creatorId'] as String,
      isPrivate: json['isPrivate'] as bool,
      steps: (json['steps'] as List<dynamic>)
          .map((step) => RecipeStepDTO.fromJson(step as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      modifiedAt: DateTime.parse(json['modifiedAt'] as String),
      targetThickness: json['targetThickness'] as double,
      minimumQualityThreshold: json['minimumQualityThreshold'] as double,
      expectedDuration: Duration(seconds: json['expectedDuration'] as int),
      temperatureTolerance: json['temperatureTolerance'] as double,
      pressureTolerance: json['pressureTolerance'] as double,
      flowTolerance: json['flowTolerance'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'creatorId': creatorId,
      'isPrivate': isPrivate,
      'steps': steps.map((step) => step.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
      'targetThickness': targetThickness,
      'minimumQualityThreshold': minimumQualityThreshold,
      'expectedDuration': expectedDuration.inSeconds,
      'temperatureTolerance': temperatureTolerance,
      'pressureTolerance': pressureTolerance,
      'flowTolerance': flowTolerance,
    };
  }
}

class RecipeStepDTO {
  final String id;
  final int orderIndex;
  final String type;
  final Map<String, dynamic> parameters;
  final int? loopCount;
  final int durationInSeconds;

  const RecipeStepDTO({
    required this.id,
    required this.orderIndex,
    required this.type,
    required this.parameters,
    this.loopCount,
    required this.durationInSeconds,
  });

  factory RecipeStepDTO.fromDomain(RecipeStep step) {
    return RecipeStepDTO(
      id: step.id,
      orderIndex: step.orderIndex,
      type: step.type.toString().split('.').last,
      parameters: step.parameters,
      loopCount: step.loopCount,
      durationInSeconds: step.duration.inSeconds,
    );
  }

  RecipeStep toDomain() {
    return RecipeStep(
      id: id,
      orderIndex: orderIndex,
      type: StepType.values.firstWhere(
          (e) => e.toString().split('.').last == type),
      parameters: parameters,
      loopCount: loopCount,
      duration: Duration(seconds: durationInSeconds),
    );
  }

  factory RecipeStepDTO.fromJson(Map<String, dynamic> json) {
    return RecipeStepDTO(
      id: json['id'] as String,
      orderIndex: json['orderIndex'] as int,
      type: json['type'] as String,
      parameters: json['parameters'] as Map<String, dynamic>,
      loopCount: json['loopCount'] as int?,
      durationInSeconds: json['durationInSeconds'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderIndex': orderIndex,
      'type': type,
      'parameters': parameters,
      'loopCount': loopCount,
      'durationInSeconds': durationInSeconds,
    };
  }
}
