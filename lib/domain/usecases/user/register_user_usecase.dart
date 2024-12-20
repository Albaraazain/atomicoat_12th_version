// lib/domain/usecases/user/register_user_usecase.dart
class RegisterUserUseCase implements UseCase<String, RegisterUserParams> {
  final UserRepository repository;

  RegisterUserUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(RegisterUserParams params) {
    return repository.registerUser(
      params.email,
      params.password,
      params.machineSerial,
    );
  }
}

