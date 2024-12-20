import 'package:experiment_planner/domain/models/analysis/process_deviation.dart';

class SessionInfo {
  final Duration actualDuration;
  final Duration expectedDuration;
  final double averageCycleTime;
  final double processEfficiency;
  final List<ProcessDeviation> deviations;

  SessionInfo({
    required this.actualDuration,
    required this.expectedDuration,
    required this.averageCycleTime,
    required this.processEfficiency,
    required this.deviations,
  });
}
