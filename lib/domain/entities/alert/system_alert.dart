import 'package:equatable/equatable.dart';
import '../../../domain/enums/alert_enums.dart';
import 'abstract_alert.dart';

class SystemAlert extends AbstractAlert {
  final bool isAcknowledged;
  final bool isResolved;
  final bool isMuted;
  final String? acknowledgedBy;
  final DateTime? acknowledgedAt;
  final String? resolvedBy;
  final DateTime? resolvedAt;

  const SystemAlert({
    required super.id,
    required super.message,
    required super.severity,
    required super.timestamp,
    super.componentId,
    this.isAcknowledged = false,
    this.isResolved = false,
    this.isMuted = false,
    this.acknowledgedBy,
    this.acknowledgedAt,
    this.resolvedBy,
    this.resolvedAt,
  });

  SystemAlert copyWith({
    String? id,
    String? message,
    AlertSeverity? severity,
    DateTime? timestamp,
    String? componentId,
    bool? isAcknowledged,
    bool? isResolved,
    bool? isMuted,
    String? acknowledgedBy,
    DateTime? acknowledgedAt,
    String? resolvedBy,
    DateTime? resolvedAt,
  }) {
    return SystemAlert(
      id: id ?? this.id,
      message: message ?? this.message,
      severity: severity ?? this.severity,
      timestamp: timestamp ?? this.timestamp,
      componentId: componentId ?? this.componentId,
      isAcknowledged: isAcknowledged ?? this.isAcknowledged,
      isResolved: isResolved ?? this.isResolved,
      isMuted: isMuted ?? this.isMuted,
      acknowledgedBy: acknowledgedBy ?? this.acknowledgedBy,
      acknowledgedAt: acknowledgedAt ?? this.acknowledgedAt,
      resolvedBy: resolvedBy ?? this.resolvedBy,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        isAcknowledged,
        isResolved,
        isMuted,
        acknowledgedBy,
        acknowledgedAt,
        resolvedBy,
        resolvedAt,
      ];
}
