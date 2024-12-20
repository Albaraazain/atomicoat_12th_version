import 'package:experiment_planner/domain/enums/analysis_enums.dart';
import 'package:experiment_planner/domain/models/analysis/film_defect.dart';
import '../../value_objects/analysis/film_quality.dart';

class FilmQualityAnalysis {
  final FilmThickness thickness;
  final FilmUniformity uniformity;
  final double roughness;
  final double density;
  final CrystallineStructure crystallineStructure;
  final Map<String, double> composition;
  final double qualityScore;
  final List<FilmDefect> defects;

  FilmQualityAnalysis({
    required this.thickness,
    required this.uniformity,
    required this.roughness,
    required this.density,
    required this.crystallineStructure,
    required this.composition,
    required this.qualityScore,
    required this.defects,
  });

  bool meetsSpecification(Map<String, double> specifications) {
    return specifications.entries.every((spec) {
      switch (spec.key) {
        case 'thickness':
          return thickness.getOrCrash() >= spec.value * 0.95;
        case 'uniformity':
          return uniformity.getOrCrash() >= spec.value;
        case 'roughness': return roughness <= spec.value;
        case 'density': return density >= spec.value * 0.98;
        default: return true;
      }
    });
  }
}
