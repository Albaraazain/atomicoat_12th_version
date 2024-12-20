import 'dart:async';
import 'package:experiment_planner/domain/entities/machine/machine.dart';
import 'package:experiment_planner/domain/usecases/params/machine_params.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:experiment_planner/domain/usecases/machine/get_machine_usecase.dart';
import 'package:experiment_planner/domain/usecases/machine/monitor_machine_usecase.dart';
import 'package:experiment_planner/domain/usecases/machine/update_parameter_usecase.dart';
import 'machine_event.dart';
import 'machine_state.dart';

class MachineBloc extends Bloc<MachineEvent, MachineState> {
  final GetMachineUseCase getMachine;
  final MonitorMachineUseCase monitorMachine;
  final UpdateParameterUseCase updateParameter;
  StreamSubscription<Machine>? _machineSubscription;

  // Add this getter
  String? get currentMachineId =>
    state is MachineMonitoring ? (state as MachineMonitoring).machine.id : null;

  MachineBloc({
    required this.getMachine,
    required this.monitorMachine,
    required this.updateParameter,
  }) : super(MachineInitial()) {
    on<StartMachineMonitoring>(_onStartMonitoring);
    on<StopMachineMonitoring>(_onStopMonitoring);
    on<UpdateParameter>(_onUpdateParameter);
    on<UpdateMachineState>(_onUpdateMachineState);
    on<MonitoringError>(_onMonitoringError);
  }

  Future<void> _onStartMonitoring(
    StartMachineMonitoring event,
    Emitter<MachineState> emit,
  ) async {
    emit(MachineLoading());

    final result = await monitorMachine(event.machineId);

    await result.fold(
      (failure) async {
        emit(MachineError(failure.message));
      },
      (stream) async {
        await _machineSubscription?.cancel();
        _machineSubscription = stream.listen(
          (machine) => add(UpdateMachineState(machine)),
          onError: (error) => add(MonitoringError(error.toString())),
        );
      },
    );
  }

  Future<void> _onStopMonitoring(
    StopMachineMonitoring event,
    Emitter<MachineState> emit,
  ) async {
    await _machineSubscription?.cancel();
    _machineSubscription = null;
    emit(MachineInitial());
  }

  Future<void> _onUpdateParameter(
    UpdateParameter event,
    Emitter<MachineState> emit,
  ) async {
    if (state is MachineMonitoring) {
      final currentState = state as MachineMonitoring;
      emit(currentState.copyWith(isUpdatingParameter: true));

      final result = await updateParameter(UpdateParameterParams(
        machineId: currentState.machine.id,
        componentId: event.componentId,
        parameterId: event.parameterId,
        value: event.value,
      ));

      result.fold(
        (failure) => emit(MachineError(failure.message)),
        (_) => emit(currentState.copyWith(isUpdatingParameter: false)),
      );
    }
  }

  void _onUpdateMachineState(
    UpdateMachineState event,
    Emitter<MachineState> emit,
  ) {
    if (state is MachineMonitoring) {
      emit((state as MachineMonitoring).copyWith(machine: event.machine));
    } else {
      emit(MachineMonitoring(
        machine: event.machine,
        activeAlerts: [],
      ));
    }
  }

  void _onMonitoringError(
    MonitoringError event,
    Emitter<MachineState> emit,
  ) {
    emit(MachineError(event.error));
  }

  @override
  Future<void> close() {
    _machineSubscription?.cancel();
    return super.close();
  }
}