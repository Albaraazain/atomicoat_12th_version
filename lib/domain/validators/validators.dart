// lib/domain/validators/validators.dart
Either<ValueFailure<String>, String> validateMachineSerial(String input) {
  // Example format: ALD-2024-XXXX
  const pattern = r'^ALD-\d{4}-[A-Z0-9]{4}$';
  if (RegExp(pattern).hasMatch(input)) {
    return Right(input);
  } else {
    return Left(ValueFailure(
      message: 'Invalid machine serial format',
      failedValue: input,
    ));
  }
}

Either<ValueFailure<double>, double> validateParameterValue(
  double input,
  double min,
  double max,
) {
  if (input >= min && input <= max) {
    return Right(input);
  } else {
    return Left(ValueFailure(
      message: 'Value must be between $min and $max',
      failedValue: input,
    ));
  }
}

