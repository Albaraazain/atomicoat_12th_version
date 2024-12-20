// lib/domain/models/session/ald_session_result.dart
import 'package:experiment_planner/domain/entities/recipe/recipe.dart';
import 'package:experiment_planner/domain/models/analysis/analysis_result.dart';
import 'package:experiment_planner/domain/models/session/substrate_info.dart';
import 'package:experiment_planner/domain/models/process/data_point.dart';
import 'package:experiment_planner/domain/models/process/process_event.dart';

class SessionResult {
  final String sessionId;
  final DateTime startTime;
  final DateTime endTime;
  final int totalCycles;
  final Recipe recipe;
  final SubstrateInfo substrate;
  final AnalysisResult analysis;
  final Map<String, List<DataPoint>> processData;
  final List<ProcessEvent> events;

  SessionResult({
    required this.sessionId,
    required this.startTime,
    required this.endTime,
    required this.totalCycles,
    required this.recipe,
    required this.substrate,
    required this.analysis,
    required this.processData,
    required this.events,
  });

  Duration get duration => endTime.difference(startTime);

  bool get wasSuccessful =>
    analysis.qualityScore >= recipe.minimumQualityThreshold &&
    !events.any((e) => e.type == EventType.error);

  Map<String, dynamic> toReport() {
    return {
      'sessionId': sessionId,
      'date': startTime.toIso8601String(),
      'duration': duration.toString(),
      'recipe': recipe.name,
      'substrate': substrate.toString(),
      'targetThickness': recipe.targetThickness,
      'actualThickness': analysis.filmThickness,
      'uniformity': analysis.uniformity,
      'qualityScore': analysis.qualityScore,
      // Add more report fields...
    };
  }
}