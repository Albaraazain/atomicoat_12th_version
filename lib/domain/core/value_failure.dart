abstract class ValueFailure<T> {
  final T failedValue;
  const ValueFailure(this.failedValue);

  // Add factory constructors
  factory ValueFailure.invalidThickness(T failedValue) = InvalidThickness<T>;
  factory ValueFailure.invalidUniformity(T failedValue) = InvalidUniformity<T>;
  factory ValueFailure.exceedsMaxValue(T failedValue, double maxValue) = ExceedsMaxValue<T>;
  factory ValueFailure.lessThanMinValue(T failedValue, double minValue) = LessThanMinValue<T>;
  factory ValueFailure.measurementTooLow(T failedValue, double minValue) = MeasurementTooLow<T>;
  factory ValueFailure.measurementTooHigh(T failedValue, double maxValue) = MeasurementTooHigh<T>;
}

class InvalidThickness<T> extends ValueFailure<T> {
  const InvalidThickness(T failedValue) : super(failedValue);
}

class InvalidUniformity<T> extends ValueFailure<T> {
  const InvalidUniformity(T failedValue) : super(failedValue);
}

class ExceedsMaxValue<T> extends ValueFailure<T> {
  final double maxValue;
  const ExceedsMaxValue(T failedValue, this.maxValue) : super(failedValue);
}

class LessThanMinValue<T> extends ValueFailure<T> {
  final double minValue;
  const LessThanMinValue(T failedValue, this.minValue) : super(failedValue);
}

class MeasurementTooLow<T> extends ValueFailure<T> {
  final double minValue;
  const MeasurementTooLow(T failedValue, this.minValue) : super(failedValue);
}

class MeasurementTooHigh<T> extends ValueFailure<T> {
  final double maxValue;
  const MeasurementTooHigh(T failedValue, this.maxValue) : super(failedValue);
}
