// lib/domain/usecases/machine/update_parameter_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:experiment_planner/domain/failures/failures.dart';
import 'package:experiment_planner/domain/repositories/machine_repository.dart';
import 'package:experiment_planner/domain/usecases/base_usecase.dart';
import 'package:experiment_planner/domain/usecases/params/machine_params.dart';

class UpdateParameterUseCase implements UseCase<void, UpdateParameterParams> {
  final MachineRepository repository;

  UpdateParameterUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateParameterParams params) {
    return repository.updateParameter(params);
  }
}
