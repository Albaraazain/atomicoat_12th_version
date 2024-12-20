// lib/domain/interfaces/core/i_logger.dart

import 'package:experiment_planner/domain/enums/session_enums.dart';
import 'package:experiment_planner/domain/failures/failures.dart';

abstract class ILogger {
  /// Logs a debug message
  void debug(
    String message, {
    Map<String, dynamic>? data,
    String? componentId,
  });

  /// Logs an info message
  void info(
    String message, {
    Map<String, dynamic>? data,
    String? componentId,
  });

  /// Logs a warning message
  void warning(
    String message, {
    Map<String, dynamic>? data,
    String? componentId,
    StackTrace? stackTrace,
  });

  /// Logs an error message
  void error(
    String message, {
    Object? error,
    Map<String, dynamic>? data,
    String? componentId,
    StackTrace? stackTrace,
  });

  /// Logs a critical error message
  void critical(
    String message, {
    Object? error,
    Map<String, dynamic>? data,
    String? componentId,
    StackTrace? stackTrace,
  });

  /// Logs machine-specific events
  void logMachineEvent(
    String machineId,
    String event, {
    Map<String, dynamic>? data,
    LogLevel level = LogLevel.info,
  });

  /// Logs session-specific events
  void logSessionEvent(
    String sessionId,
    String event, {
    Map<String, dynamic>? data,
    LogLevel level = LogLevel.info,
  });

  /// Logs system failures
  void logFailure(
    Failure failure, {
    Map<String, dynamic>? context,
    StackTrace? stackTrace,
  });

  /// Gets logs for a specific time range
  Future<List<LogEntry>> getLogs(
    DateTime start,
    DateTime end, {
    LogLevel? minLevel,
    String? componentId,
  });

  /// Gets logs for a specific session
  Future<List<LogEntry>> getSessionLogs(
    String sessionId, {
    LogLevel? minLevel,
  });

  /// Clears logs older than the specified duration
  Future<void> clearOldLogs(Duration age);

  /// Exports logs to a file
  Future<String> exportLogs(
    DateTime start,
    DateTime end, {
    LogLevel? minLevel,
    String? componentId,
  });
}

/// Represents a log entry
class LogEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String message;
  final String? componentId;
  final Map<String, dynamic>? data;
  final String? error;
  final String? stackTrace;

  LogEntry({
    required this.timestamp,
    required this.level,
    required this.message,
    this.componentId,
    this.data,
    this.error,
    this.stackTrace,
  });

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'level': level.toString(),
        'message': message,
        if (componentId != null) 'componentId': componentId,
        if (data != null) 'data': data,
        if (error != null) 'error': error,
        if (stackTrace != null) 'stackTrace': stackTrace,
      };
}

/// Configuration for the logger
class LoggerConfig {
  final LogLevel minimumLevel;
  final bool enableConsoleOutput;
  final bool enableFileOutput;
  final String? logFilePath;
  final int maxFileSize; // in bytes
  final int maxFiles;
  final Duration retentionPeriod;

  const LoggerConfig({
    this.minimumLevel = LogLevel.info,
    this.enableConsoleOutput = true,
    this.enableFileOutput = true,
    this.logFilePath,
    this.maxFileSize = 10 * 1024 * 1024, // 10MB
    this.maxFiles = 5,
    this.retentionPeriod = const Duration(days: 30),
  });
}