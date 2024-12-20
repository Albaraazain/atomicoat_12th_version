import 'package:dartz/dartz.dart';
import 'package:experiment_planner/domain/core/value_failure.dart';
import 'package:experiment_planner/domain/core/value_object.dart';

class MeasurementValue extends ValueObject<double> {
  @override
  final Either<ValueFailure<double>, double> value;

  factory MeasurementValue(double input, {double? min, double? max}) {
    return MeasurementValue._(
      validateMeasurement(input, min: min, max: max),
    );
  }

  const MeasurementValue._(this.value);

  static Either<ValueFailure<double>, double> validateMeasurement(
    double input, {
    double? min,
    double? max,
  }) {
    if (min != null && input < min) {
      return left(ValueFailure.measurementTooLow(input, min));
    }
    if (max != null && input > max) {
      return left(ValueFailure.measurementTooHigh(input, max));
    }
    return right(input);
  }
}
