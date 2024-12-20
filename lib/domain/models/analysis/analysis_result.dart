import 'package:equatable/equatable.dart';

// lib/domain/models/analysis/analysis_result.dart

class AnalysisResult extends Equatable {
  final double filmThickness;
  final double uniformity;
  final double surfaceRoughness;
  final double filmDensity;
  final String? crystallineStructure;
  final Map<String, double> composition;
  final double qualityScore;

  const AnalysisResult({
    required this.filmThickness,
    required this.uniformity,
    required this.surfaceRoughness,
    required this.filmDensity,
    this.crystallineStructure,
    required this.composition,
    required this.qualityScore,
  });

  @override
  List<Object?> get props => [
    filmThickness,
    uniformity,
    surfaceRoughness,
    filmDensity,
    crystallineStructure,
    composition,
    qualityScore,
  ];
}