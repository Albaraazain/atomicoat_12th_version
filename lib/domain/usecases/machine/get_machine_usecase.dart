import 'package:dartz/dartz.dart';
import 'package:experiment_planner/domain/entities/machine/machine.dart';
import 'package:experiment_planner/domain/failures/failures.dart';
import 'package:experiment_planner/domain/repositories/machine_repository.dart';
import 'package:experiment_planner/domain/usecases/base_usecase.dart';

class GetMachineUseCase implements UseCase<Machine, String> {
  final MachineRepository repository;

  GetMachineUseCase(this.repository);

  @override
  Future<Either<Failure, Machine>> call(String machineId) async {
    return await repository.getMachine(machineId);
  }
}
