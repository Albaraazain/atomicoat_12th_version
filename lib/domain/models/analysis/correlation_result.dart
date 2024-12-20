import 'package:equatable/equatable.dart';

enum CausalityDirection {
  none,
  forward,
  reverse,
  bidirectional,
}

class CausalityResult {
  final CausalityDirection direction;
  final int lag;
  final double strength;
  final double confidence;

  const CausalityResult({
    required this.direction,
    required this.lag,
    required this.strength,
    required this.confidence,
  });
}

class CorrelationResult extends Equatable {
  final String parameter1;
  final String parameter2;
  final double strength;
  final int sampleSize;
  final Duration timeWindow;
  final Map<int, double> laggedCorrelations;
  final CausalityResult causality;
  final DateTime timestamp;

  const CorrelationResult({
    required this.parameter1,
    required this.parameter2,
    required this.strength,
    required this.sampleSize,
    required this.timeWindow,
    required this.laggedCorrelations,
    required this.causality,
    required this.timestamp,
  });

  @override
  List<Object> get props => [
        parameter1,
        parameter2,
        strength,
        sampleSize,
        timeWindow,
        laggedCorrelations,
        causality,
        timestamp,
      ];

  Map<String, dynamic> toJson() => {
        'parameter1': parameter1,
        'parameter2': parameter2,
        'strength': strength,
        'sampleSize': sampleSize,
        'timeWindow': timeWindow.inMilliseconds,
        'laggedCorrelations': laggedCorrelations,
        'causality': {
          'direction': causality.direction.toString(),
          'lag': causality.lag,
          'strength': causality.strength,
          'confidence': causality.confidence,
        },
        'timestamp': timestamp.toIso8601String(),
      };

  factory CorrelationResult.fromJson(Map<String, dynamic> json) {
    return CorrelationResult(
      parameter1: json['parameter1'],
      parameter2: json['parameter2'],
      strength: json['strength'],
      sampleSize: json['sampleSize'],
      timeWindow: Duration(milliseconds: json['timeWindow']),
      laggedCorrelations: Map<int, double>.from(json['laggedCorrelations']),
      causality: CausalityResult(
        direction: CausalityDirection.values.firstWhere(
          (d) => d.toString() == json['causality']['direction'],
        ),
        lag: json['causality']['lag'],
        strength: json['causality']['strength'],
        confidence: json['causality']['confidence'],
      ),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class GrangerTestResult {
  final int lag;
  final double fScore;
  final double pValue;

  const GrangerTestResult({
    required this.lag,
    required this.fScore,
    required this.pValue,
  });
}
