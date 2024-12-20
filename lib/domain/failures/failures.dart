// lib/domain/failures/failures.dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final StackTrace? stackTrace;

  const Failure({
    required this.message,
    this.code,
    this.stackTrace,
  });

  @override
  List<Object?> get props => [message, code, stackTrace];
}

class MachineFailure extends Failure {
  const MachineFailure({
    required String message,
    String? code,
    StackTrace? stackTrace,
  }) : super(message: message, code: code, stackTrace: stackTrace);
}

class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure({
    required String message,
    this.fieldErrors,
    String? code,
    StackTrace? stackTrace,
  }) : super(message: message, code: code, stackTrace: stackTrace);

  @override
  List<Object?> get props => [...super.props, fieldErrors];
}

class SafetyFailure extends Failure {
  final String componentId;
  final String parameterId;
  final double currentValue;
  final double threshold;

  const SafetyFailure({
    required String message,
    required this.componentId,
    required this.parameterId,
    required this.currentValue,
    required this.threshold,
    String? code,
    StackTrace? stackTrace,
  }) : super(message: message, code: code, stackTrace: stackTrace);

  @override
  List<Object?> get props => [
    ...super.props,
    componentId,
    parameterId,
    currentValue,
    threshold,
  ];
}

class CacheFailure extends Failure {
  const CacheFailure({
    required String message,
    String? code,
    StackTrace? stackTrace,
  }) : super(message: message, code: code, stackTrace: stackTrace);
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    required String message,
    String? code,
    StackTrace? stackTrace,
  }) : super(message: message, code: code, stackTrace: stackTrace);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    required String message,
    String? code,
    StackTrace? stackTrace,
  }) : super(message: message, code: code, stackTrace: stackTrace);
}