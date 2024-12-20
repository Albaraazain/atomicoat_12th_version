// lib/presentation/widgets/monitoring/system_diagram/overlays/component_overlay.dart
import 'package:experiment_planner/presentation/bloc/machine/machine_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../domain/entities/machine/component.dart';

class ComponentOverlay extends StatelessWidget {
  final Map<String, Offset> componentPositions = {
    'Nitrogen Generator': const Offset(0.1, 0.8),
    'MFC': const Offset(0.2, 0.7),
    'Backline Heater': const Offset(0.35, 0.6),
    'Frontline Heater': const Offset(0.5, 0.5),
    'Precursor Heater 1': const Offset(0.65, 0.4),
    'Precursor Heater 2': const Offset(0.8, 0.3),
    'Reaction Chamber': const Offset(0.5, 0.2),
    'Pressure Control System': const Offset(0.75, 0.75),
    'Vacuum Pump': const Offset(0.85, 0.85),
  };

  ComponentOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MachineBloc, MachineState>(
      builder: (context, state) {
        if (state is! MachineMonitoring) {
          return const SizedBox.shrink();
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: state.machine.components.map((component) {
                final position = componentPositions[component.name];
                if (position == null) return const SizedBox.shrink();

                return Positioned(
                  left: position.dx * constraints.maxWidth,
                  top: position.dy * constraints.maxHeight,
                  child: ComponentStatusCard(
                    component: component,
                    onTap: () => _showComponentDetails(context, component),
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }

  void _showComponentDetails(BuildContext context, Component component) {
    showDialog(
      context: context,
      builder: (context) => ComponentDetailsDialog(component: component),
    );
  }
}

class ComponentStatusCard extends StatelessWidget {
  final Component component;
  final VoidCallback onTap;

  const ComponentStatusCard({
    Key? key,
    required this.component,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _getStatusColor(component.status),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              component.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getStatusIcon(component.status),
                  color: _getStatusColor(component.status),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  component.status.toString().split('.').last,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(ComponentStatus status) {
    switch (status) {
      case ComponentStatus.active:
        return Colors.green;
      case ComponentStatus.inactive:
        return Colors.grey;
      case ComponentStatus.error:
        return Colors.red;
      case ComponentStatus.warning:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(ComponentStatus status) {
    switch (status) {
      case ComponentStatus.active:
        return Icons.check_circle;
      case ComponentStatus.inactive:
        return Icons.radio_button_unchecked;
      case ComponentStatus.error:
        return Icons.error;
      case ComponentStatus.warning:
        return Icons.warning;
      default:
        return Icons.help;
    }
  }
}