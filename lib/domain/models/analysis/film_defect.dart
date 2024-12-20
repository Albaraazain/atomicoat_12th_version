import 'package:equatable/equatable.dart';
import 'package:experiment_planner/domain/enums/analysis_enums.dart';

class FilmDefect extends Equatable {
  final DefectType type;
  final double severity;
  final String location;
  final double size;
  final String possibleCause;

  const FilmDefect({
    required this.type,
    required this.severity,
    required this.location,
    required this.size,
    required this.possibleCause,
  });

  @override
  List<Object> get props => [type, severity, location, size, possibleCause];
}
