import 'package:dartz/dartz.dart';
import 'package:experiment_planner/domain/core/value_failure.dart';
import 'package:experiment_planner/domain/core/value_object.dart';

class FilmThickness extends ValueObject<double> {
  @override
  final Either<ValueFailure<double>, double> value;

  factory FilmThickness(double input) {
    return FilmThickness._(
      validateThickness(input),
    );
  }

  const FilmThickness._(this.value);

  static Either<ValueFailure<double>, double> validateThickness(double input) {
    if (input <= 0) {
      return left(ValueFailure.invalidThickness(input));
    }
    return right(input);
  }

  double getOrCrash() => value.fold((f) => throw UnimplementedError(), id);
}

class FilmUniformity extends ValueObject<double> {
  @override
  final Either<ValueFailure<double>, double> value;

  factory FilmUniformity(double input) {
    return FilmUniformity._(
      validateUniformity(input),
    );
  }

  const FilmUniformity._(this.value);

  static Either<ValueFailure<double>, double> validateUniformity(double input) {
    if (input < 0 || input > 1) {
      return left(ValueFailure.invalidUniformity(input));
    }
    return right(input);
  }

  double getOrCrash() => value.fold((f) => throw UnimplementedError(), id);
}
