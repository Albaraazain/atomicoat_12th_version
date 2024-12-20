import 'package:equatable/equatable.dart';
import '../../../domain/enums/alert_enums.dart';

abstract class AbstractAlert extends Equatable {
  final String id;
  final String message;
  final AlertSeverity severity;
  final DateTime timestamp;
  final String? componentId;

  const AbstractAlert({
    required this.id,
    required this.message,
    required this.severity,
    required this.timestamp,
    this.componentId,
  });

  @override
  List<Object?> get props => [
        id,
        message,
        severity,
        timestamp,
        componentId,
      ];
}
