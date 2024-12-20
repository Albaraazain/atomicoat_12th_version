// lib/presentation/widgets/monitoring/system_monitoring_base.dart
import 'package:experiment_planner/presentation/bloc/machine/machine_bloc.dart';
import 'package:experiment_planner/presentation/bloc/machine/machine_event.dart';
import 'package:experiment_planner/presentation/bloc/machine/machine_state.dart';
import 'package:experiment_planner/presentation/widgets/monitoring/error_display.dart';
import 'package:experiment_planner/presentation/widgets/monitoring/system_controls_overlay.dart';
import 'package:experiment_planner/presentation/widgets/monitoring/system_status_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SystemMonitoringBase extends StatelessWidget {
  final Widget child;
  final bool showControls;

  const SystemMonitoringBase({
    Key? key,
    required this.child,
    this.showControls = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MachineBloc, MachineState>(
      builder: (context, state) {
        return Stack(
          children: [
            // Main content
            child,

            // Status Overlay
            if (state is MachineMonitoring)
              Positioned(
                top: 16,
                right: 16,
                child: SystemStatusOverlay(
                  machine: state.machine,
                  alerts: state.activeAlerts,
                ),
              ),

            // Controls Overlay
            if (showControls)
              Positioned(
                bottom: 16,
                left: 16,
                child: SystemControlsOverlay(
                  isUpdating: state is MachineMonitoring
                    ? state.isUpdatingParameter
                    : false,
                ),
              ),

            // Loading Indicator
            if (state is MachineLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),

            // Error Display
            if (state is MachineError)
              Center(
                child: ErrorDisplay(
                  message: state.message,
                  onRetry: () => context.read<MachineBloc>().add(
                    StartMachineMonitoring(
                      context.read<MachineBloc>().currentMachineId!,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

