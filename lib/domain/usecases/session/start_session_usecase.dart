// lib/domain/usecases/session/start_session_usecase.dart
class StartSessionUseCase implements UseCase<String, StartSessionParams> {
  final SessionRepository repository;
  final MachineRepository machineRepository;

  StartSessionUseCase(this.repository, this.machineRepository);

  @override
  Future<Either<Failure, String>> call(StartSessionParams params) async {
    // Validate machine state before starting session
    final machineResult = await machineRepository.getMachine(params.machineId);

    return machineResult.fold(
      (failure) => Left(failure),
      (machine) {
        if (machine.status != MachineStatus.idle) {
          return Left(ValidationFailure(
            message: 'Machine must be in idle state to start session',
          ));
        }

        final session = Session(
          id: '',  // Will be assigned by repository
          userId: params.userId,
          machineId: params.machineId,
          recipeId: params.recipeId,
          status: SessionStatus.starting,
          startTime: DateTime.now(),
          description: params.description,
          logs: [],
          readings: [],
        );

        return repository.startSession(session);
      },
    );
  }
}
