// lib/presentation/widgets/monitoring/analysis/parameter_analysis_view.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stats/stats.dart';
import '../../../../domain/entities/machine/parameter.dart';

class ParameterAnalysisView extends StatefulWidget {
  final Parameter parameter;
  final List<DataPoint> historicalData;
  final Duration analysisTimeFrame;

  const ParameterAnalysisView({
    Key? key,
    required this.parameter,
    required this.historicalData,
    this.analysisTimeFrame = const Duration(hours: 24),
  }) : super(key: key);

  @override
  State<ParameterAnalysisView> createState() => _ParameterAnalysisViewState();
}

class _ParameterAnalysisViewState extends State<ParameterAnalysisView> {
  late List<DataPoint> filteredData;
  late Stats stats;

  @override
  void initState() {
    super.initState();
    _updateAnalysis();
  }

  void _updateAnalysis() {
    final cutoffTime = DateTime.now().subtract(widget.analysisTimeFrame);
    filteredData = widget.historicalData
        .where((point) => point.timestamp.isAfter(cutoffTime))
        .toList();

    final values = filteredData.map((point) => point.value).toList();
    stats = Stats.fromData(values);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildStatisticsPanel(),
            const SizedBox(height: 16),
            _buildDistributionChart(),
            const SizedBox(height: 16),
            _buildTrendAnalysis(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.parameter.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'Statistical Analysis',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        _buildTimeFrameSelector(),
      ],
    );
  }

  Widget _buildTimeFrameSelector() {
    return DropdownButton<Duration>(
      value: widget.analysisTimeFrame,
      items: [
        DropdownMenuItem(
          value: const Duration(hours: 1),
          child: const Text('Last Hour'),
        ),
        DropdownMenuItem(
          value: const Duration(hours: 24),
          child: const Text('Last 24 Hours'),
        ),
        DropdownMenuItem(
          value: const Duration(days: 7),
          child: const Text('Last Week'),
        ),
        DropdownMenuItem(
          value: const Duration(days: 30),
          child: const Text('Last Month'),
        ),
      ],
      onChanged: (value) {
        if (value != null) {
          setState(() {
            widget.analysisTimeFrame = value;
            _updateAnalysis();
          });
        }
      },
    );
  }

  Widget _buildStatisticsPanel() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      childAspectRatio: 2,
      children: [
        _buildStatCard('Mean', stats.mean.toStringAsFixed(2)),
        _buildStatCard('Median', stats.median.toStringAsFixed(2)),
        _buildStatCard('Mode', stats.mode.toStringAsFixed(2)),
        _buildStatCard('Std Dev', stats.standardDeviation.toStringAsFixed(2)),
        _buildStatCard('Min', stats.min.toStringAsFixed(2)),
        _buildStatCard('Max', stats.max.toStringAsFixed(2)),
      ],
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionChart() {
    // Create histogram data
    final histogramData = _createHistogramData();

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          barGroups: histogramData,
          borderData: FlBorderData(show: true),
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
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
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _createHistogramData() {
    // Create 10 bins for histogram
    final min = stats.min;
    final max = stats.max;
    final binWidth = (max - min) / 10;

    final bins = List<int>.filled(10, 0);
    for (final point in filteredData) {
      final binIndex = ((point.value - min) / binWidth).floor();
      if (binIndex >= 0 && binIndex < bins.length) {
        bins[binIndex]++;
      }
    }

    return List.generate(10, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: bins[index].toDouble(),
            width: binWidth * 0.8,
            color: Theme.of(context).primaryColor,
          ),
        ],
      );
    });
  }

  Widget _buildTrendAnalysis() {
    final trend = _calculateTrend();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trend Analysis',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              trend > 0
                  ? Icons.trending_up
                  : trend < 0
                      ? Icons.trending_down
                      : Icons.trending_flat,
              color: _getTrendColor(trend),
            ),
            const SizedBox(width: 8),
            Text(
              _getTrendDescription(trend),
              style: TextStyle(color: _getTrendColor(trend)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildPredictionBand(),
      ],
    );
  }

  Widget _buildPredictionBand() {
    return SizedBox(
      height: 100,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            // Actual data line
            LineChartBarData(
              spots: filteredData
                  .map((point) => FlSpot(
                        point.timestamp.millisecondsSinceEpoch.toDouble(),
                        point.value,
                      ))
                  .toList(),
              isCurved: true,
              color: Theme.of(context).primaryColor,
            ),
            // Prediction band
            ..._getPredictionBands(),
          ],
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
        ),
      ),
    );
  }

  List<LineChartBarData> _getPredictionBands() {
    // Implement prediction bands using simple linear regression
    // This is a simplified version - you might want to use more sophisticated
    // statistical methods for real applications
    return [];
  }

  double _calculateTrend() {
    if (filteredData.length < 2) return 0;

    // Simple linear regression
    final n = filteredData.length;
    final sumX = filteredData.fold(0.0,
        (sum, point) => sum + point.timestamp.millisecondsSinceEpoch);
    final sumY = filteredData.fold(0.0, (sum, point) => sum + point.value);
    final sumXY = filteredData.fold(
        0.0,
        (sum, point) =>
            sum + point.timestamp.millisecondsSinceEpoch * point.value);
    final sumXX = filteredData.fold(
        0.0,
        (sum, point) =>
            sum + point.timestamp.millisecondsSinceEpoch * point.timestamp.millisecondsSinceEpoch);

    final slope = (n * sumXY - sumX * sumY) / (n * sumXX - sumX * sumX);
    return slope;
  }

  Color _getTrendColor(double trend) {
    if (trend.abs() < 0.001) return Colors.grey;
    if (trend > 0) return Colors.green;
    return Colors.red;
  }

  String _getTrendDescription(double trend) {
    if (trend.abs() < 0.001) return 'Stable';
    if (trend > 0) return 'Increasing trend';
    return 'Decreasing trend';
  }
}