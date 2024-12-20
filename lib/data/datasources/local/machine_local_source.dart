// lib/data/datasources/local/machine_local_source.dart
import 'package:experiment_planner/data/models/machine/machine_dto.dart';
import 'package:hive/hive.dart';

abstract class MachineLocalDataSource {
  Future<MachineDTO?> getCachedMachine(String id);
  Future<void> cacheMachine(MachineDTO machine);
  Future<void> clearCache();
}

class MachineLocalDataSourceImpl implements MachineLocalDataSource {
  final Box<Map<String, dynamic>> _machineBox;

  MachineLocalDataSourceImpl(this._machineBox);

  @override
  Future<MachineDTO?> getCachedMachine(String id) async {
    final data = _machineBox.get(id);
    if (data != null) {
      return MachineDTO.fromJson(data);
    }
    return null;
  }

  @override
  Future<void> cacheMachine(MachineDTO machine) async {
    await _machineBox.put(machine.id, machine.toJson());
  }

  @override
  Future<void> clearCache() async {
    await _machineBox.clear();
  }
}

