// lib/presentation/widgets/monitoring/system_diagram/overlays/parameter_overlay.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../domain/entities/machine/component.dart';
import '../../../../../domain/entities/machine/parameter.dart';
import '../../../../blocs/machine/machine_bloc.dart';

class ParameterOverlay extends StatelessWidget {
  final Map<String, List<String>> componentParameters = {
    'Nitrogen Generator': ['flow_rate', 'pressure'],
    'MFC': ['flow_rate', 'setpoint'],
    'Backline Heater': ['temperature', 'power', 'setpoint'],
    'Frontline Heater': ['temperature', 'power', 'setpoint'],
    'Precursor Heater 1': ['temperature', 'power', 'setpoint'],
    'Precursor Heater 2': ['temperature', 'power', 'setpoint'],
    'Reaction Chamber': ['pressure', 'temperature'],
    'Pressure Control System': ['pressure', 'valve_position'],
    'Vacuum Pump': ['power', 'speed', 'temperature'],
  };

  ParameterOverlay({Key? key}) : super(key: key);

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
                final parameters = componentParameters[component.name];
                if (parameters == null) return const SizedBox.shrink();

                return _buildParameterCard(
                  context,
                  component,
                  parameters,
                  constraints,
                );
              }).toList(),
            );
          },
        );
      },
    );
  }

  Widget _buildParameterCard(
    BuildContext context,
    Component component,
    List<String> parameterKeys,
    BoxConstraints constraints,
  ) {
    final position = _getComponentPosition(component.name);
    if (position == null) return const SizedBox.shrink();

    return Positioned(
      left: position.dx * constraints.maxWidth,
      top: position.dy * constraints.maxHeight,
      child: ParameterCard(
        component: component,
        parameterKeys: parameterKeys,
      ),
    );
  }

  Offset? _getComponentPosition(String componentName) {
    // Same positions as in ComponentOverlay, but slightly offset to prevent overlap
    final basePositions = {
      'Nitrogen Generator': const Offset(0.12, 0.82),
      'MFC': const Offset(0.22, 0.72),
      'Backline Heater': const Offset(0.37, 0.62),
      'Frontline Heater': const Offset(0.52, 0.52),
      'Precursor Heater 1': const Offset(0.67, 0.42),
      'Precursor Heater 2': const Offset(0.82, 0.32),
      'Reaction Chamber': const Offset(0.52, 0.22),
      'Pressure Control System': const Offset(0.77, 0.77),
      'Vacuum Pump': const Offset(0.87, 0.87),
    };
    return basePositions[componentName];
  }
}

class ParameterCard extends StatelessWidget {
  final Component component;
  final List<String> parameterKeys;

  const ParameterCard({
    Key? key,
    required this.component,
    required this.parameterKeys,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          ...parameterKeys.map((key) => _buildParameterRow(
                component.parameters.firstWhere((p) => p.name == key),
              )),
        ],
      ),
    );
  }

  Widget _buildParameterRow(Parameter parameter) {
    final isInRange = parameter.isInRange();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isInRange ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            parameter.name,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${parameter.currentValue.toStringAsFixed(1)} ${parameter.unit}',
            style: TextStyle(
              color: isInRange ? Colors.white : Colors.red,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}