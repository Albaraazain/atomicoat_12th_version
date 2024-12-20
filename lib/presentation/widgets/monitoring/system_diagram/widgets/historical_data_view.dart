// lib/presentation/widgets/monitoring/system_diagram/widgets/historical_data_view.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../../domain/entities/machine/parameter.dart';

class HistoricalDataView extends StatefulWidget {
  final List<Parameter> parameters;
  final Duration timeRange;

  const HistoricalDataView({
    Key? key,
    required this.parameters,
    this.timeRange = const Duration(hours: 1),
  }) : super(key: key);

  @override
  State<HistoricalDataView> createState() => _HistoricalDataViewState();
}

class _HistoricalDataViewState extends State<HistoricalDataView> {
  late ScrollController _scrollController;
  late List<bool> _selectedParameters;
  Duration _selectedTimeRange = const Duration(hours: 1);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _selectedParameters = List.generate(widget.parameters.length, (_) => true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTimeRangeSelector(),
        _buildParameterSelector(),
        Expanded(
          child: _buildGraph(),
        ),
      ],
    );
  }

  Widget _buildTimeRangeSelector() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SegmentedButton<Duration>(
        selected: {_selectedTimeRange},
        onSelectionChanged: (value) {
          setState(() {
            _selectedTimeRange = value.first;
          });
        },
        segments: const [
          ButtonSegment(
            value: Duration(hours: 1),
            label: Text('1h'),
          ),
          ButtonSegment(
            value: Duration(hours: 6),
            label: Text('6h'),
          ),
          ButtonSegment(
            value: Duration(hours: 24),
            label: Text('24h'),
          ),
          ButtonSegment(
            value: Duration(days: 7),
            label: Text('7d'),
          ),
        ],
      ),
    );
  }

  Widget _buildParameterSelector() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.parameters.length,
        itemBuilder: (context, index) {
          final parameter = widget.parameters[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              selected: _selectedParameters[index],
              label: Text(parameter.name),
              onSelected: (selected) {
                setState(() {
                  _selectedParameters[index] = selected;
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildGraph() {
    final selectedParameterData = _getSelectedParameterData();
    if (selectedParameterData.isEmpty) {
      return const Center(
        child: Text('No parameters selected'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          lineBarsData: _createLineBarsData(selectedParameterData),
          titlesData: _createTitlesData(),
          gridData: _createGridData(),
          borderData: _createBorderData(),
          lineTouchData: _createTouchData(selectedParameterData),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getSelectedParameterData() {
    final List<Map<String, dynamic>> result = [];

    for (var i = 0; i < widget.parameters.length; i++) {
      if (_selectedParameters[i]) {
        result.add({
          'parameter': widget.parameters[i],
          'color': _getParameterColor(i),
        });
      }
    }

    return result;
  }

  List<LineChartBarData> _createLineBarsData(
    List<Map<String, dynamic>> selectedData,
  ) {
    return selectedData.map((data) {
      final parameter = data['parameter'] as Parameter;
      final color = data['color'] as Color;

      final spots = parameter.historicalData
          .where((point) =>
              point.timestamp.isAfter(DateTime.now().subtract(_selectedTimeRange)))
          .map((point) => FlSpot(
                point.timestamp.millisecondsSinceEpoch.toDouble(),
                point.value,
              ))
          .toList();

      return LineChartBarData(
        spots: spots,
        isCurved: true,
        color: color,
        barWidth: 2,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: color.withOpacity(0.1),
        ),
      );
    }).toList();
  }

  FlTitlesData _createTitlesData() {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
            return SideTitleWidget(
              angle: 45,
              axisSide: meta.axisSide,
              child: Text(
                _formatDate(date),
                style: const TextStyle(fontSize: 10),
              ),
            );
          },
          interval: _getTimeInterval(),
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            return SideTitleWidget(
              axisSide: meta.axisSide,
              child: Text(
                value.toStringAsFixed(1),
                style: const TextStyle(fontSize: 10),
              ),
            );
          },
        ),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );
  }

  FlGridData _createGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: true,
      horizontalInterval: 1,
      verticalInterval: _getTimeInterval(),
    );
  }

  FlBorderData _createBorderData() {
    return FlBorderData(
      show: true,
      border: Border.all(color: Colors.white10),
    );
  }

  LineTouchData _createTouchData(List<Map<String, dynamic>> selectedData) {
    return LineTouchData(
      enabled: true,
      touchTooltipData: LineTouchTooltipData(
        tooltipBgColor: Colors.black.withOpacity(0.8),
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((spot) {
            final paramData = selectedData[spot.barIndex];
            final parameter = paramData['parameter'] as Parameter;
            return LineTooltipItem(
              '${parameter.name}: ${spot.y.toStringAsFixed(2)} ${parameter.unit}',
              TextStyle(
                color: paramData['color'] as Color,
                fontWeight: FontWeight.bold,
              ),
            );
          }).toList();
        },
      ),
    );
  }

  Color _getParameterColor(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.amber,
      Colors.indigo,
      Colors.pink,
      Colors.cyan,
    ];
    return colors[index % colors.length];
  }

  double _getTimeInterval() {
    if (_selectedTimeRange <= const Duration(hours: 1)) {
      return 300000; // 5 minutes
    } else if (_selectedTimeRange <= const Duration(hours: 6)) {
      return 1800000; // 30 minutes
    } else if (_selectedTimeRange <= const Duration(hours: 24)) {
      return 7200000; // 2 hours
    } else {
      return 86400000; // 1 day
    }
  }

  String _formatDate(DateTime date) {
    if (_selectedTimeRange <= const Duration(hours: 1)) {
      return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (_selectedTimeRange <= const Duration(hours: 24)) {
      return '${date.hour}:00';
    } else {
      return '${date.month}/${date.day}';
    }
  }
}