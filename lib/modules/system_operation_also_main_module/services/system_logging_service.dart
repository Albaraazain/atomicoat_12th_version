import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/system_component.dart';
import '../models/system_log_entry.dart';
import '../../../repositories/system_state_repository.dart';
import '../models/data_point.dart';

class SystemLoggingService {
  final SystemStateRepository _systemStateRepository;
  final List<SystemLogEntry> _systemLog = [];

  // Constants
  static const int MAX_LOG_ENTRIES = 1000;
  static const int MAX_DATA_POINTS_PER_PARAMETER = 1000;

  SystemLoggingService(this._systemStateRepository);

  List<SystemLogEntry> get systemLog => List.unmodifiable(_systemLog);

  Future<void> loadSystemLog(String userId) async {
    final logs = await _systemStateRepository.getSystemLog(userId);
    _systemLog.addAll(logs.take(MAX_LOG_ENTRIES));
    if (_systemLog.length > MAX_LOG_ENTRIES) {
      _systemLog.removeRange(0, _systemLog.length - MAX_LOG_ENTRIES);
    }
  }

  void addLogEntry(String userId, String message, ComponentStatus status) {
    SystemLogEntry logEntry = SystemLogEntry(
      timestamp: DateTime.now(),
      message: message,
      severity: status,
    );

    _systemLog.add(logEntry);
    if (_systemLog.length > MAX_LOG_ENTRIES) {
      _systemLog.removeAt(0);
    }

    _systemStateRepository.addLogEntry(userId, logEntry);
  }

  Future<void> fetchComponentHistory(
    String userId,
    String componentName,
    Function(String, String, DataPoint) addDataPointCallback
  ) async {
    final now = DateTime.now();
    final start = now.subtract(Duration(hours: 24));

    try {
      List<Map<String, dynamic>> historyData =
          await _systemStateRepository.getComponentHistory(
        userId,
        componentName,
        start,
        now,
      );

      for (var data in historyData.take(MAX_DATA_POINTS_PER_PARAMETER)) {
        final timestamp = (data['timestamp'] as Timestamp).toDate();
        final currentValues = Map<String, double>.from(data['currentValues']);

        currentValues.forEach((parameter, value) {
          addDataPointCallback(
            componentName,
            parameter,
            DataPoint(timestamp: timestamp, value: value),
          );
        });
      }
    } catch (e) {
      print("Error fetching component history for $componentName: $e");
    }
  }

  void logParameterValue(
    String componentName,
    String parameter,
    double value,
    Function(String, String, DataPoint) addDataPointCallback
  ) {
    addDataPointCallback(
      componentName,
      parameter,
      DataPoint.reducedPrecision(timestamp: DateTime.now(), value: value)
    );
  }

  Future<void> saveComponentState(String userId, SystemComponent component) async {
    await _systemStateRepository.saveComponentState(userId, component);
  }

  Future<void> saveSystemState(String userId, Map<String, dynamic> state) async {
    await _systemStateRepository.saveSystemState(userId, state);
  }
}
