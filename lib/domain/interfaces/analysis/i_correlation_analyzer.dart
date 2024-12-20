import '../../entities/machine/parameter.dart';
import '../../models/analysis/correlation_result.dart';

abstract class ICorrelationAnalyzer {
  Future<List<CorrelationResult>> analyzeCorrelations();
  Future<CorrelationResult?> analyzeParameterPair(Parameter param1, Parameter param2);
  Future<Map<int, double>> calculateLaggedCorrelations(List<double> series1, List<double> series2);
  Future<CausalityResult> analyzeCausality(List<double> series1, List<double> series2);
  Future<Map<String, List<CorrelationResult>>> groupCorrelationsByStrength({
    double weakThreshold = 0.3,
    double moderateThreshold = 0.6,
    double strongThreshold = 0.8,
  });
}
