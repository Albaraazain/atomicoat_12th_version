// /lib/domain/services/analysis/session_analyzer.dart
import 'package:experiment_planner/domain/enums/analysis_enums.dart' show CrystallineStructure, DefectType, DeviationSeverity, IssueSeverity, IssueType, ProcessQuality, RecommendationPriority, RecommendationType;
import 'package:experiment_planner/domain/models/analysis/film_defect.dart';
import 'package:experiment_planner/domain/models/analysis/process_recommendation.dart';
import 'package:experiment_planner/domain/models/session/session_result.dart';
import 'package:experiment_planner/domain/services/analysis/statistical_analyzer.dart';
import 'package:experiment_planner/domain/models/analysis/session_analysis_report.dart';
import 'package:experiment_planner/domain/models/analysis/process_quality_analysis.dart';
import 'package:experiment_planner/domain/models/analysis/film_quality_analysis.dart';
import 'package:experiment_planner/domain/models/analysis/process_issue.dart';
import 'package:experiment_planner/domain/models/analysis/film_defect.dart' hide FilmDefect;
import 'package:experiment_planner/domain/enums/session_enums.dart';
import 'package:experiment_planner/domain/value_objects/analysis/film_quality.dart';

class SessionAnalyzer {
  final SessionResult session;

  SessionAnalyzer(this.session);

  SessionAnalysisReport generateReport() {
    return SessionAnalysisReport(
      sessionInfo: _analyzeSessionInfo(),
      processQuality: _analyzeProcessQuality(),
      filmQuality: _analyzeFilmQuality(),
      recommendations: _generateRecommendations(),
    );
  }

  SessionInfo _analyzeSessionInfo() {
    final cycleTime = session.duration.inSeconds / session.totalCycles;
    final efficiency = session.analysis.filmThickness /
                      session.recipe.targetThickness;

    return SessionInfo(
      actualDuration: session.duration,
      expectedDuration: session.recipe.expectedDuration,
      averageCycleTime: cycleTime,
      processEfficiency: efficiency,
      deviations: _findProcessDeviations(),
    );
  }

  List<ProcessDeviation> _findProcessDeviations() {
    final deviations = <ProcessDeviation>[];

    // Check temperature stability
    final tempData = session.processData['temperature'] ?? [];
    if (tempData.isNotEmpty) {
      final stats = StatisticalAnalyzer.analyze(tempData);
      if (stats.standardDeviation > session.recipe.temperatureTolerance) {
        deviations.add(ProcessDeviation(
          parameter: 'Temperature',
          severity: DeviationSeverity.warning,
          description: 'Temperature instability detected',
          impact: 'May affect film uniformity',
        ));
      }
    }

    // Add more deviation checks...
    return deviations;
  }

  ProcessQualityAnalysis _analyzeProcessQuality() {
    final qualityScore = _determineOverallQuality();
    return ProcessQualityAnalysis(
      overallQuality: _mapQualityScore(qualityScore),
      stabilityScore: _calculateStabilityScore(),
      uniformityScore: _calculateUniformityScore(),
      cycleConsistencyScore: _calculateCycleConsistency(),
      identifiedIssues: _identifyProcessIssues(),
      parameterScores: _calculateParameterScores(),
    );
  }

  ProcessQuality _mapQualityScore(double score) {
    if (score >= 0.9) return ProcessQuality.optimal;
    if (score >= 0.7) return ProcessQuality.acceptable;
    if (score >= 0.5) return ProcessQuality.suboptimal;
    return ProcessQuality.unacceptable;
  }

  FilmQualityAnalysis _analyzeFilmQuality() {
    final analysis = session.analysis;
    final crystalStructure = analysis.crystallineStructure is CrystallineStructure
        ? analysis.crystallineStructure as CrystallineStructure
        : CrystallineStructure.unknown;

    return FilmQualityAnalysis(
      thickness: FilmThickness(analysis.filmThickness),
      uniformity: FilmUniformity(analysis.uniformity),
      roughness: analysis.surfaceRoughness,
      density: analysis.filmDensity,
      crystallineStructure: crystalStructure,
      composition: analysis.composition,
      qualityScore: analysis.qualityScore,
      defects: _identifyFilmDefects(),
    );
  }

  List<ProcessRecommendation> _generateRecommendations() {
    final recommendations = <ProcessRecommendation>[];

    if (_calculateStabilityScore() < 0.8) {
      recommendations.add(
        ProcessRecommendation(
          title: 'Improve Temperature Control',
          description: 'Temperature stability is below optimal threshold',
          priority: RecommendationPriority.high,
          type: RecommendationType.processOptimization,
          suggestedParameters: {
            'pidKp': 0.8,
            'pidKi': 0.2,
            'pidKd': 0.1,
          },
          expectedOutcome: 'Better film uniformity and crystalline structure',
          confidenceLevel: 0.85,
        ),
      );
    }

    return recommendations;
  }

  double _determineOverallQuality() {
    final stability = _calculateStabilityScore();
    final uniformity = _calculateUniformityScore();
    final consistency = _calculateCycleConsistency();

    // Weighted average of different quality aspects
    return (stability * 0.4) + (uniformity * 0.3) + (consistency * 0.3);
  }

  double _calculateStabilityScore() {
    double score = 1.0;

    // Analyze temperature stability
    final tempData = session.processData['temperature'] ?? [];
    if (tempData.isNotEmpty) {
      final stats = StatisticalAnalyzer.analyze(tempData);
      score *= _normalizeDeviation(stats.standardDeviation, session.recipe.temperatureTolerance);
    }

    // Add more stability calculations
    return score.clamp(0.0, 1.0);
  }

  double _calculateUniformityScore() {
    final uniformity = session.analysis.uniformity;
    return _normalizeValue(uniformity, 0.8, 1.0); // Normalize between 80-100%
  }

  double _calculateCycleConsistency() {
    // Analyze cycle-to-cycle variation
    final cycleData = session.processData['cycleTime'] ?? [];
    if (cycleData.isEmpty) return 1.0;

    final stats = StatisticalAnalyzer.analyze(cycleData);
    return _normalizeDeviation(stats.standardDeviation, session.recipe.expectedDuration.inSeconds * 0.1);
  }

  List<ProcessIssue> _identifyProcessIssues() {
    final issues = <ProcessIssue>[];

    // Check process parameters
    if (_calculateStabilityScore() < 0.7) {
      issues.add(
        ProcessIssue(
          type: IssueType.stability,
          severity: IssueSeverity.warning,
          description: 'Process stability below threshold',
        ),
      );
    }

    return issues;
  }

  Map<String, double> _calculateParameterScores() {
    return {
      'temperature': _calculateStabilityScore(),
      'pressure': _calculatePressureScore(),
      'flow': _calculateFlowScore(),
    };
  }

  List<FilmDefect> _identifyFilmDefects() {
    final defects = <FilmDefect>[];

    if (session.analysis.uniformity < 0.9) {
      defects.add(
        FilmDefect(
          type: DefectType.nonUniformity,
          severity: 0.7,  // Severity as double between 0-1
          location: 'Film surface',
          size: 0.0,  // Size in appropriate units
          possibleCause: 'Poor thickness uniformity detected',
        ),
      );
    }

    return defects;
  }

  // Helper methods
  double _normalizeDeviation(double deviation, double tolerance) {
    if (deviation <= tolerance) return 1.0;
    return (1.0 - (deviation - tolerance) / tolerance).clamp(0.0, 1.0);
  }

  double _normalizeValue(double value, double min, double max) {
    return ((value - min) / (max - min)).clamp(0.0, 1.0);
  }

  double _calculatePressureScore() {
    final pressureData = session.processData['pressure'] ?? [];
    if (pressureData.isEmpty) return 1.0;

    final stats = StatisticalAnalyzer.analyze(pressureData);
    return _normalizeDeviation(stats.standardDeviation, session.recipe.pressureTolerance);
  }

  double _calculateFlowScore() {
    final flowData = session.processData['flow'] ?? [];
    if (flowData.isEmpty) return 1.0;

    final stats = StatisticalAnalyzer.analyze(flowData);
    return _normalizeDeviation(stats.standardDeviation, session.recipe.flowTolerance);
  }
}
