// lib/domain/services/analysis/correlation_analyzer.dart
import 'dart:math' as math;
import 'package:ml_algo/ml_algo.dart';
import 'package:ml_dataframe/ml_dataframe.dart';
import '../../../../domain/entities/machine/parameter.dart';
import '../../models/analysis/correlation_result.dart';

class CorrelationAnalyzer {
  final List<Parameter> parameters;
  final Duration timeWindow;
  final int minDataPoints;

  CorrelationAnalyzer({
    required this.parameters,
    this.timeWindow = const Duration(hours: 1),
    this.minDataPoints = 30,
  });

  Future<List<CorrelationResult>> analyzeCorrelations() async {
    final results = <CorrelationResult>[];
    final timeSeriesData = _prepareTimeSeriesData();

    // Generate all possible parameter pairs
    for (int i = 0; i < parameters.length; i++) {
      for (int j = i + 1; j < parameters.length; j++) {
        final param1 = parameters[i];
        final param2 = parameters[j];

        final correlationData = _calculateCorrelation(
          timeSeriesData,
          param1.name,
          param2.name,
        );

        if (correlationData != null) {
          results.add(correlationData);
        }
      }
    }

    return results..sort((a, b) => b.strength.abs().compareTo(a.strength.abs()));
  }

  DataFrame _prepareTimeSeriesData() {
    // Get all unique timestamps
    final timestamps = <DateTime>{};
    for (final param in parameters) {
      timestamps.addAll(
        param.readings
            .map((data) => data.timestamp)
            .where((timestamp) =>
                timestamp.isAfter(DateTime.now().subtract(timeWindow))),
      );
    }

    final sortedTimestamps = timestamps.toList()..sort();

    // Convert Map data to List format for DataFrame
    final headerRow = ['timestamp', ...parameters.map((p) => p.name)];
    final rows = sortedTimestamps.map((timestamp) {
      return [
        timestamp.toIso8601String(), // Convert DateTime to String
        ...parameters.map((param) => param.getValueAtTime(timestamp)),
      ];
    }).toList();

    return DataFrame([headerRow, ...rows]);
  }

  CorrelationResult? _calculateCorrelation(
    DataFrame df,
    String param1,
    String param2,
  ) {
    try {
      // Replace samples with sampleFromRows using where condition
      final cleanRows = df.rows
          .where((row) {
            final map = Map<String, dynamic>.fromIterables(df.header, row);
            return map[param1] != null && map[param2] != null;
          })
          .toList();

      final cleanDf = DataFrame([
        df.header,
        ...cleanRows,
      ]);

      if (cleanDf.rows.length < minDataPoints) {
        return null;
      }

      // Get numeric data from series
      final x = cleanDf[param1].data.toList().cast<double>();
      final y = cleanDf[param2].data.toList().cast<double>();

      // Calculate Pearson correlation
      final correlation = _calculatePearsonCorrelation(x, y);

      // Calculate time-lagged correlations
      final laggedCorrelations = _calculateLaggedCorrelations(x, y);

      // Perform causality analysis
      final causalityResult = _performGrangerCausality(x, y);

      return CorrelationResult(
        parameter1: param1,
        parameter2: param2,
        strength: correlation,
        sampleSize: cleanDf.rows.length,
        timeWindow: timeWindow,
        laggedCorrelations: laggedCorrelations,
        causality: causalityResult,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      print('Error calculating correlation between $param1 and $param2: $e');
      return null;
    }
  }

  double _calculatePearsonCorrelation(List<double> x, List<double> y) {
    final n = x.length;

    if (n != y.length || n == 0) {
      throw ArgumentError('Lists must have equal non-zero length');
    }

    final sumX = x.reduce((a, b) => a + b);
    final sumY = y.reduce((a, b) => a + b);

    final sumXX = x.map((val) => val * val).reduce((a, b) => a + b);
    final sumYY = y.map((val) => val * val).reduce((a, b) => a + b);

    var sumXY = 0.0;
    for (var i = 0; i < n; i++) {
      sumXY += x[i] * y[i];
    }

    final numerator = n * sumXY - sumX * sumY;
    final denominator = math.sqrt((n * sumXX - sumX * sumX) * (n * sumYY - sumY * sumY));

    if (denominator == 0) return 0;

    return numerator / denominator;
  }

  Map<int, double> _calculateLaggedCorrelations(List<double> x, List<double> y) {
    const maxLag = 10; // Maximum lag to consider
    final results = <int, double>{};

    for (var lag = 0; lag <= maxLag; lag++) {
      if (lag >= x.length) break;

      final xLagged = x.sublist(lag);
      final yTrimmed = y.sublist(0, y.length - lag);

      results[lag] = _calculatePearsonCorrelation(xLagged, yTrimmed);
    }

    return results;
  }

  CausalityResult _performGrangerCausality(List<double> x, List<double> y) {
    // Implement Granger causality test
    // This is a simplified version - in practice, you'd want to use a proper
    // statistical package for this analysis

    const maxLag = 5;
    var bestLag = 0;
    var bestFScore = 0.0;
    var direction = CausalityDirection.none;

    // Test X -> Y
    final xToY = _grangerTest(x, y, maxLag);

    // Test Y -> X
    final yToX = _grangerTest(y, x, maxLag);

    if (xToY.pValue < 0.05 && yToX.pValue >= 0.05) {
      direction = CausalityDirection.forward;
      bestLag = xToY.lag;
      bestFScore = xToY.fScore;
    } else if (yToX.pValue < 0.05 && xToY.pValue >= 0.05) {
      direction = CausalityDirection.reverse;
      bestLag = yToX.lag;
      bestFScore = yToX.fScore;
    } else if (xToY.pValue < 0.05 && yToX.pValue < 0.05) {
      direction = CausalityDirection.bidirectional;
      bestLag = xToY.fScore > yToX.fScore ? xToY.lag : yToX.lag;
      bestFScore = math.max(xToY.fScore, yToX.fScore);
    }

    return CausalityResult(
      direction: direction,
      lag: bestLag,
      strength: bestFScore,
      confidence: 1 - math.min(xToY.pValue, yToX.pValue),
    );
  }

  GrangerTestResult _grangerTest(
    List<double> x,
    List<double> y,
    int maxLag,
  ) {
    var bestLag = 0;
    var bestFScore = 0.0;
    var bestPValue = 1.0;

    for (var lag = 1; lag <= maxLag; lag++) {
      // Prepare lagged data
      final xLagged = List<List<double>>.generate(
        lag,
        (i) => x.sublist(lag - i - 1, x.length - i - 1),
      );

      final yLagged = y.sublist(lag);

      // Perform regression analysis
      final result = _performRegression(xLagged, yLagged);

      if (result.fScore > bestFScore) {
        bestFScore = result.fScore;
        bestPValue = result.pValue;
        bestLag = lag;
      }
    }

    return GrangerTestResult(
      lag: bestLag,
      fScore: bestFScore,
      pValue: bestPValue,
    );
  }

  RegressionResult _performRegression(List<List<double>> xLagged, List<double> yLagged) {
    // Simple implementation of regression analysis
    // This is a placeholder - you should use a proper regression package
    return RegressionResult(
      fScore: 0.0,
      pValue: 1.0,
    );
  }
}

class RegressionResult {
  final double fScore;
  final double pValue;

  RegressionResult({required this.fScore, required this.pValue});
}