import 'package:experiment_planner/presentation/bloc/machine/machine_event.dart';
import 'package:flutter/material.dart';
import 'package:experiment_planner/presentation/bloc/machine/machine_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SystemControlsOverlay extends StatelessWidget {
  final bool isUpdating;

  const SystemControlsOverlay({
    Key? key,
    required this.isUpdating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isUpdating)
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.stop, color: Colors.white),
                onPressed: () => context.read<MachineBloc>().add(
                  StopMachineMonitoring(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: isUpdating
                    ? null
                    : () => context.read<MachineBloc>().add(
                          StartMachineMonitoring(
                            context.read<MachineBloc>().currentMachineId!,
                          ),
                        ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
