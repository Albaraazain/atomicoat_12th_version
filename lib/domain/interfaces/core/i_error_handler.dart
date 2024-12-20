// lib/domain/interfaces/core/i_error_handler.dart

import 'package:experiment_planner/domain/failures/failures.dart';

abstract class IErrorHandler {
  /// Handles different types of failures and performs appropriate actions
  Future<void> handleFailure(Failure failure);

  /// Handles exceptions and converts them to appropriate Failure types
  Future<Failure> handleException(Object exception, [StackTrace? stackTrace]);

  /// Logs errors for debugging and monitoring
  Future<void> logError(Object error, StackTrace stackTrace, {String? context});

  /// Reports critical errors that need immediate attention
  Future<void> reportCriticalError(Failure failure);

  /// Determines if an error should trigger an emergency protocol
  bool shouldTriggerEmergencyProtocol(Failure failure);

  /// Gets a user-friendly error message for display
  String getUserFriendlyMessage(Failure failure);

  /// Handles validation failures specifically
  Future<void> handleValidationFailure(ValidationFailure failure);

  /// Handles safety-related failures
  Future<void> handleSafetyFailure(SafetyFailure failure);

  /// Records error metrics for monitoring
  Future<void> recordErrorMetrics(Failure failure);

  /// Gets suggested actions for resolving an error
  List<String> getSuggestedActions(Failure failure);
}