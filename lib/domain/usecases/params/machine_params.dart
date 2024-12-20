// lib/domain/usecases/params/machine_params.dart
import 'package:equatable/equatable.dart';

class UpdateParameterParams extends Equatable {
  final String machineId;
  final String componentId;
  final String parameterId;
  final double value;

  const UpdateParameterParams({
    required this.machineId,
    required this.componentId,
    required this.parameterId,
    required this.value,
  });

  @override
  List<Object> get props => [machineId, componentId, parameterId, value];
}
