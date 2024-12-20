import 'dart:math' as math;
import 'package:experiment_planner/domain/models/process/data_point.dart';
import 'package:experiment_planner/domain/enums/analysis_enums.dart';

class StatisticalAnalyzer {
  static StatisticalSummary analyze(List<DataPoint> data) {
    if (data.isEmpty) {
      throw AnalysisException('Cannot analyze empty dataset');
    }

    final values = data.map((d) => d.value).toList();
    final mean = _calculateMean(values);
    final stdDev = _calculateStdDev(values, mean);
    final quartiles = _calculateQuartiles(values);
    final outliers = _detectOutliers(values, quartiles);
    final trends = _analyzeTrends(data);

    return StatisticalSummary(
      mean: mean,
      standardDeviation: stdDev,
      quartiles: quartiles,
      outliers: outliers,
      trends: trends,
    );
  }

  static double _calculateMean(List<double> values) {
    return values.reduce((a, b) => a + b) / values.length;
  }

  static double _calculateStdDev(List<double> values, double mean) {
    final squares = values.map((v) => math.pow(v - mean, 2));
    return math.sqrt(squares.reduce((a, b) => a + b) / (values.length - 1));
  }

  static Quartiles _calculateQuartiles(List<double> values) {
    values.sort();
    return Quartiles(
      q1: _findQuartile(values, 0.25),
      q2: _findQuartile(values, 0.5),
      q3: _findQuartile(values, 0.75),
    );
  }

  static double _findQuartile(List<double> values, double percentile) {
    final index = (values.length - 1) * percentile;
    final lower = values[index.floor()];
    final upper = values[index.ceil()];
    return lower + (upper - lower) * (index - index.floor());
  }

  static List<Outlier> _detectOutliers(List<double> values, Quartiles quartiles) {
    final outliers = <Outlier>[];
    final mean = _calculateMean(values);
    final stdDev = _calculateStdDev(values, mean);
    final iqr = quartiles.iqr;
    final lowerBound = quartiles.q1 - (1.5 * iqr);
    final upperBound = quartiles.q3 + (1.5 * iqr);

    for (var i = 0; i < values.length; i++) {
      final value = values[i];
      if (value < lowerBound || value > upperBound) {
        final zscore = (value - mean) / stdDev;
        outliers.add(
          Outlier(
            dataPoint: DataPoint(
              timestamp: DateTime.now(),
              value: value,
              sensorId: 'sensor-$i',
            ),
            severity: _determineOutlierSeverity(zscore.abs()),
            zscore: zscore,
          ),
        );
      }
    }

    return outliers;
  }

  static OutlierSeverity _determineOutlierSeverity(double zscoreAbs) {
    if (zscoreAbs > 3.0) return OutlierSeverity.severe;
    if (zscoreAbs > 2.0) return OutlierSeverity.moderate;
    return OutlierSeverity.mild;
  }

  static List<Trend> _analyzeTrends(List<DataPoint> data) {
    if (data.length < 3) return [];

    final trends = <Trend>[];
    final values = data.map((d) => d.value).toList();
    final timeIntervals = List.generate(
      data.length - 1,
      (i) => data[i + 1].timestamp.difference(data[i].timestamp).inSeconds.toDouble(),
    );

    // Calculate moving average to smooth out noise
    final movingAvg = _calculateMovingAverage(values, 3);

    // Detect trends using linear regression on segments
    var currentTrend = _identifyTrendSegment(
      data.sublist(0, math.min(10, data.length)),
      timeIntervals.sublist(0, math.min(9, data.length - 1)),
    );

    if (currentTrend != null) {
      trends.add(currentTrend);
    }

    // Look for trend changes
    for (var i = 10; i < data.length - 10; i += 5) {
      final segment = data.sublist(i, math.min(i + 10, data.length));
      final timeSegment = timeIntervals.sublist(
        i - 1,
        math.min(i + 9, data.length - 1),
      );

      final newTrend = _identifyTrendSegment(segment, timeSegment);

      if (newTrend != null && _isTrendChange(currentTrend!, newTrend)) {
        trends.add(newTrend);
        currentTrend = newTrend;
      }
    }

    return trends;
  }

  static List<double> _calculateMovingAverage(List<double> values, int window) {
    final result = <double>[];
    for (var i = 0; i <= values.length - window; i++) {
      final sum = values.sublist(i, i + window).reduce((a, b) => a + b);
      result.add(sum / window);
    }
    return result;
  }

  static Trend? _identifyTrendSegment(
    List<DataPoint> segment,
    List<double> timeIntervals,
  ) {
    if (segment.length < 3) return null;

    final x = List.generate(segment.length, (i) => i.toDouble());
    final y = segment.map((d) => d.value).toList();

    final slope = _calculateSlope(x, y);
    final confidence = _calculateConfidence(x, y, slope);

    if (confidence < 0.5) return null;

    return Trend(
      type: _determineTrendType(slope),
      points: segment,
      slope: slope,
      confidence: confidence,
    );
  }

  static bool _isTrendChange(Trend current, Trend next) {
    return current.type != next.type ||
           (current.slope - next.slope).abs() > 0.1;
  }

  static double _calculateSlope(List<double> x, List<double> y) {
    final n = x.length;
    final sumX = x.reduce((a, b) => a + b);
    final sumY = y.reduce((a, b) => a + b);
    final sumXY = List.generate(n, (i) => x[i] * y[i]).reduce((a, b) => a + b);
    final sumX2 = x.map((xi) => xi * xi).reduce((a, b) => a + b);

    return (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
  }

  static double _calculateConfidence(
    List<double> x,
    List<double> y,
    double slope,
  ) {
    final yMean = y.reduce((a, b) => a + b) / y.length;
    final predictions = x.map((xi) => slope * xi).toList();

    final ssRes = List.generate(x.length, (i) =>
      math.pow(y[i] - predictions[i], 2)
    ).reduce((a, b) => a + b);

    final ssTot = y.map((yi) =>
      math.pow(yi - yMean, 2)
    ).reduce((a, b) => a + b);

    return 1 - (ssRes / ssTot);
  }

  static TrendType _determineTrendType(double slope) {
    if (slope.abs() < 0.01) return TrendType.stable;
    return slope > 0 ? TrendType.increasing : TrendType.decreasing;
  }
}

class StatisticalSummary {
  final double mean;
  final double standardDeviation;
  final Quartiles quartiles;
  final List<Outlier> outliers;
  final List<Trend> trends;

  StatisticalSummary({
    required this.mean,
    required this.standardDeviation,
    required this.quartiles,
    required this.outliers,
    required this.trends,
  });
}

class Quartiles {
  final double q1;
  final double q2;
  final double q3;

  Quartiles({
    required this.q1,
    required this.q2,
    required this.q3,
  });

  double get iqr => q3 - q1;
}

class Outlier {
  final DataPoint dataPoint;
  final OutlierSeverity severity;
  final double zscore;

  Outlier({
    required this.dataPoint,
    required this.severity,
    required this.zscore,
  });
}

class Trend {
  final TrendType type;
  final List<DataPoint> points;
  final double slope;
  final double confidence;

  Trend({
    required this.type,
    required this.points,
    required this.slope,
    required this.confidence,
  });
}

class AnalysisException implements Exception {
  final String message;
  AnalysisException(this.message);
}
