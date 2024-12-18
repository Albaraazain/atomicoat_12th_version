// lib/modules/system_operation_also_main_module/models/alarm.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Alarm {
  final String id;
  final String message;
  final AlarmSeverity severity;
  final DateTime timestamp;
  bool acknowledged;
  final bool isSafetyAlert;

  Alarm({
    required this.id,
    required this.message,
    required this.severity,
    required this.timestamp,
    this.acknowledged = false,
    this.isSafetyAlert = false,
  });

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      id: json['id'] as String,
      message: json['message'] as String,
      severity: AlarmSeverity.values.firstWhere((e) => e.toString() == 'AlarmSeverity.${json['severity']}'),
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      acknowledged: json['acknowledged'] as bool? ?? false,
      isSafetyAlert: json['isSafetyAlert'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'message': message,
    'severity': severity.toString().split('.').last,
    'timestamp': Timestamp.fromDate(timestamp),
    'acknowledged': acknowledged,
    'isSafetyAlert': isSafetyAlert,
  };

  Alarm copyWith({
    String? id,
    String? message,
    AlarmSeverity? severity,
    DateTime? timestamp,
    bool? acknowledged,
    bool? isSafetyAlert,
  }) {
    return Alarm(
      id: id ?? this.id,
      message: message ?? this.message,
      severity: severity ?? this.severity,
      timestamp: timestamp ?? this.timestamp,
      acknowledged: acknowledged ?? this.acknowledged,
      isSafetyAlert: isSafetyAlert ?? this.isSafetyAlert,
    );
  }
}

enum AlarmSeverity {
  info,
  warning,
  critical
}

/*
dart
Copy
enum AlarmSeverity { info, warning, critical }

class Alarm {
    /// Unique identifier for the alarm
    final String id;
    /// Alarm message describing the issue
    final String message;
    /// Severity level of the alarm
    final AlarmSeverity severity;
    /// Timestamp when alarm was created
    final DateTime timestamp;
    /// Whether the alarm has been acknowledged
    bool acknowledged;
    /// Whether this is a safety-related alarm
    final bool isSafetyAlert;

    /// Constructor for creating a new alarm
    Alarm({
        required this.id,
        required this.message,
        required this.severity,
        required this.timestamp,
        this.acknowledged = false,
        this.isSafetyAlert = false,
    });

    /// Creates a copy of the alarm with optional parameter updates
    Alarm copyWith({
        String? id,
        String? message,
        AlarmSeverity? severity,
        DateTime? timestamp,
        bool? acknowledged,
        bool? isSafetyAlert,
    });
}
*/