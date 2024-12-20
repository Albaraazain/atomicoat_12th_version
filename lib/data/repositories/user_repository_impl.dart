// lib/domain/repositories/user_repository.dart
import 'package:dartz/dartz.dart';
import 'package:experiment_planner/domain/entities/user/user.dart';
import 'package:experiment_planner/domain/enums/user_enums.dart';
import 'package:experiment_planner/domain/failures/failures.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getUser(String id);
  Future<Either<Failure, List<User>>> getMachineUsers(String machineId);
  Future<Either<Failure, String>> registerUser(
    String email,
    String password,
    String machineSerial,
  );
  Future<Either<Failure, void>> approveUser(String userId);
  Future<Either<Failure, void>> updateUserRole(String userId, UserRole role);
  Future<Either<Failure, void>> deleteUser(String userId);
}

