// lib/presentation/widgets/monitoring/system_diagram/widgets/parameter_list_tile.dart
import 'dart:ui';

import 'package:flutter/material.dart';

class ParameterListTile extends StatelessWidget {
  final Parameter parameter;
  final Function(double) onAdjust;

  const ParameterListTile({
    Key? key,
    required this.parameter,
    required this.onAdjust,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isInRange = parameter.isInRange();
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ExpansionTile(
        title: Row(
          children: [
            Icon(
              isInRange ? Icons.check_circle : Icons.warning,
              color: isInRange ? Colors.green : Colors.orange,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    parameter.name,
                    style: theme.textTheme.titleMedium,
                  ),
                  Text(
                    '${parameter.currentValue.toStringAsFixed(2)} ${parameter.unit}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            if (parameter.isAdjustable)
              IconButton(
                icon: const Icon(Icons.tune),
                onPressed: () => _showAdjustmentDialog(context),
                tooltip: 'Adjust Parameter',
              ),
          ],
        ),
        children: [
          _buildDetailedView(context),
        ],
      ),
    );
  }

  Widget _buildDetailedView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRangeIndicator(),
          const SizedBox(height: 16),
          _buildTrendIndicator(),
          if (parameter.isAdjustable) ...[
            const SizedBox(height: 16),
            _buildQuickAdjustments(),
          ],
        ],
      ),
    );
  }

  Widget _buildRangeIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Operating Range:'),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: CustomPaint(
            size: const Size.fromHeight(40),
            painter: RangeIndicatorPainter(
              minValue: parameter.minValue,
              maxValue: parameter.maxValue,
              currentValue: parameter.currentValue,
              warningThreshold: parameter.warningThreshold,
              criticalThreshold: parameter.criticalThreshold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrendIndicator() {
    final trend = _calculateTrend();

    return Row(
      children: [
        const Text('Trend:'),
        const SizedBox(width: 8),
        Icon(
          trend > 0
              ? Icons.trending_up
              : trend < 0
                  ? Icons.trending_down
                  : Icons.trending_flat,
          color: _getTrendColor(trend),
        ),
        const SizedBox(width: 8),
        Text(_getTrendDescription(trend)),
      ],
    );
  }

  Widget _buildQuickAdjustments() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildQuickAdjustButton(
          icon: Icons.remove,
          value: -1,
          tooltip: 'Decrease by 1',
        ),
        _buildQuickAdjustButton(
          icon: Icons.remove,
          value: -0.1,
          tooltip: 'Fine decrease',
        ),
        _buildQuickAdjustButton(
          icon: Icons.add,
          value: 0.1,
          tooltip: 'Fine increase',
        ),
        _buildQuickAdjustButton(
          icon: Icons.add,
          value: 1,
          tooltip: 'Increase by 1',
        ),
      ],
    );
  }

  Widget _buildQuickAdjustButton({
    required IconData icon,
    required double value,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: ElevatedButton(
        onPressed: () {
          final newValue = parameter.currentValue + value;
          if (newValue >= parameter.minValue &&
              newValue <= parameter.maxValue) {
            onAdjust(newValue);
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(8),
          minimumSize: const Size(40, 40),
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }

  void _showAdjustmentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ParameterAdjustmentDialog(
        parameter: parameter,
        onAdjust: onAdjust,
      ),
    );
  }

  double _calculateTrend() {
    if (parameter.historicalData.length < 2) return 0;

    final recentValues = parameter.historicalData
        .take(10)
        .map((data) => data.value)
        .toList();

    double sum = 0;
    for (int i = 1; i < recentValues.length; i++) {
      sum += recentValues[i] - recentValues[i - 1];
    }
    return sum / (recentValues.length - 1);
  }

  Color _getTrendColor(double trend) {
    if (trend.abs() < 0.1) return Colors.grey;
    if (trend > 0) return Colors.green;
    return Colors.red;
  }

  String _getTrendDescription(double trend) {
    if (trend.abs() < 0.1) return 'Stable';
    if (trend > 0) return 'Increasing';
    return 'Decreasing';
  }
}

// Custom painter for the range indicator
class RangeIndicatorPainter extends CustomPainter {
  final double minValue;
  final double maxValue;
  final double currentValue;
  final double warningThreshold;
  final double criticalThreshold;

  RangeIndicatorPainter({
    required this.minValue,
    required this.maxValue,
    required this.currentValue,
    required this.warningThreshold,
    required this.criticalThreshold,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final double range = maxValue - minValue;
    final double normalizedCurrent = (currentValue - minValue) / range;

    // Draw background track
    paint.color = Colors.grey.withOpacity(0.3);
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );

    // Draw warning zones
    _drawWarningZones(canvas, size, range);

    // Draw current value indicator
    paint.color = _getValueColor(currentValue);
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(normalizedCurrent * size.width, size.height / 2),
      8,
      paint,
    );
  }

  void _drawWarningZones(Canvas canvas, Size size, double range) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    // Warning zone
    paint.color = Colors.orange.withOpacity(0.5);
    final warningStart = (warningThreshold - minValue) / range * size.width;
    canvas.drawLine(
      Offset(warningStart, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );

    // Critical zone
    paint.color = Colors.red.withOpacity(0.5);
    final criticalStart = (criticalThreshold - minValue) / range * size.width;
    canvas.drawLine(
      Offset(criticalStart, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
  }

  Color _getValueColor(double value) {
    if (value >= criticalThreshold) return Colors.red;
    if (value >= warningThreshold) return Colors.orange;
    return Colors.green;
  }

  @override
  bool shouldRepaint(RangeIndicatorPainter oldDelegate) =>
      oldDelegate.currentValue != currentValue;
}