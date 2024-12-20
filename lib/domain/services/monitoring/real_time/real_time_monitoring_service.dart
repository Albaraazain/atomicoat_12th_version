// lib/domain/services/monitoring/real_time_monitoring_service.dart
import 'dart:async';
import 'package:experiment_planner/core/services/websocket/websocket_service.dart';
import 'package:experiment_planner/domain/enums/alert_enums.dart';
import 'package:experiment_planner/domain/enums/component_enums.dart';
import 'package:experiment_planner/domain/models/monitoring/system_health.dart';
import 'package:rxdart/rxdart.dart';

class RealTimeMonitoringService {
  final WebSocketService _webSocketService;
  final Map<String, StreamController<double>> _parameterControllers = {};
  final _alertController = BehaviorSubject<MonitoringAlert>();
  final _healthController = BehaviorSubject<SystemHealth>();

  Timer? _healthCheckTimer;
  DateTime? _lastMessageTimestamp;

  static const _healthCheckInterval = Duration(seconds: 10);
  static const _healthyDataInterval = Duration(seconds: 5);

  RealTimeMonitoringService({
    required WebSocketService webSocketService,
  }) : _webSocketService = webSocketService {
    _initialize();
  }

  void _initialize() {
    _webSocketService.messages.listen(
      _handleMessage,
      onError: _handleError,
    );

    _webSocketService.connectionState.listen((state) {
      if (state == ConnectionState.connected) {
        _startHealthCheck();
      } else {
        _healthCheckTimer?.cancel();
      }
    });
  }

  Stream<double> subscribeToParameter(String parameterId) {
    if (!_parameterControllers.containsKey(parameterId)) {
      _parameterControllers[parameterId] = BehaviorSubject<double>();
    }
    return _parameterControllers[parameterId]!.stream;
  }

  Stream<MonitoringAlert> get alerts => _alertController.stream;
  Stream<SystemHealth> get systemHealth => _healthController.stream;

  void _handleMessage(dynamic message) {
    _lastMessageTimestamp = DateTime.now();

    try {
      final data = _parseMessage(message);
      _processData(data);
    } catch (e) {
      print('Error processing message: $e');
      _emitAlert(
        MonitoringAlert(
          type: AlertType.dataProcessing,
          message: 'Error processing monitoring data: $e',
          severity: AlertSeverity.warning,
        ),
      );
    }
  }

  Map<String, dynamic> _parseMessage(dynamic message) {
    if (message is String) {
      return jsonDecode(message);
    }
    return message as Map<String, dynamic>;
  }

  void _processData(Map<String, dynamic> data) {
    // Process parameter updates
    if (data.containsKey('parameters')) {
      final parameters = data['parameters'] as Map<String, dynamic>;
      for (final entry in parameters.entries) {
        final controller = _parameterControllers[entry.key];
        if (controller != null) {
          controller.add(entry.value as double);
        }
      }
    }

    // Process system status
    if (data.containsKey('status')) {
      _processSystemStatus(data['status']);
    }

    // Process alerts
    if (data.containsKey('alerts')) {
      _processAlerts(data['alerts']);
    }
  }

  void _processSystemStatus(Map<String, dynamic> status) {
    final health = SystemHealth(
      timestamp: DateTime.now(),
      status: SystemStatus.fromString(status['state']),
      components: (status['components'] as List).map((c) =>
        ComponentHealth.fromJson(c)).toList(),
      metrics: SystemMetrics.fromJson(status['metrics']),
    );

    _healthController.add(health);

    // Check for critical conditions
    _checkCriticalConditions(health);
  }

  void _processAlerts(List<dynamic> alerts) {
    for (final alert in alerts) {
      _emitAlert(MonitoringAlert.fromJson(alert));
    }
  }

  void _checkCriticalConditions(SystemHealth health) {
    // Check component health
    for (final component in health.components) {
      if (component.status == ComponentStatus.critical) {
        _emitAlert(
          MonitoringAlert(
            type: AlertType.componentFailure,
            message: 'Critical condition: ${component.name}',
            severity: AlertSeverity.critical,
            componentId: component.id,
          ),
        );
      }
    }

    // Check system metrics
    if (health.metrics.cpuUsage > 90) {
      _emitAlert(
        MonitoringAlert(
          type: AlertType.systemResource,
          message: 'High CPU usage: ${health.metrics.cpuUsage}%',
          severity: AlertSeverity.warning,
        ),
      );
    }

    if (health.metrics.memoryUsage > 90) {
      _emitAlert(
        MonitoringAlert(
          type: AlertType.systemResource,
          message: 'High memory usage: ${health.metrics.memoryUsage}%',
          severity: AlertSeverity.warning,
        ),
      );
    }
  }

  void _startHealthCheck() {
    _healthCheckTimer?.cancel();
    _healthCheckTimer = Timer.periodic(_healthCheckInterval, (timer) {
      final now = DateTime.now();
      final lastMessage = _lastMessageTimestamp;

      if (lastMessage != null &&
          now.difference(lastMessage) > _healthyDataInterval) {
        _emitAlert(
          MonitoringAlert(
            type: AlertType.connection,
            message: 'No data received for ${now.difference(lastMessage).inSeconds} seconds',
            severity: AlertSeverity.warning,
          ),
        );
      }
    });
  }

  void _emitAlert(MonitoringAlert alert) {
    _alertController.add(alert);
  }

  void _handleError(dynamic error) {
    print('Monitoring error: $error');
    _emitAlert(
      MonitoringAlert(
        type: AlertType.system,
        message: 'Monitoring system error: $error',
        severity: AlertSeverity.error,
      ),
    );
  }

  Future<void> dispose() async {
    _healthCheckTimer?.cancel();
    for (final controller in _parameterControllers.values) {
      await controller.close();
    }
    await _alertController.close();
    await _healthController.close();
  }
}