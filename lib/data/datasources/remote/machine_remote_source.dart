// lib/data/datasources/remote/machine_remote_source.dart
import 'package:dio/dio.dart';
import 'package:experiment_planner/core/error/exceptions.dart';
import 'package:experiment_planner/core/network/network_client.dart';
import 'package:experiment_planner/core/network/websocket_client.dart';
import 'package:experiment_planner/data/models/machine/machine_dto.dart';

abstract class MachineRemoteDataSource {
  Future<MachineDTO> getMachine(String id);
  Future<List<MachineDTO>> getMachinesByAdmin(String adminId);
  Future<void> updateMachineStatus(String id, String status);
  Future<void> updateComponentParameter(
    String machineId,
    String componentId,
    String parameterId,
    double value,
  );
  Stream<MachineDTO> monitorMachine(String id);
}

class MachineRemoteDataSourceImpl implements MachineRemoteDataSource {
  final NetworkClient _client;
  final WebSocketClient _wsClient;

  MachineRemoteDataSourceImpl({
    required NetworkClient client,
    required WebSocketClient wsClient,
  })  : _client = client,
        _wsClient = wsClient;

  @override
  Future<MachineDTO> getMachine(String id) async {
    try {
      final response = await _client.get('/machines/$id');
      return MachineDTO.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Stream<MachineDTO> monitorMachine(String id) {
    return _wsClient
        .connect('machines/$id/monitor')
        .map((data) => MachineDTO.fromJson(data));
  }

  @override
  Future<List<MachineDTO>> getMachinesByAdmin(String adminId) {
    // TODO: implement getMachinesByAdmin
    throw UnimplementedError();
  }

  @override
  Future<void> updateComponentParameter(String machineId, String componentId, String parameterId, double value) {
    // TODO: implement updateComponentParameter
    throw UnimplementedError();
  }

  @override
  Future<void> updateMachineStatus(String id, String status) {
    // TODO: implement updateMachineStatus
    throw UnimplementedError();
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return NetworkException(
          message: 'Connection timeout',
          code: 'TIMEOUT',
          stackTrace: error.stackTrace,
        );
      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'No internet connection',
          code: 'NO_CONNECTION',
          stackTrace: error.stackTrace,
        );
      case DioExceptionType.badResponse:
        return NetworkException(
          message: 'Server error: ${error.response?.statusMessage}',
          code: error.response?.statusCode?.toString() ?? 'UNKNOWN',
          stackTrace: error.stackTrace,
        );
      default:
        return NetworkException(
          message: error.message ?? 'Unknown network error',
          code: 'UNKNOWN',
          stackTrace: error.stackTrace,
        );
    }
  }
}
