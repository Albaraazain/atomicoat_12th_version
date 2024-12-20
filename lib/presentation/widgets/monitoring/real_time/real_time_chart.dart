// lib/presentation/widgets/monitoring/real_time/real_time_chart.dart
import 'package:experiment_planner/domain/entities/machine/parameter.dart';
import 'package:experiment_planner/domain/models/process/data_point.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RealTimeChart extends StatelessWidget {
  final List<DataPoint> data;
  final Parameter parameter;
  final bool showGrid;

  const RealTimeChart({
    Key? key,
    required this.data,
    required this.parameter,
    this.showGrid = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minY: parameter.minValue,
        maxY: parameter.maxValue,
        lineBarsData: [
          LineChartBarData(
            spots: _createSpots(),
            isCurved: true,
            color: _getLineColor(context),
            barWidth: 2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: _getLineColor(context).withOpacity(0.1),
            ),
          ),
          if (parameter.setPoint != null)
            LineChartBarData(
              spots: _createSetPointLine(),
              isCurved: false,
              color: Colors.grey.withOpacity(0.5),
              barWidth: 1,
              dotData: const FlDotData(show: false),
              dashArray: [5, 5],
            ),
        ],
        gridData: FlGridData(show: showGrid),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => Colors.black.withOpacity(0.8),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '${spot.y.toStringAsFixed(2)} ${parameter.unit}',
                  const TextStyle(color: Colors.white),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  List<FlSpot> _createSpots() {
    if (data.isEmpty) return [];

    final firstTimestamp = data.first.timestamp.millisecondsSinceEpoch.toDouble();
    final duration = data.last.timestamp.difference(data.first.timestamp);

    return data.map((point) {
      final x = (point.timestamp.millisecondsSinceEpoch - firstTimestamp) /
        duration.inMilliseconds;
      return FlSpot(x, point.value);
    }).toList();
  }

  List<FlSpot> _createSetPointLine() {
    if (parameter.setPoint == null) return [];

    return [
      FlSpot(0, parameter.setPoint!),
      FlSpot(1, parameter.setPoint!),
    ];
  }

  Color _getLineColor(BuildContext context) {
    if (data.isEmpty) return Colors.blue;

    final currentValue = data.last.value;
    if (currentValue > parameter.maxValue ||
        currentValue < parameter.minValue) {
      return Colors.red;
    }

    if (parameter.warningThresholds?.contains(currentValue) ?? false) {
      return Colors.orange;
    }

    return Colors.blue;
  }
}