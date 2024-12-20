// lib/domain/entities/machine/parameter.dart
import 'package:equatable/equatable.dart';

class Parameter extends Equatable {
  final String name;
  final List<Reading> readings;

  Parameter({
    required this.name,
    required this.readings,
  });

  double? getValueAtTime(DateTime timestamp) {
    final reading = readings.where((r) => r.timestamp == timestamp).firstOrNull;
    return reading?.value;
  }

  @override
  List<Object?> get props => [
    name,
    readings,
  ];
}

class Reading {
  final DateTime timestamp;
  final double value;

  Reading({
    required this.timestamp,
    required this.value,
  });
}

