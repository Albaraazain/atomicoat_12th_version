// lib/data/repositories/machine_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:experiment_planner/core/error/exceptions.dart';
import 'package:experiment_planner/core/network/network_info.dart';
import 'package:experiment_planner/data/datasources/local/machine_local_source.dart';
import 'package:experiment_planner/data/datasources/remote/machine_remote_source.dart';
import 'package:experiment_planner/domain/entities/machine/component.dart';
import 'package:experiment_planner/domain/entities/machine/machine.dart';
import 'package:experiment_planner/domain/enums/component_enums.dart';
import 'package:experiment_planner/domain/failures/failures.dart';
import 'package:experiment_planner/domain/interfaces/datasources/i_machine_datasource.dart';
import 'package:experiment_planner/domain/interfaces/repositories/i_machine_repository.dart';
import 'package:experiment_planner/domain/models/monitoring/system_health.dart';
import 'package:experiment_planner/domain/usecases/params/machine_params.dart';

class MachineRepositoryImpl implements IMachineRepository {
  final MachineRemoteDataSource _remoteSource;
  final MachineLocalDataSource _localSource;
  final NetworkInfo _networkInfo;

  MachineRepositoryImpl({
    required MachineRemoteDataSource remoteSource,
    required MachineLocalDataSource localSource,
    required NetworkInfo networkInfo,
  })  : _remoteSource = remoteSource,
        _localSource = localSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, Machine>> getMachine(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final remoteData = await _remoteSource.getMachine(id);
        await _localSource.cacheMachine(remoteData);
        return Right(remoteData.toDomain());
      } on Exception catch (e) {
        return Left(_handleException(e));
      }
    } else {
      try {
        final localData = await _localSource.getCachedMachine(id);
        if (localData != null) {
          return Right(localData.toDomain());
        } else {
          return Left(const CacheFailure(message: 'No cached data available'));
        }
      } on Exception catch (e) {
        return Left(_handleException(e));
      }
    }
  }

  @override
  Future<Either<Failure, Stream<Either<Failure, Machine>>>> monitorMachine(String id) async {
    if (!await _networkInfo.isConnected) {
      return Left(const NetworkFailure(message: 'No internet connection'));
    }

    try {
      final stream = _remoteSource.monitorMachine(id).map(
        (machineDTO) => Right<Failure, Machine>(machineDTO.toDomain()),
      ).handleError(
        (error) => Left<Failure, Machine>(_handleException(error)),
      );
      return Right(stream);
    } on Exception catch (e) {
      return Left(_handleException(e));
    }
  }

  Failure _handleException(Exception exception) {
    if (exception is NetworkException) {
      return NetworkFailure(message: exception.message);
    }
    if (exception is CacheException) {
      return CacheFailure(message: exception.message);
    }
    return UnexpectedFailure(
      message: 'An unexpected error occurred: ${exception.toString()}',
    );
  }

  @override
  Future<Either<Failure, List<Machine>>> getMachinesByAdmin(String adminId) {
    // TODO: implement getMachinesByAdmin
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updateComponentHealth(String machineId, String componentId, status) {
    // TODO: implement updateComponentHealth
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updateComponentParameter(String machineId, String componentId, String parameterId, double value) {
    // TODO: implement updateComponentParameter
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updateMachineStatus(String id, status) {
    // TODO: implement updateMachineStatus
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updateParameter(UpdateParameterParams params) {
    // TODO: implement updateParameter
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Machine>>> getAllMachines() {
    // TODO: implement getAllMachines
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, CalibrationStatus>> getCalibrationStatus(String machineId) {
    // TODO: implement getCalibrationStatus
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Component>> getComponent(String machineId, String componentId) {
    // TODO: implement getComponent
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, SystemHealth>> getMachineHealth(String machineId) {
    // TODO: implement getMachineHealth
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<MaintenanceRecord>>> getMaintenanceHistory(String machineId, {DateTime? startDate, DateTime? endDate}) {
    // TODO: implement getMaintenanceHistory
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, OperationalStats>> getOperationalStats(String machineId, {DateTime? startDate, DateTime? endDate}) {
    // TODO: implement getOperationalStats
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<ParameterHistory>>> getParameterHistory(String machineId, String componentId, String parameterId, {DateTime? startTime, DateTime? endTime}) {
    // TODO: implement getParameterHistory
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> initiateCalibration(String machineId, CalibrationConfig config) {
    // TODO: implement initiateCalibration
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> recordMaintenanceEvent(String machineId, MaintenanceEvent event) {
    // TODO: implement recordMaintenanceEvent
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, DiagnosticResult>> runDiagnostics(String machineId, {List<String>? specificComponents}) {
    // TODO: implement runDiagnostics
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updateComponentStatus(String machineId, String componentId, ComponentStatus status) {
    // TODO: implement updateComponentStatus
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updateMachineConfig(String machineId, MachineConfig config) {
    // TODO: implement updateMachineConfig
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, ValidationResult>> validateMachineConfig(String machineId, MachineConfig config) {
    // TODO: implement validateMachineConfig
    throw UnimplementedError();
  }

  @override
  Stream<Either<Failure, Component>> watchComponent(String machineId, String componentId) {
    // TODO: implement watchComponent
    throw UnimplementedError();
  }

  @override
  Stream<Either<Failure, Machine>> watchMachine(String machineId) {
    // TODO: implement watchMachine
    throw UnimplementedError();
  }

  @override
  Stream<Either<Failure, ParameterUpdate>> watchParameter(String machineId, String componentId, String parameterId) {
    // TODO: implement watchParameter
    throw UnimplementedError();
  }
}