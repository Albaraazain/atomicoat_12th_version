import 'abstract_alert.dart';
import '../../../domain/enums/alert_enums.dart';

class MonitoringAlert extends AbstractAlert {
  final double? currentValue;
  final double? thresholdValue;
  final String? unit;
  final MonitoringAlertType type;
  final Map<String, dynamic>? metadata;

  const MonitoringAlert({
    required super.id,
    required super.message,
    required super.severity,
    required super.timestamp,
    required this.type,
    super.componentId,
    this.currentValue,
    this.thresholdValue,
    this.unit,
    this.metadata,
  });

  MonitoringAlert copyWith({
    String? id,
    String? message,
    AlertSeverity? severity,
    DateTime? timestamp,
    String? componentId,
    double? currentValue,
    double? thresholdValue,
    String? unit,
    MonitoringAlertType? type,
    Map<String, dynamic>? metadata,
  }) {
    return MonitoringAlert(
      id: id ?? this.id,
      message: message ?? this.message,
      severity: severity ?? this.severity,
      timestamp: timestamp ?? this.timestamp,
      componentId: componentId ?? this.componentId,
      currentValue: currentValue ?? this.currentValue,
      thresholdValue: thresholdValue ?? this.thresholdValue,
      unit: unit ?? this.unit,
      type: type ?? this.type,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        currentValue,
        thresholdValue,
        unit,
        type,
        metadata,
      ];
}
