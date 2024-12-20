// lib/presentation/widgets/monitoring/system_diagram/overlays/graph_overlay.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../domain/entities/machine/component.dart';
import '../../../../../domain/entities/machine/parameter.dart';
import '../../../../blocs/machine/machine_bloc.dart';

class GraphOverlay extends StatelessWidget {
  final Map<String, List<String>> primaryParameters = {
    'Nitrogen Generator': ['flow_rate'],
    'MFC': ['flow_rate'],
    'Backline Heater': ['temperature'],
    'Frontline Heater': ['temperature'],
    'Precursor Heater 1': ['temperature'],
    'Precursor Heater 2': ['temperature'],
    'Reaction Chamber': ['pressure', 'temperature'],
    'Pressure Control System': ['pressure'],
    'Vacuum Pump': ['power'],
  };

  final Map<String, Color> componentColors = {
    'Nitrogen Generator': Colors.blue,
    'MFC': Colors.green,
    'Backline Heater': Colors.orange,
    'Frontline Heater': Colors.purple,
    'Precursor Heater 1': Colors.teal,
    'Precursor Heater 2': Colors.indigo,
    'Reaction Chamber': Colors.red,
    'Pressure Control System': Colors.cyan,
    'Vacuum Pump': Colors.amber,
  };

  GraphOverlay({Key? key}) : super(key: key);

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
                final parameters = primaryParameters[component.name];
                if (parameters == null) return const SizedBox.shrink();

                return _buildGraphCard(
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

  Widget _buildGraphCard(
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
      child: RealTimeGraphCard(
        component: component,
        parameterKeys: parameterKeys,
        color: componentColors[component.name] ?? Colors.white,
      ),
    );
  }

  Offset? _getComponentPosition(String componentName) {
    // Similar positions as ParameterOverlay but slightly offset
    final basePositions = {
      'Nitrogen Generator': const Offset(0.14, 0.84),
      'MFC': const Offset(0.24, 0.74),
      'Backline Heater': const Offset(0.39, 0.64),
      'Frontline Heater': const Offset(0.54, 0.54),
      'Precursor Heater 1': const Offset(0.69, 0.44),
      'Precursor Heater 2': const Offset(0.84, 0.34),
      'Reaction Chamber': const Offset(0.54, 0.24),
      'Pressure Control System': const Offset(0.79, 0.79),
      'Vacuum Pump': const Offset(0.89, 0.89),
    };
    return basePositions[componentName];
  }
}

class RealTimeGraphCard extends StatelessWidget {
  final Component component;
  final List<String> parameterKeys;
  final Color color;
  final int maxDataPoints = 50; // Number of points to show on graph

  const RealTimeGraphCard({
    Key? key,
    required this.component,
    required this.parameterKeys,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 150,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            component.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: parameterKeys.length == 1
                ? _buildSingleParameterGraph(component.parameters
                    .firstWhere((p) => p.name == parameterKeys.first))
                : _buildMultiParameterGraph(),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleParameterGraph(Parameter parameter) {
    // Get historical data
    final dataPoints = parameter.historicalData
        .take(maxDataPoints)
        .toList()
        .reversed
        .toList();

    if (dataPoints.isEmpty) {
      return const Center(
        child: Text(
          'No data available',
          style: TextStyle(color: Colors.white60),
        ),
      );
    }

    // Create fl_chart data
    final spots = dataPoints
        .asMap()
        .entries
        .map((entry) => FlSpot(
              entry.key.toDouble(),
              entry.value.value,
            ))
        .toList();

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (maxDataPoints - 1).toDouble(),
        minY: parameter.minValue,
        maxY: parameter.maxValue,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: color,
            barWidth: 2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: color.withOpacity(0.1),
            ),
          ),
          if (parameter.setPoint != null)
            LineChartBarData(
              spots: [
                FlSpot(0, parameter.setPoint!),
                FlSpot((maxDataPoints - 1).toDouble(), parameter.setPoint!),
              ],
              isCurved: false,
              color: Colors.white30,
              barWidth: 1,
              dotData: const FlDotData(show: false),
              dashArray: [5, 5],
            ),
        ],
      ),
    );
  }

  Widget _buildMultiParameterGraph() {
    // Implementation for multiple parameters...
    // Similar to single parameter but with multiple LineChartBarData
    return const Center(
      child: Text(
        'Multiple parameters graph',
        style: TextStyle(color: Colors.white60),
      ),
    );
  }
}