// lib/domain/usecases/machine/monitor_machine_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:experiment_planner/core/error/exceptions.dart';
import 'package:experiment_planner/domain/entities/machine/machine.dart';
import 'package:experiment_planner/domain/failures/failures.dart';
import 'package:experiment_planner/domain/repositories/machine_repository.dart';
import 'package:experiment_planner/domain/usecases/base_usecase.dart';

class MonitorMachineUseCase implements UseCase<Stream<Machine>, String> {
  final MachineRepository repository;

  MonitorMachineUseCase(this.repository);

  @override
  Future<Either<Failure, Stream<Machine>>> call(String machineId) async {
    final result = await repository.monitorMachine(machineId);

    return result.map((stream) => stream.map(
      (either) => either.fold(
        (failure) => throw MonitoringException(failure.message),
        (machine) => machine,
      ),
    ));
  }
}