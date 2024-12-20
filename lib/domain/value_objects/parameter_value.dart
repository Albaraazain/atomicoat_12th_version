// lib/domain/value_objects/parameter_value.dart
class ParameterValue extends ValueObject<double> {
  final double minValue;
  final double maxValue;

  @override
  final Either<ValueFailure<double>, double> value;

  factory ParameterValue(double input, double min, double max) {
    return ParameterValue._(
      validateParameterValue(input, min, max),
      min,
      max,
    );
  }

  const ParameterValue._(this.value, this.minValue, this.maxValue);

  bool isInRange() => value.fold(
    (failure) => false,
    (value) => value >= minValue && value <= maxValue,
  );
}
